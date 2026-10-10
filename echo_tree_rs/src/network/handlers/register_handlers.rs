use crate::common::{client::Client, ClientMap, EchoDB, ResponseResult};
use echo_tree_infra::{EchoTreeRegisterRequest, EchoTreeRegisterResponse};
use log::{debug, error};
use rand::RngExt;

async fn register_client(uuid: String, auth_token: String, subscribed_trees: Vec<String>, role_read_trees: Vec<String>, role_read_write_trees: Vec<String>, clients: ClientMap) {
  debug!("registering client with uuid: {}", uuid);
  clients.write().await.insert(uuid, Client::new(auth_token, role_read_trees, role_read_write_trees, subscribed_trees, None));
}

fn generate_auth_token() -> String {
  rand::rng().sample_iter(rand::distr::Alphanumeric).take(30).map(char::from).collect()
}

pub async fn register_handler(body: EchoTreeRegisterRequest, clients: ClientMap, db: EchoDB, tls: bool) -> ResponseResult<impl warp::reply::Reply> {
  let uuid = uuid::Uuid::new_v4().to_string();
  let auth_token = generate_auth_token();

  let db = db.read().await;

  // let role_read_trees: Vec<String>;
  // let role_read_write_trees: Vec<String>;
  let role_read_trees: Vec<String> = body
    .roles
    .iter()
    .flat_map(|(role_id, password)| {
      

      futures::executor::block_on(async {
        match db.get_role_manager().await.authenticate_role(role_id.clone(), password.clone()) {
          true => {
            let trees = db.get_role_manager().await.get_role_read_access(role_id.clone());
            log::debug!("role found: {}, with read trees: {:?}", role_id.clone(), trees);
            trees
          }
          false => {
            log::info!("role not found: {}", role_id.clone());
            [].to_vec()
          }
        }
      })
    })
    .collect();

  let role_read_write_trees: Vec<String> = body
    .roles
    .iter()
    .flat_map(|(role_id, password)| {
      

      futures::executor::block_on(async {
        match db.get_role_manager().await.authenticate_role(role_id.clone(), password.clone()) {
          true => {
            let trees = db.get_role_manager().await.get_role_read_write_access(role_id.clone());
            log::debug!("role found: {}, with read-write trees: {:?}", role_id.clone(), trees);
            trees
          }
          false => {
            log::info!("role not found: {}", role_id.clone());
            [].to_vec()
          }
        }
      })
    })
    .collect();

  register_client(uuid.clone(), auth_token.clone(), body.echo_trees, role_read_trees, role_read_write_trees, clients).await;

  let hierarchy = match db.get_hierarchy().await.get_trees_as_hashmap() {
    Ok(h) => h,
    Err(e) => {
      error!("get_as_hashmap failed: {}", e);
      std::collections::HashMap::new()
    }
  };

  Ok(warp::reply::json(&EchoTreeRegisterResponse {
    auth_token,
    uuid,
    protocol: if tls { "wss".to_string() } else { "ws".to_string() },
    hierarchy,
  }))
}

pub async fn unregister_handler(client_uuid: String, clients: ClientMap) -> ResponseResult<impl warp::reply::Reply> {
  debug!("un-registering client with uuid: {}", client_uuid);
  clients.write().await.remove(&client_uuid);
  Ok(warp::http::StatusCode::OK)
}
