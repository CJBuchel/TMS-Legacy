use std::net::{IpAddr, SocketAddr};

use anyhow::Result;
use axum::{Router, routing::get};
use tokio::net::TcpListener;
use tokio::sync::oneshot;
use tower::ServiceBuilder;
use tower_http::{
  cors::CorsLayer,
  services::{ServeDir, ServeFile},
};

use crate::{api, websocket};

pub struct TmsWeb {
  addr: IpAddr,
  port: u16,
  tls: bool,
}

impl TmsWeb {
  pub fn new(addr: IpAddr, port: u16, tls: bool) -> Self {
    Self { addr, port, tls }
  }

  pub async fn run(&self, shutdown_rx: oneshot::Receiver<()>) -> Result<()> {
    log::info!("Starting TMS web server on {}:{}", self.addr, self.port);

    // Build the router with all routes
    let app = Router::new()
      .route("/health", get(|| async { "OK" }))
      .nest("/api", api::routes())
      .nest("/ws", websocket::ws_routes())
      // Static file serving as fallback
      .fallback_service(
        ServiceBuilder::new()
          .layer(CorsLayer::permissive())
          .service(ServeDir::new("client/build/web").fallback(ServeFile::new("client/build/web/index.html"))),
      )
      .layer(CorsLayer::permissive());

    let socket_addr = SocketAddr::new(self.addr, self.port);
    let listener = TcpListener::bind(&socket_addr).await?;

    // Run the server with graceful shutdown
    axum::serve(listener, app)
      .with_graceful_shutdown(async {
        shutdown_rx.await.ok();
        log::info!("Web server shutdown signal received");
      })
      .await?;

    log::info!("Web server exited gracefully");
    Ok(())
  }
}
