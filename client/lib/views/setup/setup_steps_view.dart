import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tms/models/setup_step.dart';
import 'package:tms/providers/setup_provider.dart';

import 'setup_step_item.dart';

class SetupStepsView extends ConsumerWidget {
  final String tabKey;
  final List<SetupStep> steps;

  const SetupStepsView({super.key, required this.tabKey, required this.steps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$tabKey Setup',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                final isLast = index == steps.length - 1;

                return SetupStepItem(
                  step: step,
                  isLast: isLast,
                  onTap: () {
                    ref
                        .read(setupNotifierProvider.notifier)
                        .setActiveStep(tabKey, index);
                  },
                  onComplete: () {
                    ref
                        .read(setupNotifierProvider.notifier)
                        .completeStep(tabKey, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
