#![forbid(unsafe_code)]
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::sync::Arc;

use launcher::{gui, logging, GuiMessage, ServerState};
use parking_lot::Mutex;
use tokio::sync::{mpsc, oneshot};

// tokio main
#[tokio::main]
async fn main() {
  // Initialize logger
  logging::init_logging().expect("Failed to initialize logger");

  // Parse CLI args
  let config = server::TmsConfig::parse_from_cli();

  if config.no_gui {
    // Start without GUI
    log::info!("Starting TMS (No GUI)");
    let (server, handle) = server::TmsServer::new(Some(config));

    // Spawn the server task
    let mut server_task = tokio::spawn(async move { server.run().await });

    // Set up signal handling for graceful shutdown
    let shutdown_signal = async {
      #[cfg(unix)]
      {
        use tokio::signal::unix::{signal, SignalKind};

        let mut sigterm = signal(SignalKind::terminate()).expect("Failed to register SIGTERM handler");
        let mut sigint = signal(SignalKind::interrupt()).expect("Failed to register SIGINT handler");

        tokio::select! {
          _ = sigterm.recv() => log::info!("Received SIGTERM"),
          _ = sigint.recv() => log::info!("Received SIGINT"),
        }
      }

      #[cfg(windows)]
      {
        tokio::signal::ctrl_c().await.expect("Failed to listen for Ctrl+C");
        log::info!("Received Ctrl+C");
      }
    };

    tokio::select! {
      // Wait for server to complete normally
      result = &mut server_task => {
        match result {
          Ok(Ok(_)) => log::info!("Server exited gracefully"),
          Ok(Err(e)) => log::error!("Server exited with error: {}", e),
          Err(e) => log::error!("Server task panicked: {}", e),
        }
      }

      // Wait for shutdown signal (Ctrl+C, SIGTERM, etc.)
      _ = shutdown_signal => {
        log::info!("Shutdown signal received, stopping server gracefully...");
        handle.shutdown();

        // Wait for server to actually stop (with timeout)
        match tokio::time::timeout(std::time::Duration::from_secs(5), server_task).await {
          Ok(Ok(Ok(_))) => log::info!("Server stopped gracefully"),
          Ok(Ok(Err(e))) => log::error!("Server stopped with error: {}", e),
          Ok(Err(e)) => log::error!("Server task panicked during shutdown: {}", e),
          Err(_) => {
            log::error!("Server did not stop within 5 seconds, forcing exit");
            std::process::exit(1);
          }
        }
      }
    }
  } else {
    // Start with GUI
    log::info!("Starting TMS");

    // Create channel for GUI messages
    let (gui_tx, gui_rx) = mpsc::channel::<GuiMessage>(32);
    let (done_tx, _) = oneshot::channel();

    // Create shared server state
    let shared_state = Arc::new(Mutex::new(ServerState::Stopped));

    // Clone for server thread
    let server_state = shared_state.clone();

    // Start server management thread
    let mut server_handle = tokio::task::spawn_blocking(move || {
      let rt = tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .build()
        .expect("Failed to create Tokio runtime for management thread");

      rt.block_on(async move {
        run_server_management(gui_rx, server_state).await;
        // Signal that the server management thread has exited
        let _ = done_tx.send(());
      });
    });

    // Start GUI
    if let Err(e) = gui::run_gui(gui_tx, shared_state, config) {
      log::error!("GUI error: {}", e);
    }

    // Wait for server management thread to exit
    log::info!("GUI closed, waiting for server to exit...");

    let timeout_result = tokio::time::timeout(std::time::Duration::from_secs(5), &mut server_handle).await;

    match timeout_result {
      Ok(result) => {
        if let Err(e) = result {
          log::error!("Management thread exited with error: {}", e);
        } else {
          log::info!("Management thread exited gracefully");
        }
      }
      Err(_) => {
        log::error!("Management thread did not exit in time, terminating...");
        server_handle.abort();
      }
    }
  }
}

async fn run_server_management(mut rx: mpsc::Receiver<GuiMessage>, server_state: Arc<Mutex<ServerState>>) {
  // The server task and shutdown handle (None initially)
  let mut server_instance: Option<(tokio::task::JoinHandle<anyhow::Result<()>>, server::TmsServerHandle)> = None;

  // Server management loop
  loop {
    if let Some((server_task, _)) = &mut server_instance {
      // Server is running - select between GUI messages and server events
      tokio::select! {
        Some(msg) = rx.recv() => match msg {

          // Stop server
          GuiMessage::StopServer => {
            log::warn!("Stopping server");

            // Request graceful shutdown using the handle
            if let Some((_, handle)) = server_instance.take() {
              handle.shutdown();
            }

            *server_state.lock() = ServerState::Stopped;
          },

          // Exit
          GuiMessage::Exit => {
            // Shutdown server if running
            if let Some((_, handle)) = server_instance.take() {
              handle.shutdown();
            }
            break;
          },
          _ => {}
        },

        result = server_task => {
          match result {
            Ok(Ok(_)) => {
              log::info!("Server exited gracefully");
              *server_state.lock() = ServerState::Stopped;
            },
            Ok(Err(e)) => {
              log::error!("Server exited with error: {}", e);
              *server_state.lock() = ServerState::Error(e.to_string());
            },
            Err(e) => {
              log::error!("Server task panicked: {}", e);
              *server_state.lock() = ServerState::Error(e.to_string());
            }
          }

          server_instance = None;
        }
      }
    } else {
      // Server is stopped - wait for messages
      if let Some(msg) = rx.recv().await {
        log::debug!("Received message: {:?}", msg);
        match msg {
          // Start server
          GuiMessage::StartServer(config) => {
            log::info!("Starting server");

            // Create server and handle using the new API
            let (server, handle) = server::TmsServer::new(Some(config));

            // Spawn server task
            let server_task = tokio::spawn(async move { server.run().await });

            server_instance = Some((server_task, handle));
            *server_state.lock() = ServerState::Running;
          }

          // Exit
          GuiMessage::Exit => break,
          _ => {}
        }
      } else {
        // Channel closed, exit loop
        break;
      }
    }
  }
}
