use std::collections::HashMap;

use super::{FllBlueprint, QuestionAnswer, QuestionValidationError};

pub mod fll_2023;
pub use fll_2023::*;

pub mod fll_2024;
pub use fll_2024::*;

pub mod fll_2025;
pub use fll_2025::*;

pub mod fll_2026;
pub use fll_2026::*;

// seasons are only reached through FllBlueprintMap, not bridged to dart
#[flutter_rust_bridge::frb(ignore)]
pub trait BaseSeason {
  fn validate(&self, answers: &HashMap<String, QuestionAnswer>) -> Vec<QuestionValidationError>;
  fn get_season(&self) -> String;
  fn get_fll_game(&self) -> FllBlueprint;
}
