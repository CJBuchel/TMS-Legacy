# Adding a season

A season is one Rust file in `tms_infra/src/infra/fll_infra/seasons/`. It defines the missions, the questions and their points, the rules that link answers together, and the validation checks.

Use the most recent season file as your starting point.

## The steps

1. Create `fll_<year>.rs` in the `seasons` folder with a struct that implements `BaseSeason`.
2. Register the module in `seasons/mod.rs`.
3. Add the season to the `SEASONS` list in `fll_blueprint_map.rs`.
4. Add mission images to `tms_client/assets/images/missions/<year>/` and list the folder in `tms_client/pubspec.yaml`.
5. Add tests in `tms_infra/tests/fll_scoring.rs`.
6. Run `./run_codegen` and rebuild the client.

## The season trait

```rust
pub trait BaseSeason {
  fn validate(&self, answers: &HashMap<String, QuestionAnswer>) -> Vec<QuestionValidationError>;
  fn get_season(&self) -> String;
  fn get_fll_game(&self) -> FllBlueprint;
}
```

`get_season`
:   The name shown in the season dropdown and stored on every scoresheet. Once events have used it, do not change it.

`get_fll_game`
:   Returns the missions and questions.

`validate`
:   Returns a list of problems with a set of answers. An empty list means the sheet can be submitted.

## Missions and questions

```rust
Mission {
  id: "m01".to_string(),
  label: "M01 - Drone Survey".to_string(),
  image_url: None, // (1)!
},
```

1. With `None`, the client looks for `assets/images/missions/<season>/<mission id>.png`. Set a path here to override it, which is how the two 2026 games share one image folder.

A question belongs to the mission whose id it starts with: `m01a` and `m01b` both belong to `m01`.

```rust
Question {
  id: "m01a".to_string(),
  label: "Is the drone no longer touching the mat?".to_string(),
  label_short: "Drone flown?".to_string(),
  input: QuestionInput::Categorical(CategoricalQuestion {
    options: vec![
      CategoricalOption { label: "No".to_string(), score: 0 },
      CategoricalOption { label: "Yes".to_string(), score: 20 },
    ],
    default_option: "No".to_string(),
  }),
  rules: vec![],
},
```

Every question is categorical: a fixed list of options, each worth a number of points, and a default. A number range is a list of options labelled `0`, `1`, `2` and so on. The client shows a list of more than eight consecutive numbers as a counter.

!!! tip "Choose defaults carefully"
    Defaults should describe a robot that never left base. A model that scores for being *undisturbed* defaults to yes; precision tokens default to all remaining. The test suite checks that the defaults pass validation.

## Rules

A rule replaces a question's score when its condition is true. Use rules for points that depend on another answer.

```rust
Question {
  id: "m01b".to_string(),
  // ...options: No = 0, Yes = 0
  rules: vec![QuestionRule {
    condition: "m01a == Yes && m01b == Yes".to_string(), // (1)!
    output: 10,
  }],
},
```

1. The bonus is worth 10, but only when the main objective was also achieved.

How rules are evaluated:

- A question id in a condition is replaced by that question's current answer.
- The first rule whose condition is true wins, and its `output` **replaces** the option's score. If no rule matches, the option's own score is used.
- Supported operators are `==`, `!=`, `>`, `<`, `>=`, `<=`, joined with `&&` and `||`. `&&` binds tighter than `||`.

!!! warning "Limits of the rule engine"
    - Comparisons are made on **text**, not numbers. `>` and `<` are only reliable for single digits. For larger ranges, write one rule per value or do the work in `validate`.
    - A value in a condition must be a **single word**. An option labelled `Mine dock` cannot be matched; label it `Mine`.
    - Avoid parentheses. Write `a == Yes && b == Yes || c == Yes && d == Yes` and rely on `&&` binding tighter.

## Validation

`validate` is ordinary Rust, so anything the rule engine cannot express goes here.

```rust
let released = number(answers, "m02a") + if is_yes(answers, "m09c") { 1 } else { 0 };
let planted = number(answers, "m14a");

if planted > released {
  errors.push(QuestionValidationError {
    question_ids: "m14a".to_string(), // (1)!
    message: format!("Seeds in replantation station {} exceeds max possible {}", planted, released),
  });
}
```

1. The message is shown under this question on the scoresheet. Use a comma-separated list to attach it to several.

A sheet with any validation error cannot be submitted, on the client or the server. Only add a check when the answers are genuinely impossible, not merely unusual.

## Scoring and validation are separate

Remember that rules and validation do different jobs:

| | Rules | Validation |
| --- | --- | --- |
| Changes the score | Yes | No |
| Blocks submission | No | Yes |
| Written as | Condition strings | Rust |

A bonus that needs a prerequisite usually wants both: a rule so the bonus scores nothing without it, and a validation message so the referee notices.

## Testing

Add a test for the new season in `tms_infra/tests/fll_scoring.rs`. The helpers there start from the season's defaults and apply the answers you give:

```rust
#[test]
fn my_new_season() {
  assert_eq!(score("2027", &[]), 50); // defaults
  assert_eq!(score("2027", &[("m01a", "Yes")]), 70);
  assert_eq!(score("2027", &[("m01b", "Yes")]), 50); // bonus without the objective
  assert_eq!(n_errors("2027", &[("m01b", "Yes")]), 1);
}
```

Cover every rule, every validation check, and the maximum possible score. Run them with:

```bash
cargo test -p tms_infra
```

The existing tests also check, for every season, that the default answers are valid and that every question belongs to a mission.

## A season with more than one game

If a season has more than one game, add one struct per game in the same file and register each under its own name, as `2026-Founders` and `2026-Future` are. Prefix the image files (`fo_m01.png`, `fu_m01.png`) and set `image_url` on each mission so both games can share a folder.
