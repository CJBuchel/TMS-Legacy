use axum::{Router, routing::get};

pub async fn hello_world() -> String {
  "Hello, Tournament!".to_string()
}

pub fn routes() -> Router {
  Router::new().route("/", get(hello_world))
}
