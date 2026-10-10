import 'package:material_ui/material_ui.dart';

enum TableSignalState {
  SIG,
  STANDBY,
  READY,
}

class GameTableStatus extends StatelessWidget {
  final TableSignalState state;
  final AnimationController blinkController;

  const GameTableStatus({
    super.key,
    required this.state,
    required this.blinkController,
  });

  Widget _statusText(TableSignalState state) {
    Color? color = Colors.red;
    String text = "SIG";

    switch (state) {
      case TableSignalState.SIG:
        color = Colors.red;
        text = "SIG";
      case TableSignalState.STANDBY:
        color = const Color(0xFFCE7500);
        text = "STBY";
      case TableSignalState.READY:
        color = Colors.green;
        text = "RDY";
    }

    return AnimatedBuilder(
      animation: blinkController,
      builder: (context, child) {
        Color? statusColor = color;
        if (state == TableSignalState.SIG) {
          statusColor = blinkController.value < 0.5 ? color : Colors.transparent;
        }

        return Text(
          text,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _statusText(state),
    );
  }
}
