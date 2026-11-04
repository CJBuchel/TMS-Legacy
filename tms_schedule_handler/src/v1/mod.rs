use std::io::{BufRead, BufReader};

use crate::{CsvToTmsSchedule, TmsSchedule};

const BLOCK_FORMAT: &str = "Block Format";
const BLOCK_TEAMS: &str = "1";
const BLOCK_MATCHES: &str = "2";
const BLOCK_JUDGING: &str = "3";
const BLOCK_PRACTICE_MATCHES: &str = "4";

mod schedule_teams_block;
use chrono::Timelike;
use schedule_teams_block::*;

mod schedule_matches_block;
use schedule_matches_block::*;

mod schedule_practice_matches_block;
use schedule_practice_matches_block::*;

mod schedule_judging_block;
use schedule_judging_block::*;
use tms_infra::{
  infra::database_schemas::{GameMatch, GameMatchTable, JudgingSession, JudgingSessionPod, Team, TmsDateTime, TmsTime},
  GameMatchQueueStatus, TeamCheckInStatus, TmsCategory,
};

pub trait V1Block {
  type Output;

  fn find_block_line_number(csv: &str, block: &str) -> Option<usize> {
    let reader = BufReader::new(csv.as_bytes());
    let mut line_number = 0;

    for line in reader.lines() {
      let line = match line {
        Ok(line) => line,
        Err(_) => return None,
      };

      line_number += 1;

      // split
      let fields = line.split(",").collect::<Vec<&str>>();
      if fields.first() == Some(&BLOCK_FORMAT)
        && fields.get(1) == Some(&block) {
          return Some(line_number + 1); // start with line after block format
        }
    }

    None
  }

  // gets lines between block format and next block format
  fn get_block_lines(csv: &str, block: &str) -> Result<Vec<String>, String> {
    let reader = BufReader::new(csv.as_bytes());

    // find block
    let block_line = match Self::find_block_line_number(csv, block) {
      Some(line) => line,
      None => return Err(format!("Block {} not found", block)),
    };

    // skip to block, and get lines until next block
    let lines = reader.lines().skip(block_line);
    let mut block_lines: Vec<String> = vec![];

    for line in lines {
      let line = match line {
        Ok(line) => line,
        Err(e) => return Err(format!("Error reading line: {}", e)),
      };

      // split
      let fields = line.split(",").collect::<Vec<&str>>();
      if fields.first() == Some(&BLOCK_FORMAT) {
        break;
      }

      block_lines.push(line);
    }

    Ok(block_lines)
  }

  fn from_csv(csv: &str) -> Result<Self::Output, String>;
}

pub struct V1 {
  pub teams_block: Option<ScheduleTeamsBlock>,
  pub matches_block: Option<ScheduleMatchesBlock>,
  pub practice_matches_block: Option<SchedulePracticeMatchesBlock>,
  pub judging_block: Option<ScheduleJudgeBlock>,
}

impl V1 {
  pub fn extract_time(input: &str) -> Result<TmsDateTime, String> {
    let words: Vec<&str> = input.split_whitespace().collect();
    let Some(at) = words.iter().position(|w| w.contains(':')) else {
      return Err(format!("Error capturing time from: {}", input));
    };

    let mut parts = words[at].split(':').map(str::parse::<u32>);
    let (Some(Ok(mut hour)), Some(Ok(minute))) = (parts.next(), parts.next()) else {
      return Err(format!("Error capturing time from: {}", input));
    };
    let second = match parts.next() {
      Some(Ok(second)) => second,
      None => 0,
      Some(Err(_)) => return Err(format!("Error capturing time from: {}", input)),
    };

    // a 24-hour hour with a PM suffix ("13:01:00 PM") is left as is
    match words.get(at + 1).map(|w| w.to_ascii_uppercase()).as_deref() {
      Some("PM") if (1..12).contains(&hour) => hour += 12,
      Some("AM") if hour == 12 => hour = 0,
      Some("AM" | "PM") | None => {}
      Some(other) => return Err(format!("Unexpected '{}' after time in: {}", other, input)),
    }

    let Some(start_time_native) = chrono::NaiveTime::from_hms_opt(hour, minute, second) else {
      return Err(format!("Error parsing time: {}", input));
    };

    // TMS Date Time
    let start_time = TmsDateTime {
      date: None,
      time: Some(TmsTime {
        hour: start_time_native.hour(),
        minute: start_time_native.minute(),
        second: start_time_native.second(),
      }),
    };

    Ok(start_time)
  }

  // the words before the time, e.g. "Day 1" from "Day 1 10:00:00 AM"
  pub fn extract_category(input: &str) -> Option<String> {
    let words: Vec<&str> = input.split_whitespace().collect();
    let at = words.iter().position(|w| w.contains(':'))?;
    (at > 0).then(|| words[..at].join(" "))
  }

}

impl CsvToTmsSchedule for V1 {
  fn valid_version(csv: &str) -> bool {
    let reader = BufReader::new(csv.as_bytes());

    for line in reader.lines() {
      let line = match line {
        Ok(line) => line,
        Err(_) => return false,
      };

      // split
      let fields = line.split(",").collect::<Vec<&str>>();
      if fields.first() == Some(&"Version Number")
        && fields.get(1) == Some(&"1") {
          return true;
        }
    }

    false
  }

  fn csv_to_tms_schedule(csv: &str) -> Result<TmsSchedule, String> {
    let v1 = V1 {
      teams_block: ScheduleTeamsBlock::from_csv(csv).ok(),
      matches_block: ScheduleMatchesBlock::from_csv(csv).ok(),
      judging_block: ScheduleJudgeBlock::from_csv(csv).ok(),
      practice_matches_block: SchedulePracticeMatchesBlock::from_csv(csv).ok(),
    };

    // v1 to tms schedule
    let mut schedule = TmsSchedule {
      teams: vec![],
      game_matches: vec![],
      game_tables: vec![],
      judging_sessions: vec![],
      judging_pods: vec![],
    };

    // teams
    if let Some(teams_block) = v1.teams_block {
      for team in teams_block.teams {
        schedule.teams.push(Team {
          team_number: team.team_number,
          name: team.name,
          affiliation: team.affiliation,
          ranking: 0,
        });
      }
    }

    // practice matches
    if let Some(practice_matches_block) = v1.practice_matches_block {
      for m in practice_matches_block.matches {
        let mut game_match_tables: Vec<GameMatchTable> = vec![];

        if m.on_tables.is_empty() {
          log::error!("No tables assigned to match: {}", m.match_number);
          return Err(format!("No tables assigned to match: {}", m.match_number));
        }

        for on_table in m.on_tables.clone() {
          let game_match_table = GameMatchTable {
            table: on_table.on_table_name,
            team_number: on_table.team_number,
            score_submitted: false,
            check_in_status: TeamCheckInStatus::NotCheckedIn,
          };
          game_match_tables.push(game_match_table);
        }

        // start/end time
        let start_time = Self::extract_time(&m.start_time)?;
        let end_time = Self::extract_time(&m.end_time)?;

        let sub_categories = match Self::extract_category(&m.start_time) {
          Some(sub_category) => vec![sub_category],
          None => vec![],
        };

        schedule.game_matches.push(GameMatch {
          match_number: m.match_number.clone(),
          start_time,
          end_time,
          game_match_tables,
          completed: false,
          category: TmsCategory {
            category: String::from("Practice Matches"),
            sub_categories,
          },
          queue_state: GameMatchQueueStatus::QueueingSoon,
        });
      }
    }

    // matches & tables
    if let Some(matches_block) = v1.matches_block {
      // tables
      for table in matches_block.table_names {
        schedule.game_tables.push(table);
      }

      // matches
      for m in matches_block.matches {
        let mut game_match_tables: Vec<GameMatchTable> = vec![];

        if m.on_tables.is_empty() {
          log::error!("No tables assigned to match: {}", m.match_number);
          return Err(format!("No tables assigned to match: {}", m.match_number));
        }

        for on_table in m.on_tables.clone() {
          let game_match_table = GameMatchTable {
            table: on_table.on_table_name,
            team_number: on_table.team_number,
            score_submitted: false,
            check_in_status: TeamCheckInStatus::NotCheckedIn,
          };
          game_match_tables.push(game_match_table);
        }

        // start/end time
        let start_time = Self::extract_time(&m.start_time)?;
        let end_time = Self::extract_time(&m.end_time)?;

        let sub_categories = match Self::extract_category(&m.start_time) {
          Some(sub_category) => vec![sub_category],
          None => vec![],
        };

        schedule.game_matches.push(GameMatch {
          match_number: m.match_number.clone(),
          start_time,
          end_time,
          game_match_tables,
          completed: false,
          category: TmsCategory {
            category: String::from("Ranking Matches"),
            sub_categories,
          },
          queue_state: GameMatchQueueStatus::QueueingSoon,
        });
      }
    }

    // judging & pods
    if let Some(judging_block) = v1.judging_block {
      // pods
      for pod in judging_block.judging_room_names {
        schedule.judging_pods.push(pod);
      }

      // sessions
      for j in judging_block.sessions {
        let mut judging_session_pods: Vec<JudgingSessionPod> = vec![];

        for pod in j.in_rooms.clone() {
          let judging_session_pod = JudgingSessionPod {
            team_number: pod.team_number.clone(),
            pod_name: pod.room_name.clone(),
            innovation_submitted: false,
            core_values_submitted: false,
            robot_design_submitted: false,
          };
          judging_session_pods.push(judging_session_pod);
        }

        // start/end time
        let start_time = Self::extract_time(&j.start_time)?;
        let end_time = Self::extract_time(&j.end_time)?;

        let category_name = String::from("Judging Sessions");
        let sub_categories = match Self::extract_category(&j.start_time) {
          Some(sub_category) => vec![sub_category],
          None => vec![],
        };

        schedule.judging_sessions.push(JudgingSession {
          session_number: j.session_number.clone(),
          start_time,
          end_time,
          judging_session_pods,
          completed: false,
          category: TmsCategory { category: category_name, sub_categories },
        });
      }
    }

    Ok(schedule)
  }
}

#[cfg(test)]
mod tests {
  use super::*;

  fn hms(input: &str) -> (u32, u32, u32) {
    let time = V1::extract_time(input).unwrap().time.unwrap();
    (time.hour, time.minute, time.second)
  }

  #[test]
  fn twelve_hour_times() {
    assert_eq!(hms("9:40 AM"), (9, 40, 0));
    assert_eq!(hms("9:40:00 AM"), (9, 40, 0));
    assert_eq!(hms("1:00 PM"), (13, 0, 0));
    assert_eq!(hms("12:40 PM"), (12, 40, 0));
    assert_eq!(hms("12:15 AM"), (0, 15, 0));
  }

  #[test]
  fn old_format_times() {
    assert_eq!(hms("10:00:00 AM"), (10, 0, 0));
    assert_eq!(hms("13:01:00 PM"), (13, 1, 0));
    assert_eq!(hms("Day 1 16:34:00 PM"), (16, 34, 0));
    assert_eq!(hms("09:00"), (9, 0, 0));
  }

  #[test]
  fn bad_times() {
    assert!(V1::extract_time("soon").is_err());
    assert!(V1::extract_time("25:00:00").is_err());
    assert!(V1::extract_time("10:00 XM").is_err());
  }

  #[test]
  fn categories() {
    assert_eq!(V1::extract_category("Day 1 16:34:00 PM").as_deref(), Some("Day 1"));
    assert_eq!(V1::extract_category("9:40 AM"), None);
  }

  #[test]
  fn test_imports_still_parse() {
    for csv in [
      include_str!("../../../test_imports/single_day.csv"),
      include_str!("../../../test_imports/multi_day.csv"),
    ] {
      let schedule = V1::csv_to_tms_schedule(csv).unwrap();
      assert!(!schedule.game_matches.is_empty());
    }
  }
}
