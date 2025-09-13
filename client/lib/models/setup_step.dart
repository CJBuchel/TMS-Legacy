import 'package:flutter/material.dart';

class SetupStep {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;

  SetupStep({
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
    this.isActive = false,
  });

  SetupStep copyWith({
    String? title,
    String? description,
    IconData? icon,
    bool? isCompleted,
    bool? isActive,
  }) {
    return SetupStep(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
    );
  }
}
