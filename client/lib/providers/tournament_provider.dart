import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tms/helpers/websocket.dart';
import 'package:tms/providers/network_config_provider.dart';

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
  late WebSocketHelper<Tournament> _wsHelper;

  @override
  String build() {
    final serverAddress = ref.watch(serverAddressProvider);
    _wsHelper = WebSocketHelper(
      url: "ws://$serverAddress/ws/tournament/config",
      fromJson: Tournament.fromJson,
    );

    _wsHelper.setHandlers(
      onMessage: (tournament) {
        state = tournament.name;
      },
      onStateChange: (isConnected) {
        if (!isConnected) {
          state = "No Tournament Connected";
        }
      },
    );

    ref.onDispose(() {
      _wsHelper.dispose();
    });

    _wsHelper.connect();
    return "No Tournament Connected";
  }
}
