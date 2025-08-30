import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tms/helpers/local_storage.dart';

part 'network_config_provider.g.dart';

@riverpod
class ServerIp extends _$ServerIp {
  static const String _key = 'server_address';
  static const String _defaultIp = '127.0.0.1';

  void setIp(String ip) {
    localStorage.setString(_key, ip);
    state = ip;
  }

  String getIp() {
    return state;
  }

  String _checkStoredIp() {
    String ip = _defaultIp;
    if (localStorage.containsKey(_key)) {
      state = localStorage.getString(_key) ?? _defaultIp;
    } else {
      if (kIsWasm || kIsWeb) {
        // use base
        ip = Uri.base.host;
      }
    }

    return ip;
  }

  @override
  String build() {
    return _checkStoredIp();
  }
}

// Port
@riverpod
class ServerPort extends _$ServerPort {
  static const String _key = 'server_port';
  static const int _defaultPort = 8080;
  void setPort(int port) {
    localStorage.setInt(_key, port);
    state = port;
  }

  int getPort() {
    return state;
  }

  int _checkStoredPort() {
    int port = _defaultPort;
    if (localStorage.containsKey(_key)) {
      state = localStorage.getInt(_key) ?? _defaultPort;
    }
    return port;
  }

  @override
  int build() {
    return _checkStoredPort();
  }
}

@riverpod
String serverAddress(Ref ref) {
  final ip = ref.watch(serverIpProvider);
  final port = ref.watch(serverPortProvider);
  return '$ip:$port';
}
