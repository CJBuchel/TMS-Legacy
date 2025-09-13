import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/setup_step.dart';

part 'setup_provider.g.dart';

// Generated provider
@riverpod
class SetupNotifier extends _$SetupNotifier {
  @override
  Map<String, List<SetupStep>> build() {
    return _getInitialSetupTabs();
  }

  Map<String, List<SetupStep>> _getInitialSetupTabs() {
    return {
      'System': [
        SetupStep(
          title: 'Server Connection',
          description: 'Configure connection to TMS server',
          icon: Icons.dns,
        ),
        SetupStep(
          title: 'Database Setup',
          description: 'Initialize and configure database',
          icon: Icons.storage,
        ),
        SetupStep(
          title: 'System Validation',
          description: 'Validate system requirements',
          icon: Icons.check_circle_outline,
        ),
      ],
      'Tournament': [
        SetupStep(
          title: 'Tournament Info',
          description: 'Set tournament details and schedule',
          icon: Icons.event,
        ),
        SetupStep(
          title: 'Teams Registration',
          description: 'Configure team registration settings',
          icon: Icons.groups,
        ),
        SetupStep(
          title: 'Judging Setup',
          description: 'Configure judging categories and criteria',
          icon: Icons.gavel,
        ),
      ],
      'Configuration': [
        SetupStep(
          title: 'User Permissions',
          description: 'Set up user roles and permissions',
          icon: Icons.admin_panel_settings,
        ),
        SetupStep(
          title: 'Display Settings',
          description: 'Configure display and presentation settings',
          icon: Icons.display_settings,
        ),
        SetupStep(
          title: 'Final Review',
          description: 'Review all configurations',
          icon: Icons.fact_check,
        ),
      ],
    };
  }

  void updateStepStatus(
    String tabKey,
    int stepIndex, {
    bool? isCompleted,
    bool? isActive,
  }) {
    final currentState = state;
    final currentSteps = List<SetupStep>.from(currentState[tabKey] ?? []);
    if (stepIndex < currentSteps.length) {
      currentSteps[stepIndex] = currentSteps[stepIndex].copyWith(
        isCompleted: isCompleted,
        isActive: isActive,
      );
      state = {...currentState, tabKey: currentSteps};
    }
  }

  void setActiveStep(String tabKey, int stepIndex) {
    final currentState = state;
    final newState = <String, List<SetupStep>>{};

    for (final entry in currentState.entries) {
      final steps = entry.value.asMap().entries.map((stepEntry) {
        final isCurrentTab = entry.key == tabKey;
        final isCurrentStep = stepEntry.key == stepIndex;
        return stepEntry.value.copyWith(
          isActive: isCurrentTab && isCurrentStep,
        );
      }).toList();
      newState[entry.key] = steps;
    }

    state = newState;
  }

  void completeStep(String tabKey, int stepIndex) {
    updateStepStatus(tabKey, stepIndex, isCompleted: true, isActive: false);
  }
}
