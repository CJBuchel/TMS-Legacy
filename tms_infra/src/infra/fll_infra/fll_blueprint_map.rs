use std::collections::HashMap;

use super::{BaseSeason, BioglowFounders, BioglowFuture, FllBlueprint, MasterPiece, QuestionAnswer, QuestionValidationError, Submerged, Unearthed};

const SEASONS: &[(&str, &'static dyn BaseSeason)] = &[
  ("2023", &MasterPiece {}),
  ("2024", &Submerged {}),
  ("2025", &Unearthed {}),
  ("2026-Founders", &BioglowFounders {}),
  ("2026-Future", &BioglowFuture {}),
];

pub struct FllBlueprintMap {}

impl FllBlueprintMap {
  pub fn validate(season: String, answers: Vec<QuestionAnswer>) -> Option<Vec<QuestionValidationError>> {
    // switch to hashmap, for faster lookup
    let answers_map: HashMap<String, QuestionAnswer> = answers.iter().map(|a| (a.question_id.clone(), a.clone())).collect();
    // match_season!(season, validate(answers))
    SEASONS.iter().find(|(s, _)| *s == season).map(|(_, season)| season.validate(&answers_map))
  }

  pub fn calculate_score(blueprint: FllBlueprint, answers: Vec<QuestionAnswer>) -> i32 {
    // switch to hashmap, for faster lookup
    let answers_map: HashMap<String, QuestionAnswer> = answers.iter().map(|a| (a.question_id.clone(), a.clone())).collect();

    blueprint.robot_game_questions.iter().map(|q| q.get_score(&answers_map)).sum()
  }

  pub fn get_fll_blueprint(season: String) -> Option<FllBlueprint> {
    // match_season!(season, get_fll_game())
    SEASONS.iter().find(|(s, _)| *s == season).map(|(_, season)| season.get_fll_game())
  }

  pub fn get_seasons() -> Vec<String> {
    SEASONS.iter().map(|(s, _)| s.to_string()).collect()
  }
}
