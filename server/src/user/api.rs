use anyhow::Result;
use axum::{
  Router,
  extract::Json,
  http::StatusCode,
  middleware,
  response::Json as ResponseJson,
  routing::{get, post},
};
use serde::{Deserialize, Serialize};

use super::{User, UserRepository};
use crate::core::auth::Auth;

#[derive(Deserialize)]
pub struct LoginRequest {
  pub username: String,
  pub password: String,
}

#[derive(Serialize)]
pub struct LoginResponse {
  pub token: String,
  pub roles: Vec<String>,
}

async fn login(Json(payload): Json<LoginRequest>) -> Result<ResponseJson<LoginResponse>, StatusCode> {
  // Get user by username
  let users = User::get_by_username(&payload.username).await.map_err(|e| {
    log::error!("Database error: {}", e);
    StatusCode::INTERNAL_SERVER_ERROR
  })?;

  // Check if user exists
  let user = users.values().next().ok_or_else(|| {
    log::warn!("Login attempt with invalid username: {}", payload.username);
    StatusCode::UNAUTHORIZED
  })?;

  if user.password != payload.password {
    log::warn!("Login attempt with invalid password for user: {}", payload.username);
    return Err(StatusCode::UNAUTHORIZED);
  }

  // Generate JWT token
  let token = Auth::generate_token(&user.username, user.roles.clone()).map_err(|e| {
    log::error!("Failed to generate token: {}", e);
    StatusCode::INTERNAL_SERVER_ERROR
  })?;

  log::info!("User {} logged in successfully", user.username);

  Ok(ResponseJson(LoginResponse {
    token,
    roles: user.roles.iter().map(|r| r.to_string()).collect(),
  }))
}

async fn validate_token() -> Result<StatusCode, StatusCode> {
  log::info!("Token is valid");
  Ok(StatusCode::OK)
}

pub fn routes() -> Router {
  Router::new().route("/login", post(login)).merge(
    Router::new()
      .route("/verify", get(validate_token))
      .layer(middleware::from_fn(Auth::auth_middleware)),
  )
}
