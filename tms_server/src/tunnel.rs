// src/tunnel.rs
use anyhow::{Context, Result};
use log::{debug, error, info, warn};
use std::path::PathBuf;
use std::process::Stdio;
use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::process::{Child, Command};

const FRP_VERSION: &str = "0.65.0";

/// Strip ANSI escape codes from a string
fn strip_ansi_codes(s: &str) -> String {
  // Regex pattern for ANSI escape codes: \x1B\[[0-9;]*[a-zA-Z]
  // Simple implementation without regex dependency
  let mut result = String::new();
  let mut chars = s.chars();

  while let Some(ch) = chars.next() {
    if ch == '\x1B' {
      // Start of ANSI escape sequence
      if chars.as_str().starts_with('[') {
        chars.next(); // consume '['
                      // Skip until we find a letter (the command character)
        while let Some(c) = chars.next() {
          if c.is_ascii_alphabetic() {
            break;
          }
        }
      }
    } else {
      result.push(ch);
    }
  }

  result
}

pub struct FrpTunnel {
  server_addr: String,
  server_port: u16,
  auth_token: String,
  subdomain: String,
  local_port: u16,
  process: Option<Child>,
}

impl FrpTunnel {
  pub fn new(token: String, subdomain: String, local_port: u16) -> Self {
    Self {
      server_addr: "tms.mobi".to_string(),
      server_port: 7000,
      auth_token: token,
      subdomain,
      local_port,
      process: None,
    }
  }

  /// Get platform-specific frpc binary name and download URL
  fn get_platform_info() -> (&'static str, &'static str, &'static str) {
    // Returns: (binary_name, platform_string, archive_ext)
    if cfg!(target_os = "windows") {
      ("frpc.exe", "windows_amd64", "zip")
    } else if cfg!(target_os = "macos") {
      if cfg!(target_arch = "aarch64") {
        ("frpc", "darwin_arm64", "tar.gz")
      } else {
        ("frpc", "darwin_amd64", "tar.gz")
      }
    } else {
      ("frpc", "linux_amd64", "tar.gz")
    }
  }

  /// Download frpc binary from GitHub releases
  async fn download_frpc(target_dir: &PathBuf) -> Result<PathBuf> {
    let (binary_name, platform, archive_ext) = Self::get_platform_info();
    let download_url = format!("https://github.com/fatedier/frp/releases/download/v{}/frp_{}_{}.{}", FRP_VERSION, FRP_VERSION, platform, archive_ext);

    info!("Downloading frpc from: {}", download_url);

    // Download archive
    let response = reqwest::get(&download_url).await.context("Failed to download frpc")?;

    if !response.status().is_success() {
      anyhow::bail!("Download failed with status: {}", response.status());
    }

    let bytes = response.bytes().await.context("Failed to read download")?;
    info!("Downloaded {} bytes", bytes.len());

    // Create temporary file for archive
    let archive_path = target_dir.join(format!("frp.{}", archive_ext));
    tokio::fs::write(&archive_path, &bytes).await.context("Failed to write archive")?;

    // Extract based on archive type
    let frpc_path = target_dir.join(binary_name);

    if archive_ext == "zip" {
      // Extract zip (Windows)
      info!("Extracting zip archive...");
      let file = std::fs::File::open(&archive_path)?;
      let mut archive = zip::ZipArchive::new(file)?;

      // Find frpc.exe in the archive
      for i in 0..archive.len() {
        let mut file = archive.by_index(i)?;
        if file.name().ends_with(binary_name) {
          let mut contents = Vec::new();
          std::io::Read::read_to_end(&mut file, &mut contents)?;
          tokio::fs::write(&frpc_path, contents).await?;
          break;
        }
      }
    } else {
      // Extract tar.gz (Linux/macOS)
      info!("Extracting tar.gz archive...");
      let tar_gz = std::fs::File::open(&archive_path)?;
      let tar = flate2::read::GzDecoder::new(tar_gz);
      let mut archive = tar::Archive::new(tar);

      for entry in archive.entries()? {
        let mut entry = entry?;
        let path = entry.path()?;

        if path.to_string_lossy().ends_with(binary_name) {
          entry.unpack(&frpc_path)?;
          break;
        }
      }
    }

    // Make executable on Unix
    #[cfg(unix)]
    {
      use std::os::unix::fs::PermissionsExt;
      let mut perms = tokio::fs::metadata(&frpc_path).await?.permissions();
      perms.set_mode(0o755);
      tokio::fs::set_permissions(&frpc_path, perms).await?;
    }

    // Cleanup archive
    tokio::fs::remove_file(&archive_path).await.ok();

    info!("✓ frpc binary ready at: {}", frpc_path.display());

    Ok(frpc_path)
  }

  /// Get path to frpc binary, downloading if necessary
  async fn ensure_frpc_binary() -> Result<PathBuf> {
    let (binary_name, _, _) = Self::get_platform_info();

    // Try locations in order
    let candidates = vec![
      // 1. Next to executable (production)
      std::env::current_exe()?.parent().context("Failed to get exe dir")?.join(binary_name),
      // 2. In user's local data directory (downloaded)
      dirs::data_local_dir().context("Failed to get local data dir")?.join("tms").join(binary_name),
    ];

    // Check if binary exists in any location
    for path in &candidates {
      if path.exists() {
        info!("Found frpc at: {}", path.display());
        return Ok(path.clone());
      }
    }

    // Binary not found, download it
    warn!("frpc binary not found, downloading...");

    let download_dir = dirs::data_local_dir().context("Failed to get local data dir")?.join("tms");

    tokio::fs::create_dir_all(&download_dir).await.context("Failed to create download directory")?;

    Self::download_frpc(&download_dir).await
  }

  /// Generate frpc configuration file
  fn generate_config(&self) -> String {
    format!(
      r#"
serverAddr = "{}"
serverPort = {}

[auth]
method = "token"
token = "{}"

[[proxies]]
name = "{}-http"
type = "http"
localPort = {}
subdomain = "{}"

[[proxies]]
name = "{}-https"
type = "https"
localPort = {}
subdomain = "{}"
"#,
      self.server_addr, self.server_port, self.auth_token, self.subdomain, self.local_port, self.subdomain, self.subdomain, self.local_port, self.subdomain
    )
  }

  /// Start the FRP tunnel
  pub async fn start(&mut self) -> Result<()> {
    info!("Starting FRP tunnel to {}:{} with subdomain '{}' (local port: {})", self.server_addr, self.server_port, self.subdomain, self.local_port);

    // Get or download frpc binary
    let frpc_path = Self::ensure_frpc_binary().await?;
    info!("Using frpc binary at: {}", frpc_path.display());

    // Create temporary config file
    let config_content = self.generate_config();
    let config_path = std::env::temp_dir().join(format!("frpc_{}.toml", self.subdomain));

    tokio::fs::write(&config_path, config_content).await.context("Failed to write frpc config")?;

    debug!("Config written to: {}", config_path.display());

    // Spawn frpc process
    let mut child = Command::new(&frpc_path)
      .arg("-c")
      .arg(&config_path)
      .stdout(Stdio::piped())
      .stderr(Stdio::piped())
      .spawn()
      .context("Failed to spawn frpc process")?;

    info!("frpc process started (PID: {})", child.id().unwrap_or(0));

    // Capture stdout for logging (strip ANSI codes)
    if let Some(stdout) = child.stdout.take() {
      let subdomain = self.subdomain.clone();
      tokio::spawn(async move {
        let reader = BufReader::new(stdout);
        let mut lines = reader.lines();

        while let Ok(Some(line)) = lines.next_line().await {
          let clean_line = strip_ansi_codes(&line);
          debug!("[frpc:{}] {}", subdomain, clean_line);
        }
      });
    }

    // Capture stderr for logging
    if let Some(stderr) = child.stderr.take() {
      let subdomain = self.subdomain.clone();
      tokio::spawn(async move {
        let reader = BufReader::new(stderr);
        let mut lines = reader.lines();

        while let Ok(Some(line)) = lines.next_line().await {
          warn!("[frpc:{}] {}", subdomain, line);
        }
      });
    }

    self.process = Some(child);

    info!("🌐 Tunnel active: https://{}.{}", self.subdomain, self.server_addr);

    Ok(())
  }

  /// Wait for the tunnel process to complete (or fail)
  pub async fn wait(&mut self) -> Result<()> {
    if let Some(child) = &mut self.process {
      let status = child.wait().await?;

      if !status.success() {
        anyhow::bail!("frpc process exited with status: {}", status);
      }
    }

    Ok(())
  }

  /// Stop the tunnel
  pub async fn stop(&mut self) -> Result<()> {
    if let Some(mut child) = self.process.take() {
      info!("Stopping FRP tunnel for subdomain '{}'", self.subdomain);

      // Try graceful shutdown first
      child.kill().await.ok();

      // Give it a moment to clean up
      tokio::time::sleep(tokio::time::Duration::from_millis(500)).await;

      info!("FRP tunnel stopped");
    }

    Ok(())
  }

  /// Check if tunnel is running
  pub fn is_running(&self) -> bool {
    self.process.is_some()
  }
}

impl Drop for FrpTunnel {
  fn drop(&mut self) {
    if let Some(child) = self.process.take() {
      // Best effort cleanup
      #[cfg(unix)]
      let _ = std::process::Command::new("kill").arg(format!("{}", child.id().unwrap_or(0))).output();

      #[cfg(windows)]
      let _ = std::process::Command::new("taskkill").arg("/F").arg("/PID").arg(format!("{}", child.id().unwrap_or(0))).output();
    }
  }
}

// Auto-restart on failure
pub async fn run_tunnel_with_retry(token: String, subdomain: String, local_port: u16) -> Result<()> {
  loop {
    let mut tunnel = FrpTunnel::new(token.clone(), subdomain.clone(), local_port);

    if let Err(e) = tunnel.start().await {
      error!("Failed to start tunnel: {}", e);
      tokio::time::sleep(tokio::time::Duration::from_secs(5)).await;
      continue;
    }

    match tunnel.wait().await {
      Ok(_) => {
        info!("Tunnel ended gracefully, restarting...");
      }
      Err(e) => {
        error!("Tunnel error: {}, retrying in 5 seconds...", e);
      }
    }

    tokio::time::sleep(tokio::time::Duration::from_secs(5)).await;
  }
}
