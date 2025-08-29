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
    initialize_db(&self.config.db_path).await?;
    initialize_jwt_secret().await?;

    let web_server = TmsWeb::new(self.config.addr, self.config.port);
    tokio::spawn(async move {
      if let Err(e) = web_server.run().await {
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
