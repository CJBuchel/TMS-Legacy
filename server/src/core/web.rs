use std::net::{IpAddr, SocketAddr};

use anyhow::Result;
use axum::{
  Json, Router,
  extract::{State, WebSocketUpgrade, ws::WebSocket},
  http::StatusCode,
  response::Response,
  routing::{get, post},
};
use serde::{Deserialize, Serialize};
use tokio::net::TcpListener;
use tower::ServiceBuilder;
use tower_http::{
  cors::CorsLayer,
  services::{ServeDir, ServeFile},
};

#[derive(Clone)]
pub struct AppState {
  // Add any shared state here
  pub server_name: String,
}

#[derive(Serialize, Deserialize)]
pub struct ApiResponse {
  pub message: String,
  pub timestamp: String,
  pub server: String,
}

#[derive(Serialize, Deserialize)]
pub struct ApiRequest {
  pub name: Option<String>,
}

pub struct TmsWeb {
  addr: IpAddr,
  port: u16,
}

impl TmsWeb {
  pub fn new(addr: IpAddr, port: u16) -> Self {
    Self { addr, port }
  }

  pub async fn run(&self) -> Result<()> {
    log::info!("Starting TMS web server on {}:{}", self.addr, self.port);

    let state = AppState {
      server_name: "TMS Server".to_string(),
    };

    // Build the router with all routes
    let app = Router::new()
      // API routes
      .route("/api/hello", get(api_hello))
      .route("/api/echo", post(api_echo))
      // WebSocket route
      .route("/ws", get(websocket_handler))
      .with_state(state)
      // Static file serving as fallback
      .fallback_service(
        ServiceBuilder::new()
          .layer(CorsLayer::permissive())
          .service(ServeDir::new("server/static").fallback(ServeFile::new("server/static/index.html"))),
      )
      .layer(CorsLayer::permissive());

    let socket_addr = SocketAddr::new(self.addr, self.port);
    let listener = TcpListener::bind(&socket_addr).await?;

    log::info!("Web server listening on http://{}", socket_addr);
    log::info!("API endpoints available at:");
    log::info!("  - GET  /api/hello");
    log::info!("  - POST /api/echo");
    log::info!("  - WS   /ws");
    log::info!("Static files served from /static directory");

    axum::serve(listener, app).await?;

    Ok(())
  }
}

// API Handlers
async fn api_hello(State(state): State<AppState>) -> Result<Json<ApiResponse>, StatusCode> {
  let response = ApiResponse {
    message: "Hello from TMS API!".to_string(),
    timestamp: chrono::Utc::now().to_rfc3339(),
    server: state.server_name,
  };

  log::info!("API call: GET /api/hello");
  Ok(Json(response))
}

async fn api_echo(
  State(state): State<AppState>,
  Json(payload): Json<ApiRequest>,
) -> Result<Json<ApiResponse>, StatusCode> {
  let name = payload.name.unwrap_or_else(|| "Anonymous".to_string());
  let response = ApiResponse {
    message: format!("Hello, {}! This is an echo from the API.", name),
    timestamp: chrono::Utc::now().to_rfc3339(),
    server: state.server_name,
  };

  log::info!("API call: POST /api/echo with name: {}", name);
  Ok(Json(response))
}

// WebSocket Handler
async fn websocket_handler(ws: WebSocketUpgrade, State(state): State<AppState>) -> Response {
  log::info!("WebSocket connection requested");
  ws.on_upgrade(|socket| websocket_connection(socket, state))
}

async fn websocket_connection(mut socket: WebSocket, state: AppState) {
  log::info!("WebSocket connection established");

  // Send welcome message
  let welcome_msg = format!("Welcome to {}! WebSocket connection established.", state.server_name);
  if let Err(e) = socket.send(axum::extract::ws::Message::Text(welcome_msg.into())).await {
    log::error!("Failed to send welcome message: {}", e);
    return;
  }

  // Handle incoming messages
  while let Some(msg) = socket.recv().await {
    match msg {
      Ok(axum::extract::ws::Message::Text(text)) => {
        log::info!("WebSocket received text: {}", text);

        // Echo the message back with a timestamp
        let response = format!("Echo at {}: {}", chrono::Utc::now().format("%H:%M:%S"), text);

        if let Err(e) = socket.send(axum::extract::ws::Message::Text(response.into())).await {
          log::error!("Failed to send WebSocket message: {}", e);
          break;
        }
      }
      Ok(axum::extract::ws::Message::Binary(data)) => {
        log::info!("WebSocket received binary data: {} bytes", data.len());

        // Echo binary data back
        if let Err(e) = socket.send(axum::extract::ws::Message::Binary(data)).await {
          log::error!("Failed to send WebSocket binary: {}", e);
          break;
        }
      }
      Ok(axum::extract::ws::Message::Close(_)) => {
        log::info!("WebSocket connection closed by client");
        break;
      }
      Err(e) => {
        log::error!("WebSocket error: {}", e);
        break;
      }
      _ => {
        // Handle other message types (ping, pong, etc.)
      }
    }
  }

  log::info!("WebSocket connection terminated");
}
