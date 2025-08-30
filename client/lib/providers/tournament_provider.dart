import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'tournament_provider.g.dart';

class Tournament {
  final String name;
  Tournament(this.name);

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(json['name'] ?? '');
  }
}

@riverpod
class TournamentTitle extends _$TournamentTitle {
  WebSocketChannel? _channel;
  bool _isReconnecting = false;

  @override
  String build() {
    ref.onDispose(() {
      _channel?.sink.close(WebSocketStatus.goingAway);
    });
    _connectWebSocket();
    return 'No Tournament Connected';
  }

  void _connectWebSocket() {
    if (_isReconnecting) return;
    _cleanup();

    final uri = Uri.parse('ws://localhost:8080/ws/tournament/config');
    _channel = WebSocketChannel.connect(uri);
    _channel?.stream.listen(
      (message) {
        // Handle incoming messages
        final json = jsonDecode(message) as Map<String, dynamic>;
        final t = Tournament.fromJson(json);
        state = t.name;
      },
      onError: (error) {
        // Handle errors
        print('WebSocket error: $error');
        _reconnect();
      },
      onDone: () {
        // Handle socket closure
        print('WebSocket closed');
        _reconnect();
      },
    );
  }

  void _reconnect() {
    if (_isReconnecting) return;
    _isReconnecting = true;
    Future.delayed(const Duration(seconds: 5), () {
      _isReconnecting = false;
      _connectWebSocket();
    });
  }

  void _cleanup() {
    _channel?.sink.close(WebSocketStatus.goingAway);
    _channel = null;
    _isReconnecting = false;
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
