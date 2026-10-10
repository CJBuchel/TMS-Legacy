import 'package:material_ui/material_ui.dart';

class NextRoundToScore extends StatelessWidget {
  final int round;
  final double fontSize;

  const NextRoundToScore({
    super.key,
    this.round = 0,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Round: $round",
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
      ),
    );
  }
}
