use warp::Filter;

use crate::{
  database::SharedDatabase,
  network::{
    handlers::{register_handler, unregister_handler},
    with_clients, with_db, ClientMap,
  },
};

use super::header_filters::auth_token_filter::check_auth_token_filter;

pub fn registration_filter(clients: ClientMap, db: SharedDatabase, tls: bool) -> impl warp::Filter<Extract = impl warp::Reply, Error = warp::Rejection> + Clone {
  let register_path = warp::path("register");

  let register = register_path
    .and(warp::post())
    .and(warp::body::json())
    .and(with_clients(clients.clone()))
    .and(with_db(db.clone()))
    .and(warp::any().map(move || tls))
    .and_then(register_handler);

  let unregister = register_path
    .and(warp::delete())
    .and(warp::path::param())
    .and(with_clients(clients.clone()))
    .and(check_auth_token_filter(clients.clone()))
    .and_then(unregister_handler);

  register.or(unregister)
}
