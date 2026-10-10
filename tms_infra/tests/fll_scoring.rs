use tms_infra::infra::fll_infra::{FllBlueprintMap, QuestionAnswer};
use tms_infra::QuestionInput;

// Default answers for a season, with the given (question id, answer) overrides applied
fn answers(season: &str, overrides: &[(&str, &str)]) -> Vec<QuestionAnswer> {
  let bp = FllBlueprintMap::get_fll_blueprint(season.to_string()).unwrap();
  for (id, _) in overrides {
    assert!(bp.robot_game_questions.iter().any(|q| q.id == *id), "unknown question {}", id);
  }
  bp.robot_game_questions
    .iter()
    .map(|q| {
      let QuestionInput::Categorical(c) = &q.input;
      let answer = overrides.iter().find(|(id, _)| *id == q.id).map(|(_, a)| a.to_string()).unwrap_or(c.default_option.clone());
      assert!(c.options.iter().any(|o| o.label == answer), "{} has no option {}", q.id, answer);
      QuestionAnswer { question_id: q.id.clone(), answer }
    })
    .collect()
}

fn score(season: &str, overrides: &[(&str, &str)]) -> i32 {
  let bp = FllBlueprintMap::get_fll_blueprint(season.to_string()).unwrap();
  FllBlueprintMap::calculate_score(bp, answers(season, overrides))
}

fn n_errors(season: &str, overrides: &[(&str, &str)]) -> usize {
  FllBlueprintMap::validate(season.to_string(), answers(season, overrides)).unwrap().len()
}

const FO: &str = "2026-Founders";
const FU: &str = "2026-Future";

#[test]
fn every_season_has_valid_defaults_and_mission_questions() {
  for season in FllBlueprintMap::get_seasons() {
    let bp = FllBlueprintMap::get_fll_blueprint(season.clone()).unwrap();
    assert_eq!(n_errors(&season, &[]), 0, "{} defaults fail validation", season);
    for q in &bp.robot_game_questions {
      assert!(bp.robot_game_missions.iter().any(|m| q.id.starts_with(&m.id)), "{} {} has no mission", season, q.id);
    }
  }
}

#[test]
fn unearthed_2025() {
  // defaults: m04b supports standing (10) + precision (50)
  assert_eq!(score("2025", &[]), 60);
  // m03: opposing minecart bonus needs your own minecart across
  assert_eq!(score("2025", &[("m03b", "Yes")]), 60);
  assert_eq!(score("2025", &[("m03a", "Yes"), ("m03b", "Yes")]), 100);
  // m11: crane flag bonus needs both the artifacts raised and the flag lowered
  assert_eq!(score("2025", &[("m11a", "Yes")]), 80);
  assert_eq!(score("2025", &[("m11b", "Yes")]), 60);
  assert_eq!(score("2025", &[("m11a", "Yes"), ("m11b", "Yes")]), 90);
  // m14: 5 points per artifact in the forum
  assert_eq!(score("2025", &[("m14a", "7")]), 95);
}

#[test]
fn bioglow_founders() {
  // defaults: m10a + m10b (20) + precision (50)
  assert_eq!(score(FO, &[]), 70);
  assert_eq!(score(FO, &[("m00a", "Yes")]), 90);
  // m01
  assert_eq!(score(FO, &[("m01a", "Yes")]), 90);
  assert_eq!(score(FO, &[("m01a", "Yes"), ("m01b", "Yes")]), 100);
  assert_eq!(score(FO, &[("m01b", "Yes")]), 70);
  assert_eq!(n_errors(FO, &[("m01b", "Yes")]), 1);
  assert_eq!(score(FO, &[("m02a", "3")]), 100);
  // m03
  assert_eq!(score(FO, &[("m03a", "Yes"), ("m03b", "Yes")]), 100);
  assert_eq!(score(FO, &[("m03b", "Yes")]), 70);
  // m04
  assert_eq!(score(FO, &[("m04a", "1")]), 80);
  assert_eq!(score(FO, &[("m04a", "2")]), 100);
  assert_eq!(score(FO, &[("m04a", "2"), ("m04b", "No")]), 80);
  assert_eq!(score(FO, &[("m04a", "1"), ("m04b", "No")]), 80);
  assert_eq!(score(FO, &[("m04a", "2"), ("m04c", "No")]), 70);
  assert_eq!(score(FO, &[("m04a", "1"), ("m04c", "No")]), 70);
  assert_eq!(n_errors(FO, &[("m04a", "2"), ("m04b", "No")]), 1);
  assert_eq!(n_errors(FO, &[("m04a", "1"), ("m04c", "No")]), 1);
  // m05
  assert_eq!(score(FO, &[("m05a", "Partially extended")]), 80);
  assert_eq!(score(FO, &[("m05a", "Completely extended")]), 90);
  // m06
  assert_eq!(score(FO, &[("m06b", "4")]), 70);
  assert_eq!(score(FO, &[("m06a", "Yes")]), 70);
  assert_eq!(score(FO, &[("m06a", "Yes"), ("m06b", "3")]), 100);
  assert_eq!(n_errors(FO, &[("m06b", "4")]), 1);
  // m07
  assert_eq!(score(FO, &[("m07a", "Yes")]), 90);
  assert_eq!(score(FO, &[("m07a", "Yes"), ("m07b", "2")]), 110);
  assert_eq!(score(FO, &[("m07b", "2")]), 70);
  // m08 - m13
  assert_eq!(score(FO, &[("m08a", "Yes")]), 100);
  assert_eq!(score(FO, &[("m09a", "Yes"), ("m09b", "Yes"), ("m09c", "Yes")]), 100);
  assert_eq!(score(FO, &[("m10a", "No"), ("m10b", "No")]), 50);
  assert_eq!(score(FO, &[("m11a", "Yes")]), 90);
  assert_eq!(score(FO, &[("m12a", "Yes"), ("m12b", "Yes")]), 100);
  assert_eq!(score(FO, &[("m13a", "Yes")]), 100);
  // m14: bonus is capped at the seeds in the station
  for a in 0..=4 {
    for b in 0..=4 {
      let (sa, sb) = (a.to_string(), b.to_string());
      assert_eq!(score(FO, &[("m14a", &sa), ("m14b", &sb)]), 70 + a * 5 + b.min(a) * 5, "m14 {} {}", a, b);
    }
  }
  assert_eq!(n_errors(FO, &[("m14a", "1")]), 1);
  assert_eq!(n_errors(FO, &[("m14a", "4"), ("m02a", "3"), ("m09c", "Yes"), ("m14b", "4")]), 0);
  assert_eq!(n_errors(FO, &[("m14a", "2"), ("m02a", "3"), ("m14b", "3")]), 1);
  // m15: environmental bonus only for the feature matching the dock
  for (dock, feature) in [("Mine", "m15a"), ("City", "m15b"), ("Farm", "m15c")] {
    for f in ["m15a", "m15b", "m15c"] {
      assert_eq!(score(FO, &[(f, "Yes"), ("m15d", dock)]), if f == feature { 90 } else { 80 }, "{} {}", dock, f);
    }
    assert_eq!(score(FO, &[("m15d", dock)]), 70);
    assert_eq!(score(FO, &[("m15a", "Yes"), ("m15b", "Yes"), ("m15c", "Yes"), ("m15d", dock)]), 110);
  }
  assert_eq!(score(FO, &[("m15a", "Yes"), ("m15b", "Yes"), ("m15c", "Yes")]), 100);
  // precision
  for (tokens, points) in [("0", 0), ("1", 10), ("2", 15), ("3", 25), ("4", 35), ("5", 50), ("6", 50)] {
    assert_eq!(score(FO, &[("m16a", tokens)]), 20 + points);
  }
  // max score
  let all = [
    ("m00a", "Yes"),
    ("m01a", "Yes"),
    ("m01b", "Yes"),
    ("m02a", "3"),
    ("m03a", "Yes"),
    ("m03b", "Yes"),
    ("m04a", "2"),
    ("m05a", "Completely extended"),
    ("m06a", "Yes"),
    ("m06b", "4"),
    ("m07a", "Yes"),
    ("m07b", "2"),
    ("m08a", "Yes"),
    ("m09a", "Yes"),
    ("m09b", "Yes"),
    ("m09c", "Yes"),
    ("m11a", "Yes"),
    ("m12a", "Yes"),
    ("m12b", "Yes"),
    ("m13a", "Yes"),
    ("m14a", "4"),
    ("m14b", "4"),
    ("m15a", "Yes"),
    ("m15b", "Yes"),
    ("m15c", "Yes"),
    ("m15d", "City"),
  ];
  assert_eq!(score(FO, &all), 530);
  assert_eq!(n_errors(FO, &all), 0);
}

#[test]
fn bioglow_future() {
  assert_eq!(score(FU, &[]), 0);
  assert_eq!(score(FU, &[("m01a", "3"), ("m01b", "2"), ("m01c", "1")]), 120);
  // queen bonus needs three in the young forest
  assert_eq!(score(FU, &[("m01a", "3"), ("m01d", "Yes")]), 100);
  assert_eq!(score(FU, &[("m01a", "2"), ("m01d", "Yes")]), 40);
  assert_eq!(score(FU, &[("m01d", "Yes")]), 0);
  assert_eq!(score(FU, &[("m02a", "15"), ("m02b", "12")]), 75 + 120);
  assert_eq!(score(FU, &[("m03a", "50")]), 250);
  assert_eq!(score(FU, &[("m03a", "17")]), 85);
  assert_eq!(score(FU, &[("m04a", "Yes"), ("m04b", "Yes")]), 50);
  assert_eq!(score(FU, &[("m05a", "23")]), 115);
  assert_eq!(score(FU, &[("m06a", "5"), ("m06b", "6")]), 160);
  // only the added invasive species plus the queen can be contained
  assert_eq!(n_errors(FU, &[("m06a", "5"), ("m06b", "6")]), 0);
  assert_eq!(n_errors(FU, &[("m06b", "1")]), 0);
  assert_eq!(n_errors(FU, &[("m06b", "2")]), 1);
  assert_eq!(n_errors(FU, &[("m06a", "2"), ("m06b", "4")]), 1);
}

#[test]
fn bioglow_mission_images_exist() {
  let client = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../tms_client");
  for season in [FO, FU] {
    for m in FllBlueprintMap::get_fll_blueprint(season.to_string()).unwrap().robot_game_missions {
      let image = m.image_url.unwrap_or_else(|| panic!("{} {} has no image", season, m.id));
      assert!(client.join(&image).exists(), "missing {}", image);
    }
  }
}
