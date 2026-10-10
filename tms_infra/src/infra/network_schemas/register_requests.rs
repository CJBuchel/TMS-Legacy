use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

use crate::infra::{DataSchemeExtensions, TmsTreeRole};

#[derive(Serialize, Deserialize, JsonSchema)]
#[derive(Default)]
pub struct RegisterRequest {
  pub username: Option<String>, // optionally log in with username/password
  pub password: Option<String>,
}


#[derive(Serialize, Deserialize, JsonSchema)]
pub struct RegisterResponse {
  pub auth_token: String,
  pub uuid: String,
  pub protocol: String, // ws or wss
  pub roles: Vec<TmsTreeRole>,
}

impl Default for RegisterResponse {
  fn default() -> Self {
    Self {
      auth_token: "".to_string(),
      uuid: "".to_string(),
      protocol: "".to_string(),
      roles: Vec::new(),
    }
  }
}

impl DataSchemeExtensions for RegisterRequest {}
impl DataSchemeExtensions for RegisterResponse {}
