import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/base/app_bar.dart';

class BaseScaffold extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const BaseScaffold({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: BaseAppBar(), body: child);
  }
}
