import 'package:echo_tree_flutter/widgets/echo_tree_lifetime_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tms/views/dashboard/dashboard_info_banner.dart';
import 'package:tms/views/dashboard/integrity_overview/integrity_overview.dart';
import 'package:tms/views/dashboard/scoring_overview/scoring_overview.dart';
import 'package:tms/views/dashboard/timers_overview.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return EchoTreeLifetime(
      trees: [
        ":tournament:integrity_messages",
        ":judging:sessions",
        ":robot_game:matches",
        ":robot_game:game_scores",
        ":teams",
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return const Column(
            children: [
              // header (matches, sessions, score submissions)
              SizedBox(
                height: 100,
                child: DashboardInfoBanner(),
              ),
              // event summery
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: TimersOverview()),
                          Expanded(flex: 1, child: IntegrityOverview()),
                        ],
                      ),
                    ),
                    Expanded(flex: 1, child: ScoringOverview()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
