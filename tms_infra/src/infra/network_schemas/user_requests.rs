use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

use crate::{infra::DataSchemeExtensions, User};

#[derive(Serialize, Deserialize, Debug, JsonSchema)]
#[derive(Default)]
pub struct UserInsertRequest {
  pub user_id: Option<String>,
  pub user: User,
}


#[derive(Serialize, Deserialize, Debug, JsonSchema)]
pub struct UserRemoveRequest {
  pub user_id: String,
}

impl Default for UserRemoveRequest {
  fn default() -> Self {
    Self {
      user_id: "".to_string(),
    }
  }
}

impl DataSchemeExtensions for UserInsertRequest {}
impl DataSchemeExtensions for UserRemoveRequest {}