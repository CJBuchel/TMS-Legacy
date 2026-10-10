import 'package:echo_tree_flutter/widgets/echo_tree_lifetime_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tms/views/scoreboard/judging_info/judging_info.dart';
import 'package:tms/views/scoreboard/matches_info/matches_info.dart';
import 'package:tms/views/scoreboard/scoreboard_header.dart';
import 'package:tms/views/scoreboard/teams_ranking_list/teams_ranking_list.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const EchoTreeLifetime(
      trees: [
        ":teams",
        ":judging:sessions",
        ":robot_game:game_scores",
        ":robot_game:matches",
      ],
      child: Column(
        children: [
          ScoreboardHeader(),
          JudgingInfo(),
          Expanded(
            child: TeamsRankingList(),
          ),
          MatchesInfo(),
        ],
      ),
    );
  }
}
