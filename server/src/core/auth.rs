use anyhow::Result;
use axum::{
  body::Body,
  extract::Request,
  middleware::Next,
  response::{IntoResponse, Response},
};
use jsonwebtoken::{DecodingKey, EncodingKey};
use once_cell::sync::OnceCell;
use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::{secret::Secret, secret::SecretRepository};

use super::permissions::Role;

// lazy once cell
static JWT_SECRET: OnceCell<Vec<u8>> = OnceCell::new();

pub async fn initialize_jwt_secret() -> Result<()> {
  log::info!("Initializing JWT secret");

  // check if JWT_SECRET is already set
  if JWT_SECRET.get().is_some() {
    log::warn!("JWT_SECRET already initialized");
  } else {
    // check if JWT exists in the db
    let secret = Secret::get().await?;
    JWT_SECRET.set(secret).map_err(|_| {
      log::error!("Failed to set JWT_SECRET");
      anyhow::anyhow!("Failed to set JWT_SECRET")
    })?;
  }

  Ok(())
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Claims {
  pub sub: String,      // User ID
  pub exp: usize,       // Expiration time (as UTC timestamp)
  pub roles: Vec<Role>, // User roles
}

#[derive(Debug, Error)]
pub enum AuthError {
  #[error("Token expired")]
  Expired,
  #[error("Invalid token")]
  Invalid,
  #[error("Token decoding error: {0}")]
  DecodingError(#[from] jsonwebtoken::errors::Error),
}

impl IntoResponse for AuthError {
  fn into_response(self) -> Response {
    let (status, error_message) = match self {
      AuthError::Expired => (axum::http::StatusCode::UNAUTHORIZED, "Token expired"),
      AuthError::Invalid => (axum::http::StatusCode::UNAUTHORIZED, "Invalid token"),
      AuthError::DecodingError(_) => (axum::http::StatusCode::BAD_REQUEST, "Token decoding error"),
    };

    let body = serde_json::json!({ "error": error_message });

    (status, axum::Json(body)).into_response()
  }
}

pub struct Auth;

impl Auth {
  fn encoding_key() -> Result<EncodingKey> {
    let secret = match JWT_SECRET.get() {
      Some(secret) => secret,
      None => return Err(anyhow::anyhow!("JWT_SECRET not initialized")),
    };

    Ok(EncodingKey::from_secret(&secret))
  }

  fn decoding_key() -> Result<DecodingKey> {
    let secret = match JWT_SECRET.get() {
      Some(secret) => secret,
      None => return Err(anyhow::anyhow!("JWT_SECRET not initialized")),
    };

    Ok(DecodingKey::from_secret(&secret))
  }

  pub fn generate_token(user_id: &str, roles: Vec<Role>) -> Result<String> {
    // Expiration time is set to 7 days from now
    let exp = match chrono::Utc::now().checked_add_signed(chrono::Duration::days(7)) {
      Some(dt) => dt.timestamp(),
      None => return Err(anyhow::anyhow!("Failed to get current time").into()),
    };

    let claims = Claims {
      sub: user_id.to_string(),
      exp: exp as usize,
      roles,
    };

    let token = jsonwebtoken::encode(&jsonwebtoken::Header::default(), &claims, &Self::encoding_key()?)?;

    Ok(token)
  }

  pub fn validate_token(token: &str) -> Result<Claims, AuthError> {
    let token_data = jsonwebtoken::decode::<Claims>(
      token,
      &Self::decoding_key().map_err(|_| AuthError::Invalid)?,
      &jsonwebtoken::Validation::default(),
    )?;

    // Check if the token is expired
    if token_data.claims.exp < chrono::Utc::now().timestamp() as usize {
      return Err(AuthError::Expired);
    }

    Ok(token_data.claims)
  }

  pub async fn auth_middleware(mut req: Request, next: Next) -> Result<Response<Body>, AuthError> {
    log::info!("Authenticating request: {} {}", req.method(), req.uri());
    let token = req
      .headers()
      .get("Authorization")
      .and_then(|h| h.to_str().ok())
      .map(|h| h.trim_start_matches("Bearer "));

    match token {
      Some(token) => match Auth::validate_token(token) {
        Ok(claims) => {
          req.extensions_mut().insert(claims);
          Ok(next.run(req).await)
        }
        Err(AuthError::Expired) => {
          log::warn!("Token expired");
          Err(AuthError::Expired)
        }
        Err(e) => {
          log::error!("Failed to validate token: {}", e);
          Err(AuthError::Invalid)
        }
      },
      None => {
        log::warn!("No token found");
        Err(AuthError::Invalid)
      }
    }
  }
}
