use axum::{Router, routing::get};

use crate::{tournament, user};

pub fn routes() -> Router {
  Router::new()
    .route("/", get(|| async { "API Is working" }))
    .nest("/users", user::routes())
    .nest("/tournament", tournament::routes())
}
