import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tms/providers/setup_provider.dart';

import 'setup_steps_view.dart';

class SetupWidget extends ConsumerStatefulWidget {
  const SetupWidget({super.key});

  @override
  ConsumerState<SetupWidget> createState() => _SetupWidgetState();
}

class _SetupWidgetState extends ConsumerState<SetupWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final setupState = ref.read(setupNotifierProvider);
    _tabController = TabController(length: setupState.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(setupNotifierProvider);
    final tabKeys = setupState.keys.toList();

    return Column(
      children: [
        // TabBar without AppBar
        Material(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            controller: _tabController,
            tabs: tabKeys.map((key) {
              IconData icon;
              switch (key) {
                case 'System':
                  icon = Icons.settings_system_daydream;
                  break;
                case 'Tournament':
                  icon = Icons.emoji_events;
                  break;
                case 'Configuration':
                  icon = Icons.tune;
                  break;
                default:
                  icon = Icons.settings;
              }
              return Tab(icon: Icon(icon), text: key);
            }).toList(),
          ),
        ),
        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabKeys.map((tabKey) {
              final steps = setupState[tabKey] ?? [];
              return SetupStepsView(tabKey: tabKey, steps: steps);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
