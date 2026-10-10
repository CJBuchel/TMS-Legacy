import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tms/network/connectivity.dart';
import 'package:tms/providers/connection_provider.dart';

class TmsAppBarSettingsAction extends StatelessWidget {
  final GoRouterState state;

  const TmsAppBarSettingsAction({
    super.key,
    required this.state,
  });

  Icon _state2Wifi(NetworkConnectionState state) {
    IconData icon = Icons.settings;
    Color color = Colors.white;

    switch (state) {
      case NetworkConnectionState.disconnected:
        color = Colors.red;
      case NetworkConnectionState.connected:
        color = Colors.white;
    }

    return Icon(icon, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ConnectionProvider, NetworkConnectionState>(
      selector: (_, connectionProvider) => connectionProvider.state,
      builder: (_, connectionSate, _) => IconButton(
        onPressed: () {
          if (state.matchedLocation == '/connection') {
            context.go('/');
          } else {
            context.goNamed('connection');
          }
        },
        icon: _state2Wifi(connectionSate),
      ),
    );
  }
}
