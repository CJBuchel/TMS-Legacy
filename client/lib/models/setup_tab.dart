import 'package:flutter/material.dart';

import 'setup_step.dart';

class SetupTab {
  final String title;
  final IconData icon;
  final List<SetupStep> steps;

  SetupTab({required this.title, required this.icon, required this.steps});
}
