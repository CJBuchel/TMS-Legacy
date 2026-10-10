import 'package:material_ui/material_ui.dart';
import 'package:tms/generated/infra/database_schemas/game_match.dart';

class NextMatchToScore extends StatelessWidget {
  final GameMatch? nextMatch;
  final int totalMatches;
  final double fontSize;

  const NextMatchToScore({
    super.key,
    this.nextMatch,
    this.totalMatches = 0,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Match: ${nextMatch?.matchNumber}/$totalMatches",
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
      ),
    );
  }
}
