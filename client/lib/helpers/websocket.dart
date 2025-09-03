import 'dart:async';
import 'dart:convert';

import 'package:logger/web.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageHandler<T> = void Function(T data);
typedef ErrorHandler = void Function(Object error);
typedef StateChangeHandler = void Function(bool isConnected);

class WebSocketHelper<T> {
  final String url;
  final T Function(Map<String, dynamic> json) fromJson;
  final Duration reconnectDelay;

  WebSocketChannel? _channel;
  bool _isReconnecting = false;
  bool _isDisposed = false;
  StreamSubscription? _subscription;

  MessageHandler<T>? _onMessage;
  ErrorHandler? _onError;
  StateChangeHandler? _onStateChange;

  WebSocketHelper({
    required this.url,
    required this.fromJson,
    this.reconnectDelay = const Duration(seconds: 5),
  });

  /// Set up event handlers
  void setHandlers({
    MessageHandler<T>? onMessage,
    ErrorHandler? onError,
    StateChangeHandler? onStateChange,
  }) {
    _onMessage = onMessage;
    _onError = onError;
    _onStateChange = onStateChange;
  }

  /// Connect to the WebSocket
  Future<void> connect() async {
    if (_isReconnecting || _isDisposed) return;

    await _cleanup();

    try {
      final uri = Uri.parse(url);
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        (message) {
          try {
            final json = jsonDecode(message as String) as Map<String, dynamic>;
            final data = fromJson(json);
            _onMessage?.call(data);
            _isReconnecting = false; // Reset on successful message
          } catch (e) {
            Logger().e("Error processing WebSocket message: $e");
            _onError?.call(e);
          }
        },
        onError: (error) {
          Logger().e("WebSocket error: $error");
          _onError?.call(error);
          _onStateChange?.call(false);
          _scheduleReconnect();
        },
        onDone: () {
          _onStateChange?.call(false);
          _scheduleReconnect();
        },
      );

      _onStateChange?.call(true);
    } catch (e) {
      Logger().e("WebSocket connection error: $e");
      _onError?.call(e);
      _onStateChange?.call(false);
      _scheduleReconnect();
    }
  }

  /// Send a message through the WebSocket
  void send(String message) {
    _channel?.sink.add(message);
  }

  /// Send JSON data through the WebSocket
  void sendJson(Map<String, dynamic> data) {
    send(jsonEncode(data));
  }

  /// Disconnect from the WebSocket
  void disconnect() {
    _cleanup();
    _onStateChange?.call(false);
  }

  /// Dispose the helper (call this when done)
  void dispose() {
    _isDisposed = true;
    _cleanup();
  }

  /// Get connection status
  bool get isConnected => _channel != null && _subscription != null;

  void _scheduleReconnect() {
    if (_isReconnecting || _isDisposed) return;

    _isReconnecting = true;

    Future.delayed(reconnectDelay, () {
      if (_isDisposed) return;

      _isReconnecting = false;
      connect();
    });
  }

  Future<void> _cleanup() async {
    await _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close(status.normalClosure);
    _channel = null;
    _isReconnecting = false;
  }
}
