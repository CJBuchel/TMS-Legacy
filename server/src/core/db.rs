use anyhow::Result;
use database::Database;
use once_cell::sync::OnceCell;

use crate::{TmsConfig, User, UserRepository, permissions::Role};

pub static DB: OnceCell<Database> = OnceCell::new();

async fn db_data_init(config: &TmsConfig) -> Result<()> {
  log::info!("Initializing DB Data");

  // create users
  match User::get_by_username(&"admin".to_string()).await {
    Ok(users) => {
      if users.is_empty() {
        log::info!("Creating Admin user");

        let admin = User {
          username: "admin".to_string(),
          password: config.admin_password.clone(),
          roles: vec![Role::Admin],
          ..User::default()
        };

        match User::add(&admin).await {
          Ok((_, _)) => log::info!("Admin user added"),
          Err(e) => log::error!("Failed to add admin user: {}", e),
        }
      } else {
        log::info!("Admin user already exists");
      }
    }
    Err(e) => log::error!("Failed to get admin user: {}", e),
  }

  Ok(())
}

pub async fn initialize_db(config: &TmsConfig) -> Result<()> {
  // check if DB is already set
  if DB.get().is_some() {
    log::warn!("DB already initialized");
  } else {
    log::info!("Initializing DB");
    let db = Database::new(config.db_path.clone())?;
    DB.set(db).map_err(|_| anyhow::anyhow!("Failed to set DB"))?;
  }

  // Initialize the data
  match db_data_init(config).await {
    Ok(_) => log::info!("DB data initialized"),
    Err(e) => log::error!("Failed to initialize DB data: {}", e),
  }

  Ok(())
}
