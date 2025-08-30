use anyhow::Result;

use crate::{db::DB, tournament::Tournament};

const TOURNAMENT_KEY: &str = "tournament";

pub trait TournamentRepository {
  async fn set(record: &Tournament) -> Result<()>;
  async fn get() -> Tournament;
}

impl TournamentRepository for Tournament {
  async fn set(record: &Tournament) -> Result<()> {
    let db = match DB.get() {
      Some(db) => db,
      None => {
        log::warn!("DB not initialized");
        return Err(anyhow::anyhow!("DB not initialized"));
      }
    };

    let table = match db.get_table::<Tournament>().await {
      Ok(table) => table,
      Err(e) => {
        log::error!("Failed to get tournament table: {}", e);
        return Err(e);
      }
    };

    match table.insert(Some(&TOURNAMENT_KEY.to_string()), record) {
      Ok(_) => {
        log::info!("Tournament settings updated");
      }
      Err(e) => {
        log::error!("Failed to update tournament settings: {}", e);
        return Err(e);
      }
    }

    Ok(())
  }

  async fn get() -> Tournament {
    let db = match DB.get() {
      Some(db) => db,
      None => {
        log::warn!("DB not initialized");
        return Tournament::default();
      }
    };

    let table = match db.get_table::<Tournament>().await {
      Ok(table) => table,
      Err(e) => {
        log::error!("Failed to get tournament table: {}", e);
        return Tournament::default();
      }
    };

    match table.get(&TOURNAMENT_KEY.to_string()) {
      Ok(Some(record)) => record,
      Ok(None) => {
        log::info!("No tournament settings found, returning default");
        Tournament::default()
      }
      Err(e) => {
        log::error!("Failed to get tournament settings: {}", e);
        Tournament::default()
      }
    }
  }
}
