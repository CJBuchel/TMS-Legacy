use std::{net::SocketAddr, path::PathBuf, sync::Arc};

use hyper_util::{
  rt::{TokioExecutor, TokioIo},
  server::conn::auto,
  service::TowerToHyperService,
};
use rustls::pki_types::{pem::PemObject, CertificateDer, PrivateKeyDer};
use tokio_rustls::TlsAcceptor;

use warp::Filter;

use super::certificates::CertificateKeys;

#[derive(Debug, Clone)]
pub struct WebConfig {
  pub port: u16,
  pub addr: [u8; 4],
  pub tls: bool,

  // the local IP address to use for specifics
  pub local_ip: String,
}

impl Default for WebConfig {
  fn default() -> WebConfig {
    WebConfig {
      port: 8080,
      addr: [0, 0, 0, 0],
      tls: false,
      local_ip: "".to_string(),
    }
  }
}

pub struct WebServer {
  port: u16,
  addr: [u8; 4],
  certificates: CertificateKeys,
  tls: bool,
}

impl WebServer {
  pub fn new(config: WebConfig, certs: CertificateKeys) -> Self {
    // let certs = CertificateKeys::new(config.cert_path, config.key_path, config.local_ip);

    WebServer {
      port: config.port,
      addr: config.addr,
      certificates: certs,
      tls: config.tls,
    }
  }

  async fn start_tls<F, R>(&self, routes: F)
  where
    F: warp::Filter<Extract = R, Error = warp::Rejection> + Clone + Send + Sync + 'static,
    R: warp::Reply,
  {
    // start the web server with TLS (warp no longer ships its own TLS acceptor, so accept with rustls and hand the stream to hyper)
    let certs: Vec<CertificateDer<'static>> = match CertificateDer::pem_slice_iter(self.certificates.cert.as_bytes()).collect() {
      Ok(certs) => certs,
      Err(e) => {
        log::error!("Invalid TLS certificate: {}", e);
        return;
      }
    };

    let key = match PrivateKeyDer::from_pem_slice(self.certificates.key.as_bytes()) {
      Ok(key) => key,
      Err(e) => {
        log::error!("Invalid TLS key: {}", e);
        return;
      }
    };

    let mut tls_config = match rustls::ServerConfig::builder().with_no_client_auth().with_single_cert(certs, key) {
      Ok(config) => config,
      Err(e) => {
        log::error!("Failed to create TLS config: {}", e);
        return;
      }
    };
    tls_config.alpn_protocols = vec![b"h2".to_vec(), b"http/1.1".to_vec()];
    let acceptor = TlsAcceptor::from(Arc::new(tls_config));

    let listener = match tokio::net::TcpListener::bind(SocketAddr::from((self.addr, self.port))).await {
      Ok(listener) => listener,
      Err(e) => {
        log::error!("Failed to bind {:?}:{}: {}", self.addr, self.port, e);
        return;
      }
    };

    let service = TowerToHyperService::new(warp::service(routes));

    loop {
      let stream = match listener.accept().await {
        Ok((stream, _)) => stream,
        Err(e) => {
          log::warn!("Failed to accept connection: {}", e);
          continue;
        }
      };

      let acceptor = acceptor.clone();
      let service = service.clone();

      tokio::spawn(async move {
        let stream = match acceptor.accept(stream).await {
          Ok(stream) => stream,
          Err(e) => {
            log::debug!("TLS handshake failed: {}", e);
            return;
          }
        };

        // with upgrades, for the websocket connections
        if let Err(e) = auto::Builder::new(TokioExecutor::new()).serve_connection_with_upgrades(TokioIo::new(stream), service).await {
          log::debug!("Connection error: {}", e);
        }
      });
    }
  }

  pub async fn start_no_tls<F, R>(&self, routes: F)
  where
    F: warp::Filter<Extract = R, Error = warp::Rejection> + Clone + Send + Sync + 'static,
    R: warp::Reply,
  {
    warp::serve(routes).run((self.addr, self.port)).await;
  }

  pub async fn start<F, R>(&self, routes: F)
  where
    F: warp::Filter<Extract = R, Error = warp::Rejection> + Clone + Send + Sync + 'static,
    R: warp::Reply,
  {
    // static files for web hosting, (add cache control header for 24 hours)
    let ui_static_files_path = PathBuf::from("tms_client").join("build").join("web");
    let ui_static_files = warp::fs::dir(ui_static_files_path).map(|reply| warp::reply::with_header(reply, "Cache-Control", "public, max-age=86400"));

    let ui_route = warp::path("ui").and(ui_static_files);

    // redirect all root traffic to /ui
    let root_route = warp::path::end().map(|| warp::redirect(warp::http::Uri::from_static("/ui")));

    // append the web route to provided routes
    let web_route = root_route.or(ui_route).boxed();

    // combine the web route with the provided routes
    let routes = web_route.or(routes);

    if self.tls {
      self.start_tls(routes).await;
    } else {
      self.start_no_tls(routes).await;
    }
  }
}
