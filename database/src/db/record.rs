use serde::{Serialize, de::DeserializeOwned};

/// A trait for database records.
/// Records must be serializable and deserializable using serde.
/// Records have a main index (the primary key) and can have multiple secondary indexes.
/// The primary key is used to uniquely identify a record in the database. (uuid v7)
/// Secondary indexes are used to speed up searching for records based on non-primary key fields.
pub trait Record: Default + Clone + Sync + Send + Serialize + DeserializeOwned {
  ///
  /// Convert the record to bytes
  ///
  fn to_bytes(&self) -> Vec<u8> {
    match postcard::to_allocvec(self) {
      Ok(bytes) => bytes,
      Err(err) => {
        log::error!("Failed to serialize record: {:?}", err);
        Vec::default()
      }
    }
  }

  ///
  /// Convert bytes to a record
  ///
  fn from_bytes(bytes: &[u8]) -> Self {
    match postcard::from_bytes(bytes) {
      Ok(record) => record,
      Err(err) => {
        log::error!("Failed to deserialize record: {:?}, using default", err);
        Self::default()
      }
    }
  }

  ///
  /// Get the secondary searchable indexes for this record.
  /// Speeds up searching for records based on a secondary index that is not the primary key.
  /// I.e, author_name, age, etc...
  ///
  fn secondary_indexes(&self) -> Vec<String> {
    vec![]
  }

  ///
  /// - REQUIRED - The name of the table in the database
  ///
  fn table_name() -> &'static str;
}
