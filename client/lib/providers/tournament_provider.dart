import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tms/helpers/websocket.dart';
import 'package:tms/models/tournament.dart';
import 'package:tms/providers/network_config_provider.dart';

part 'tournament_provider.g.dart';

@riverpod
class TournamentData extends _$TournamentData {
  late WebSocketHelper<Tournament> _wsHelper;

  @override
  Tournament build() {
    final serverAddress = ref.watch(serverAddressProvider);
    _wsHelper = WebSocketHelper(
      url: "ws://$serverAddress/ws/tournament/config",
      fromJson: Tournament.fromJson,
    );

    _wsHelper.setHandlers(
      onMessage: (tournament) {
        state = tournament;
      },
      onStateChange: (isConnected) {
        if (!isConnected) {
          state = Tournament.defaultTournament();
        }
      },
    );

    ref.onDispose(() {
      _wsHelper.dispose();
    });

    _wsHelper.connect();
    return Tournament.defaultTournament();
  }
}
