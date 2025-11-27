use std::collections::HashMap;

use schemars::JsonSchema;

#[derive(serde::Deserialize, serde::Serialize, JsonSchema)]
pub struct EchoTreeRegisterRequest {
  pub echo_trees: Vec<String>,        // list of topics/trees the client is subscribed to
  pub roles: HashMap<String, String>, // role_id, password
}

#[derive(serde::Deserialize, serde::Serialize, JsonSchema)]
pub struct EchoTreeRegisterResponse {
  pub auth_token: String,
  pub uuid: String,
  pub protocol: String,
  pub hierarchy: HashMap<String, String>, // tree, schema
}

#[derive(serde::Deserialize, serde::Serialize, JsonSchema)]
pub struct EchoTreeRoleAuthenticateRequest {
  pub roles: HashMap<String, String>, // role_id, password
}
