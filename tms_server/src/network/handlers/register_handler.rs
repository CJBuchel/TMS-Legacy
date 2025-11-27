use tms_infra::*;

use crate::{database::*, network::*};

use rand::Rng;

fn generate_auth_token() -> String {
  rand::thread_rng().sample_iter(&rand::distributions::Alphanumeric).take(32).map(char::from).collect()
}

async fn register_client(uuid: String, auth_token: String, user_id: String, clients: ClientMap) {
  let mut write_clients = clients.write().await;
  write_clients.insert(uuid.clone(), Client::new(auth_token, user_id, None));
  log::debug!("Client registered: {}", uuid);
}

pub async fn register_handler(body: RegisterRequest, clients: ClientMap, db: SharedDatabase, tls: bool) -> ResponseResult<impl warp::reply::Reply> {
  let uuid = uuid::Uuid::new_v4().to_string();
  let auth_token = generate_auth_token();

  // read db access
  let read_db = db.read().await;

  // if username/password
  if let (Some(username), Some(password)) = (body.username, body.password) {
    let result = read_db.get_user_by_username(username.clone()).await;

    if let Some((id, user)) = result {
      if user.password == password {
        log::debug!("User `{}` logged in", username);
        // create client
        register_client(uuid.clone(), auth_token.clone(), id.clone(), clients).await;
        return Ok(warp::reply::json(&RegisterResponse {
          auth_token,
          uuid: uuid.clone(),
          protocol: if tls { "wss".to_string() } else { "ws".to_string() },
          roles: read_db.get_user_roles(id).await,
        }));
      }
    }
  }

  // no username/password or invalid username/password (use public user)
  log::debug!("No username/password or invalid username/password, using public user");
  match read_db.get_user_by_username("public".to_string()).await {
    Some((id, _)) => {
      // create client
      register_client(uuid.clone(), auth_token.clone(), id.clone(), clients).await;
      log::debug!("Public user logged in");
      return Ok(warp::reply::json(&RegisterResponse {
        auth_token,
        uuid: uuid.clone(),
        protocol: if tls { "wss".to_string() } else { "ws".to_string() },
        roles: read_db.get_user_roles(id).await,
      }));
    }
    None => {
      log::warn!("Public user not found in database");
    }
  }

  // register client normally without username/password
  log::warn!("No default users found, registering blank client");
  register_client(uuid.clone(), auth_token.clone(), "".to_string(), clients).await;
  return Ok(warp::reply::json(&RegisterResponse {
    auth_token,
    uuid,
    protocol: if tls { "wss".to_string() } else { "ws".to_string() },
    roles: Vec::new(),
  }));
}

pub async fn unregister_handler(uuid: String, clients: ClientMap) -> ResponseResult<impl warp::reply::Reply> {
  let mut write_clients = clients.write().await;
  write_clients.remove(&uuid);
  log::debug!("Client unregistered: {}", uuid);
  Ok(warp::http::StatusCode::OK)
}
