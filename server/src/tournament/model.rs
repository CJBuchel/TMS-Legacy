use database::Record;
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Tournament {
  pub bootstrapped: bool,
  pub name: String,
  pub backup_interval: u32,
  pub retain_backups: u32,
  pub end_game_timer_length: u32,
  pub game_timer_length: u32,
  pub season: Option<String>,
}

impl Default for Tournament {
  fn default() -> Self {
    Self {
      bootstrapped: false,
      name: "TMS Tournament".to_string(),
      backup_interval: 15,
      retain_backups: 10,
      end_game_timer_length: 5,
      game_timer_length: 30,
      season: None,
    }
  }
}

impl Record for Tournament {
  fn table_name() -> &'static str {
    "tournament"
  }
}
