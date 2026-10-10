use std::{collections::HashMap, vec};

use crate::{
  infra::fll_infra::{QuestionAnswer, QuestionValidationError},
  CategoricalOption, CategoricalQuestion, FllBlueprint, Mission, Question, QuestionInput, QuestionRule,
};

use super::BaseSeason;

// Options 0..=max, each worth `score_per` points
fn numeric_options(max: i32, score_per: i32) -> Vec<CategoricalOption> {
  (0..=max).map(|n| CategoricalOption { label: n.to_string(), score: n * score_per }).collect()
}

fn is_yes(answers: &HashMap<String, QuestionAnswer>, id: &str) -> bool {
  answers.get(id).map(|r| r.answer.as_str()) == Some("Yes")
}

fn number(answers: &HashMap<String, QuestionAnswer>, id: &str) -> i32 {
  answers.get(id).map(|r| r.answer.parse::<i32>().unwrap_or(0)).unwrap_or(0)
}

fn empty_answer_errors(answers: &HashMap<String, QuestionAnswer>) -> Vec<QuestionValidationError> {
  let mut errors: Vec<QuestionValidationError> = vec![];
  let mut empty_q_ids: Vec<String> = vec![];

  // Iterate over the HashMap and collect question IDs with empty answers
  let n_empty_ids = answers.values().filter(|r| r.answer.is_empty()).count();

  for (question_id, answer) in answers.iter() {
    if answer.answer.is_empty() {
      empty_q_ids.push(question_id.clone());
    }
  }

  if n_empty_ids > 0 {
    errors.push(QuestionValidationError {
      question_ids: empty_q_ids.join(","),
      message: format!("{} empty answers", n_empty_ids),
    });
  }

  errors
}

#[flutter_rust_bridge::frb(ignore)]
pub struct BioglowFounders {}
#[flutter_rust_bridge::frb(ignore)]
impl BaseSeason for BioglowFounders {
  fn validate(&self, answers: &HashMap<String, QuestionAnswer>) -> Vec<QuestionValidationError> {
    let mut errors = empty_answer_errors(answers);

    // Game specific validation rules

    // m01: the LiDAR bonus is only available once the drone has been flown
    if is_yes(answers, "m01b") && !is_yes(answers, "m01a") {
      errors.push(QuestionValidationError {
        question_ids: "m01b".to_string(),
        message: "LiDAR map flipped but the drone is still touching the mat".to_string(),
      });
    }

    // m03: the rock bonus requires the research flag to be down
    if is_yes(answers, "m03b") && !is_yes(answers, "m03a") {
      errors.push(QuestionValidationError {
        question_ids: "m03b".to_string(),
        message: "Rock returned to its starting position but the research flag is not down".to_string(),
      });
    }

    // m04: the second leaf needs the katydid in its starting position, and a katydid outside the habitat zeroes the mission
    let leaves = number(answers, "m04a");
    if leaves == 2 && !is_yes(answers, "m04b") {
      errors.push(QuestionValidationError {
        question_ids: "m04b".to_string(),
        message: "Second leaf removed but the katydid is not in its original starting position".to_string(),
      });
    }
    if !is_yes(answers, "m04c") && leaves > 0 {
      errors.push(QuestionValidationError {
        question_ids: "m04c".to_string(),
        message: "Katydid is outside the leaf habitat, M04 scores zero regardless of leaves removed".to_string(),
      });
    }

    // m06: fragments only count once the ant is touching the nest
    if number(answers, "m06b") > 0 && !is_yes(answers, "m06a") {
      errors.push(QuestionValidationError {
        question_ids: "m06b".to_string(),
        message: "Leaf fragments contained but the ant is not touching the nest".to_string(),
      });
    }

    // m07: the connection bonuses require your own mycelium completely extended
    if number(answers, "m07b") > 0 && !is_yes(answers, "m07a") {
      errors.push(QuestionValidationError {
        question_ids: "m07b".to_string(),
        message: "Connections recorded but the mycelium is not completely extended".to_string(),
      });
    }

    // m14 max possible (three seeds from m02 plus one from m09)
    let m14_max_possible = number(answers, "m02a") + if is_yes(answers, "m09c") { 1 } else { 0 };
    let m14a = number(answers, "m14a");
    let m14b = number(answers, "m14b");

    if m14a > m14_max_possible {
      errors.push(QuestionValidationError {
        question_ids: "m14a".to_string(),
        message: format!("Seeds in replantation station {} exceeds max possible {}", m14a, m14_max_possible),
      });
    }

    if m14b > m14a {
      errors.push(QuestionValidationError {
        question_ids: "m14b".to_string(),
        message: format!("Seeds touching the mat {} exceeds seeds in replantation station {}", m14b, m14a),
      });
    }

    errors
  }

  fn get_season(&self) -> String {
    "2026-Founders".to_string()
  }

  fn get_fll_game(&self) -> FllBlueprint {
    FllBlueprint {
      robot_game_missions: vec![
        Mission {
          id: "m00".to_string(),
          label: "M00 - Equipment Inspection Bonus".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m00.png".to_string()),
        },
        Mission {
          id: "m01".to_string(),
          label: "M01 - Drone Survey 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m01.png".to_string()),
        },
        Mission {
          id: "m02".to_string(),
          label: "M02 - Exploding Seeds".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m02.png".to_string()),
        },
        Mission {
          id: "m03".to_string(),
          label: "M03 - Flip the Rock".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m03.png".to_string()),
        },
        Mission {
          id: "m04".to_string(),
          label: "M04 - Lucky Leaves 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m04.png".to_string()),
        },
        Mission {
          id: "m05".to_string(),
          label: "M05 - Reaching Roots 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m05.png".to_string()),
        },
        Mission {
          id: "m06".to_string(),
          label: "M06 - Leafcutter Frenzy".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m06.png".to_string()),
        },
        Mission {
          id: "m07".to_string(),
          label: "M07 - Humongous Fungus 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m07.png".to_string()),
        },
        Mission {
          id: "m08".to_string(),
          label: "M08 - Tangled".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m08.png".to_string()),
        },
        Mission {
          id: "m09".to_string(),
          label: "M09 - Research Platform 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m09.png".to_string()),
        },
        Mission {
          id: "m10".to_string(),
          label: "M10 - Fragile Microhabitats 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m10.png".to_string()),
        },
        Mission {
          id: "m11".to_string(),
          label: "M11 - Window to the Past".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m11.png".to_string()),
        },
        Mission {
          id: "m12".to_string(),
          label: "M12 - Forest Elder 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m12.png".to_string()),
        },
        Mission {
          id: "m13".to_string(),
          label: "M13 - Keystone Species".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m13.png".to_string()),
        },
        Mission {
          id: "m14".to_string(),
          label: "M14 - Seeds of Renewal".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m14.png".to_string()),
        },
        Mission {
          id: "m15".to_string(),
          label: "M15 - Biocentric Architecture 🔴".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m15.png".to_string()),
        },
        Mission {
          id: "m16".to_string(),
          label: "M16 - Precision Tokens".to_string(),
          image_url: Some("assets/images/missions/2026/fo_m16.png".to_string()),
        },
        Mission {
          id: "gp".to_string(),
          label: "Gracious Professionalism".to_string(),
          image_url: Some("assets/images/missions/2026/gp.png".to_string()),
        },
      ],

      robot_game_questions: vec![
        Question {
          id: "m00a".to_string(),
          label: "All team equipment fits in one launch area and under 12 in. (305 mm)?".to_string(),
          label_short: "Inspection?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m01a".to_string(),
          label: "Is the drone no longer touching the mat?".to_string(),
          label_short: "Drone flown?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m01b".to_string(),
          label: "Is the LiDAR map completely flipped over, with the scan marker at least partly in the survey area?".to_string(),
          label_short: "LiDAR map?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 0 }],
            default_option: "No".to_string(),
          }),
          rules: vec![QuestionRule {
            condition: "m01a == Yes && m01b == Yes".to_string(),
            output: 10,
          }],
        },
        Question {
          id: "m02a".to_string(),
          label: "Seeds no longer touching the stalk?".to_string(),
          label_short: "Seeds released?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(3, 10),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m03a".to_string(),
          label: "Is the research flag down?".to_string(),
          label_short: "Flag down?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m03b".to_string(),
          label: "Has the rock been returned to its original starting position?".to_string(),
          label_short: "Rock returned?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 0 }],
            default_option: "No".to_string(),
          }),
          rules: vec![QuestionRule {
            condition: "m03a == Yes && m03b == Yes".to_string(),
            output: 10,
          }],
        },
        // A katydid outside the leaf habitat scores zero for the mission,
        // the second leaf only scores with the katydid in its starting position
        Question {
          id: "m04a".to_string(),
          label: "Leaves completely removed, no longer touching the nest?".to_string(),
          label_short: "Leaves removed?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![
              CategoricalOption { label: "0".to_string(), score: 0 },
              CategoricalOption { label: "1".to_string(), score: 10 },
              CategoricalOption { label: "2".to_string(), score: 10 },
            ],
            default_option: "0".to_string(),
          }),
          rules: vec![
            QuestionRule {
              condition: "m04c != Yes".to_string(),
              output: 0,
            },
            QuestionRule {
              condition: "m04a == 2 && m04b == Yes".to_string(),
              output: 30,
            },
          ],
        },
        Question {
          id: "m04b".to_string(),
          label: "Is the katydid in its original starting position, having never been completely removed from the nest during the match?".to_string(),
          label_short: "Katydid in place?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 0 }],
            default_option: "Yes".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m04c".to_string(),
          label: "Is the katydid inside the leaf habitat, not even partly outside it? (the leaf habitat is the nest and the marked area on the mat around it)".to_string(),
          label_short: "Katydid in habitat?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 0 }],
            default_option: "Yes".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m05a".to_string(),
          label: "How far is the plant root extended?".to_string(),
          label_short: "Root extended?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![
              CategoricalOption { label: "Not extended".to_string(), score: 0 },
              CategoricalOption {
                label: "Partially extended".to_string(),
                score: 10,
              },
              CategoricalOption {
                label: "Completely extended".to_string(),
                score: 20,
              },
            ],
            default_option: "Not extended".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m06a".to_string(),
          label: "Is the ant touching the nest?".to_string(),
          label_short: "Ant home?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 0 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m06b".to_string(),
          label: "Leaf fragments contained within the nest?".to_string(),
          label_short: "Fragments?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(4, 10),
            default_option: "0".to_string(),
          }),
          rules: vec![QuestionRule {
            condition: "m06a != Yes".to_string(),
            output: 0,
          }],
        },
        Question {
          id: "m07a".to_string(),
          label: "Is the mycelium completely extended?".to_string(),
          label_short: "Mycelium?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m07b".to_string(),
          label: "Connections formed between an extended mycelium and the opposing team's fully extended plant root? (not possible in remote competitions or with no opposing team)".to_string(),
          label_short: "Connections?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(2, 10),
            default_option: "0".to_string(),
          }),
          rules: vec![QuestionRule {
            condition: "m07a != Yes".to_string(),
            output: 0,
          }],
        },
        Question {
          id: "m08a".to_string(),
          label: "Is the vine touching the mat?".to_string(),
          label_short: "Vine down?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 30 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m09a".to_string(),
          label: "Is the research platform raised?".to_string(),
          label_short: "Platform raised?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m09b".to_string(),
          label: "Is the camera trap deployed?".to_string(),
          label_short: "Camera trap?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m09c".to_string(),
          label: "Is the seed no longer touching the tree?".to_string(),
          label_short: "Seed released?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m10a".to_string(),
          label: "Is the spider habitat in its original starting position?".to_string(),
          label_short: "Spider habitat?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "Yes".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m10b".to_string(),
          label: "Is the snail habitat in its original starting position?".to_string(),
          label_short: "Snail habitat?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "Yes".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m11a".to_string(),
          label: "Is the root cover down, touching the mat?".to_string(),
          label_short: "Root cover down?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m12a".to_string(),
          label: "Is the cane completely raised, touching the tree?".to_string(),
          label_short: "Cane raised?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m12b".to_string(),
          label: "Is the support tie around the post?".to_string(),
          label_short: "Support tie?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m13a".to_string(),
          label: "Is your team's keystone species on the restoration platform with the young trees raised?".to_string(),
          label_short: "Keystone species?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 30 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m14a".to_string(),
          label: "Seeds contained within the replantation station?".to_string(),
          label_short: "Seeds planted?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(4, 5),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        // Bonus is capped at the number of seeds in the replantation station
        Question {
          id: "m14b".to_string(),
          label: "Of those, how many are also touching the mat (bonus)?".to_string(),
          label_short: "Seeds rooted?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(4, 5),
            default_option: "0".to_string(),
          }),
          rules: vec![
            QuestionRule {
              condition: "m14b > m14a && m14a == 0".to_string(),
              output: 0,
            },
            QuestionRule {
              condition: "m14b > m14a && m14a == 1".to_string(),
              output: 5,
            },
            QuestionRule {
              condition: "m14b > m14a && m14a == 2".to_string(),
              output: 10,
            },
            QuestionRule {
              condition: "m14b > m14a && m14a == 3".to_string(),
              output: 15,
            },
          ],
        },
        Question {
          id: "m15a".to_string(),
          label: "Is the nesting canopy raised?".to_string(),
          label_short: "Nesting canopy?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m15b".to_string(),
          label: "Is the garden skylight completely in?".to_string(),
          label_short: "Garden skylight?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m15c".to_string(),
          label: "Is the compost hatch completely opened, touching the mat?".to_string(),
          label_short: "Compost hatch?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 10 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        // Option labels are single words, the rule engine can't match labels with spaces
        Question {
          id: "m15d".to_string(),
          label: "Which dock is the biocentric architecture model located on? (environmental bonus is scored if the matching feature is complete)".to_string(),
          label_short: "Which dock?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![
              CategoricalOption { label: "None".to_string(), score: 0 },
              CategoricalOption { label: "Mine".to_string(), score: 0 },
              CategoricalOption { label: "City".to_string(), score: 0 },
              CategoricalOption { label: "Farm".to_string(), score: 0 },
            ],
            default_option: "None".to_string(),
          }),
          rules: vec![QuestionRule {
            condition: "m15d == Mine && m15a == Yes || m15d == City && m15b == Yes || m15d == Farm && m15c == Yes".to_string(),
            output: 10,
          }],
        },
        Question {
          id: "m16a".to_string(),
          label: "Number of precision tokens remaining?".to_string(),
          label_short: "Precision?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![
              CategoricalOption { label: "0".to_string(), score: 0 },
              CategoricalOption { label: "1".to_string(), score: 10 },
              CategoricalOption { label: "2".to_string(), score: 15 },
              CategoricalOption { label: "3".to_string(), score: 25 },
              CategoricalOption { label: "4".to_string(), score: 35 },
              CategoricalOption { label: "5".to_string(), score: 50 },
              CategoricalOption { label: "6".to_string(), score: 50 },
            ],
            default_option: "6".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "gp".to_string(),
          label: "Gracious Professionalism® displayed at the robot game table?".to_string(),
          label_short: "GP".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![
              CategoricalOption {
                label: "2 - Developing".to_string(),
                score: 0,
              },
              CategoricalOption {
                label: "3 - Accomplished".to_string(),
                score: 0,
              },
              CategoricalOption { label: "4 - Exceeds".to_string(), score: 0 },
            ],
            default_option: "3 - Accomplished".to_string(),
          }),
          rules: vec![],
        },
      ],
    }
  }
}

#[flutter_rust_bridge::frb(ignore)]
pub struct BioglowFuture {}
#[flutter_rust_bridge::frb(ignore)]
impl BaseSeason for BioglowFuture {
  fn validate(&self, answers: &HashMap<String, QuestionAnswer>) -> Vec<QuestionValidationError> {
    let mut errors = empty_answer_errors(answers);

    // Game specific validation rules

    // m06 max possible (the optional added invasive species plus the required queen)
    let m06_max_possible = number(answers, "m06a") + 1;
    let m06b = number(answers, "m06b");

    if m06b > m06_max_possible {
      errors.push(QuestionValidationError {
        question_ids: "m06b".to_string(),
        message: format!("Invasive species in containment zone {} exceeds max possible {}", m06b, m06_max_possible),
      });
    }

    errors
  }

  fn get_season(&self) -> String {
    "2026-Future".to_string()
  }

  fn get_fll_game(&self) -> FllBlueprint {
    FllBlueprint {
      robot_game_missions: vec![
        Mission {
          id: "m01".to_string(),
          label: "M01 - Mighty Microbiomes".to_string(),
          image_url: Some("assets/images/missions/2026/fu_m01.png".to_string()),
        },
        Mission {
          id: "m02".to_string(),
          label: "M02 - Roots of Renewal".to_string(),
          image_url: Some("assets/images/missions/2026/fu_m02.png".to_string()),
        },
        Mission {
          id: "m03".to_string(),
          label: "M03 - Cave Waterfall".to_string(),
          image_url: Some("assets/images/missions/2026/fu_m03.png".to_string()),
        },
        Mission {
          id: "m04".to_string(),
          label: "M04 - Rainforest Awakening".to_string(),
          image_url: Some("assets/images/missions/2026/fu_m04.png".to_string()),
        },
        Mission {
          id: "m05".to_string(),
          label: "M05 - Central Haven (Cooperative)".to_string(),
          image_url: Some("assets/images/missions/2026/fu_m05.png".to_string()),
        },
        Mission {
          id: "m06".to_string(),
          label: "Level Up Challenge - Invasive Attack".to_string(),
          image_url: Some("assets/images/missions/2026/fu_m06.png".to_string()),
        },
        Mission {
          id: "gp".to_string(),
          label: "Gracious Professionalism".to_string(),
          image_url: Some("assets/images/missions/2026/gp.png".to_string()),
        },
      ],

      robot_game_questions: vec![
        Question {
          id: "m01a".to_string(),
          label: "Keystone species resting loose in the young forest microbiome (not touching equipment)?".to_string(),
          label_short: "Young forest?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(3, 20),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m01b".to_string(),
          label: "Keystone species resting loose in the grand tree microbiome (not touching equipment)?".to_string(),
          label_short: "Grand tree?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(3, 20),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m01c".to_string(),
          label: "Keystone species resting loose in the hollow tree microbiome (not touching equipment)?".to_string(),
          label_short: "Hollow tree?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(3, 20),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m01d".to_string(),
          label: "Is the invasive queen on the opposite side of the field knocked down? (the opposing team knocks it down with their fourth keystone species)".to_string(),
          label_short: "Queen down?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 0 }],
            default_option: "No".to_string(),
          }),
          rules: vec![QuestionRule {
            condition: "m01a == 3 && m01d == Yes".to_string(),
            output: 40,
          }],
        },
        Question {
          id: "m02a".to_string(),
          label: "Resources in the grand tree base?".to_string(),
          label_short: "Tree base?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(15, 5),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m02b".to_string(),
          label: "Resources in the canopy chamber (must have been cycled up)?".to_string(),
          label_short: "Canopy?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(15, 10),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m03a".to_string(),
          label: "Number shown on the cave waterfall counter at the end of the match (keystone species cycled through)?".to_string(),
          label_short: "Waterfall counter?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(50, 5),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m04a".to_string(),
          label: "Are all keystone species released from the nest?".to_string(),
          label_short: "Nest released?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 30 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m04b".to_string(),
          label: "Are all resources released from the hollow tree?".to_string(),
          label_short: "Hollow tree released?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![CategoricalOption { label: "No".to_string(), score: 0 }, CategoricalOption { label: "Yes".to_string(), score: 20 }],
            default_option: "No".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m05a".to_string(),
          label: "Keystone species or resources resting completely in the central haven (shared - both teams score)?".to_string(),
          label_short: "Central haven?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(50, 5),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m06a".to_string(),
          label: "Invasive species added during pre-match setup (optional, excludes the required queen)?".to_string(),
          label_short: "Invasives added?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(5, 20),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "m06b".to_string(),
          label: "Invasive species in the containment zone (may include the invasive queen)?".to_string(),
          label_short: "Contained?".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: numeric_options(6, 10),
            default_option: "0".to_string(),
          }),
          rules: vec![],
        },
        Question {
          id: "gp".to_string(),
          label: "Gracious Professionalism® displayed at the robot game table?".to_string(),
          label_short: "GP".to_string(),
          input: QuestionInput::Categorical(CategoricalQuestion {
            options: vec![
              CategoricalOption {
                label: "2 - Developing".to_string(),
                score: 0,
              },
              CategoricalOption {
                label: "3 - Accomplished".to_string(),
                score: 0,
              },
              CategoricalOption { label: "4 - Exceeds".to_string(), score: 0 },
            ],
            default_option: "3 - Accomplished".to_string(),
          }),
          rules: vec![],
        },
      ],
    }
  }
}
