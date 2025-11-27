use structopt::StructOpt;

pub mod database;
pub mod network;
pub mod services;
pub mod tunnel;
pub mod web_server;

#[derive(Debug, StructOpt)]
pub struct ServerArgs {
  #[structopt(default_value = "0.0.0.0", long = "addr", help = "Address to listen on, --addr 0.0.0.0")]
  pub addr: String,

  #[structopt(default_value = "8080", long = "port", help = "Port to listen on, --port 8080")]
  pub port: u16,

  #[structopt(long = "tls", help = "Use secure connection, https/wss instead of http/ws, --tls")]
  pub tls: bool,

  #[structopt(long = "cert", help = "Path to the certificate file, --cert=cert.pem")]
  pub cert_path: Option<String>,

  #[structopt(long = "key", help = "Path to the key file, --key=key.rsa")]
  pub key_path: Option<String>,

  #[structopt(long = "proxy_token", help = "Token for the tms.mobi site, --proxy_token my_secret_token")]
  pub proxy_token: Option<String>,

  #[structopt(long = "proxy_domain", help = "Subdomain for the tms.mobi (i.e curtin.tms.mobi) site, --proxy_domain curtin")]
  pub proxy_subdomain: Option<String>,
}

impl ServerArgs {
  pub fn get_port() -> u16 {
    ServerArgs::from_args().port
  }

  pub fn get_addr() -> [u8; 4] {
    let arg_addr = ServerArgs::from_args().addr;
    let mut addr = [0; 4];
    let parts: Vec<&str> = arg_addr.split('.').collect();
    for i in 0..4 {
      addr[i] = parts[i].parse().unwrap();
    }
    addr
  }

  pub fn get_tls() -> bool {
    ServerArgs::from_args().tls
  }

  pub fn get_cert_path() -> Option<String> {
    ServerArgs::from_args().cert_path
  }

  pub fn get_key_path() -> Option<String> {
    ServerArgs::from_args().key_path
  }

  pub fn get_proxy_token() -> Option<String> {
    ServerArgs::from_args().proxy_token
  }

  pub fn get_proxy_subdomain() -> Option<String> {
    ServerArgs::from_args().proxy_subdomain
  }
}
