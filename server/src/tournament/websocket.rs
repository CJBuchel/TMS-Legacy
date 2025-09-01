use crate::tournament::{Tournament, TournamentRepository};
use axum::{
  Router,
  extract::{
    WebSocketUpgrade,
    ws::{Message, WebSocket},
  },
  response::Response,
  routing::get,
};
use database::TableBroker;
use futures::{SinkExt, StreamExt};

async fn handle_socket(socket: WebSocket) {
  let (mut tx, mut rx) = socket.split();

  // subscribe to tournament changes
  let mut tournament_stream = TableBroker::<Tournament>::subscribe();

  // send initial data
  let current_tournament = Tournament::get().await;
  if let Ok(json) = serde_json::to_string(&current_tournament) {
    if tx.send(Message::Text(json.into())).await.is_err() {
      return;
    }
  }

  loop {
    tokio::select! {
      // Handle incoming messages from the client (if any)
      msg = rx.next() => {
        match msg {
          Some(Ok(Message::Close(_))) => {
            break;
          }
          None => break,
          _ => {}
        }
      }

      change = tournament_stream.next() => {
        if let Some(change_op) = change {
          if let Some(tournament) = &change_op.1 {
            if let Ok(json) = serde_json::to_string(tournament) {
              if tx.send(Message::Text(json.into())).await.is_err() {
                break;
              }
            }
          }
        }
      }
    }
  }
}

async fn websocket_upgrade(ws: WebSocketUpgrade) -> Response {
  ws.on_upgrade(handle_socket)
}

pub fn ws_routes() -> Router {
  Router::new().route("/config", get(websocket_upgrade))
}
