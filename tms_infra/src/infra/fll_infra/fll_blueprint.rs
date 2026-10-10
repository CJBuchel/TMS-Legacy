use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

use crate::DataSchemeExtensions;

use super::{Mission, Question};

#[derive(Clone, Debug, Serialize, Deserialize, JsonSchema)]
#[derive(Default)]
pub struct FllBlueprint {
  pub robot_game_questions: Vec<Question>,
  pub robot_game_missions: Vec<Mission>,
}


impl DataSchemeExtensions for FllBlueprint {}
