use axum::Router;

use crate::tournament;

pub fn ws_routes() -> Router {
  Router::new().nest("/tournament", tournament::ws_routes())
}
