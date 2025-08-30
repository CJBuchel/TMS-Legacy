use anyhow::Result;
use tokio::sync::oneshot;

use crate::{TmsConfig, auth::initialize_jwt_secret, db::initialize_db, web::TmsWeb};

const SERVER_LOOP_PERIOD_MS: u64 = 10;
const SERVER_WARNING_THRESHOLD_MS: u64 = 100;

pub struct TmsServer {
  config: TmsConfig,
  shutdown_rx: Option<oneshot::Receiver<()>>,
}

pub struct TmsServerHandle {
  shutdown_tx: Option<oneshot::Sender<()>>,
}

impl TmsServer {
  pub fn new(config: Option<TmsConfig>) -> (Self, TmsServerHandle) {
    let config = match config {
      Some(cfg) => cfg,
      None => TmsConfig::parse_from_cli(),
    };

    let (shutdown_tx, shutdown_rx) = oneshot::channel();

    let server = TmsServer {
      config,
      shutdown_rx: Some(shutdown_rx),
    };

    let handle = TmsServerHandle {
      shutdown_tx: Some(shutdown_tx),
    };

    (server, handle)
  }

  pub async fn run(mut self) -> Result<()> {
    log::info!("Server running with config: {:?}", self.config);

    // Take the shutdown receiver (can only be used once)
    let mut shutdown_rx = self.shutdown_rx.take().expect("Server can only be run once");

    // Create interval for regular server ticks
    let mut interval = tokio::time::interval(tokio::time::Duration::from_millis(SERVER_LOOP_PERIOD_MS));

    // Setups
    initialize_db(&self.config).await?;
    initialize_jwt_secret().await?;

    // Create shutdown channel for web server
    let (web_shutdown_tx, web_shutdown_rx) = oneshot::channel();

    let web_server = TmsWeb::new(self.config.addr, self.config.port, self.config.tls);
    let web_handle = tokio::spawn(async move {
      if let Err(e) = web_server.run(web_shutdown_rx).await {
        log::error!("Web server error: {:?}", e);
      }
    });

    // Main server loop using select!
    loop {
      tokio::select! {
        // Regular server tick
        _ = interval.tick() => {
          // Do server work here

          let start = std::time::Instant::now();
          self.update().await?;
          let duration = start.elapsed();

          if duration.as_millis() > SERVER_WARNING_THRESHOLD_MS as u128 {
            log::warn!("Server work took {}ms (threshold: {}ms)",
                      duration.as_millis(),
                      SERVER_WARNING_THRESHOLD_MS);
          }
        }

        // Wait for shutdown signal
        _ = &mut shutdown_rx => {
          log::info!("Shutdown signal received");
          break;
        }
      }
    }

    // Gracefully shutdown the web server
    log::info!("Shutting down web server...");
    let _ = web_shutdown_tx.send(());

    // Wait for web server to shut down gracefully (with timeout)
    match tokio::time::timeout(std::time::Duration::from_secs(5), web_handle).await {
      Ok(result) => {
        if let Err(e) = result {
          log::error!("Web server task panicked: {:?}", e);
        } else {
          log::info!("Web server shut down gracefully");
        }
      }
      Err(_) => {
        log::warn!("Web server did not shut down within timeout, terminating...");
      }
    }

    log::info!("Server exiting gracefully");
    Ok(())
  }

  async fn update(&self) -> Result<()> {
    Ok(())
  }
}

impl TmsServerHandle {
  /// Request graceful shutdown
  pub fn shutdown(mut self) {
    if let Some(tx) = self.shutdown_tx.take() {
      let _ = tx.send(()); // Ignore error if receiver is already dropped
    }
  }
}
