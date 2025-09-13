import 'package:flutter/material.dart';

import '../../models/setup_step.dart';

class SetupStepItem extends StatelessWidget {
  final SetupStep step;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const SetupStepItem({
    super.key,
    required this.step,
    required this.isLast,
    required this.onTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    Color stepColor;
    IconData stepIcon;

    if (step.isCompleted) {
      stepColor = Colors.green;
      stepIcon = Icons.check;
    } else if (step.isActive) {
      stepColor = Colors.blue;
      stepIcon = step.icon;
    } else {
      stepColor = Colors.grey;
      stepIcon = step.icon;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              // Circle indicator
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stepColor,
                    border: step.isActive
                        ? Border.all(color: stepColor, width: 3)
                        : null,
                  ),
                  child: Icon(stepIcon, color: Colors.white, size: 20),
                ),
              ),
              // Connecting line
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Step content
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: step.isActive
                      ? Border.all(color: Colors.blue, width: 2)
                      : Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            step.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: step.isCompleted
                                      ? Colors.green
                                      : step.isActive
                                      ? Colors.blue
                                      : null,
                                ),
                          ),
                        ),
                        if (step.isActive && !step.isCompleted)
                          ElevatedButton.icon(
                            onPressed: onComplete,
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
