use axum::{Router, routing::get};

use crate::{tournament, user};

pub fn routes() -> Router {
  Router::new()
    .route(
      "/",
      get(|| async {
        log::info!("API Is working");
        "API Is working"
      }),
    )
    .nest("/user", user::routes())
    .nest("/tournament", tournament::routes())
}
