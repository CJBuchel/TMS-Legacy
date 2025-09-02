import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tms/base/actions/login_action.dart';
import 'package:tms/providers/tournament_provider.dart';

class BaseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showActions;
  const BaseAppBar({super.key, this.title, this.showActions = true});

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    if (showActions) {
      return [LoginAction()];
    }
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch the tournament title provider
    final String tournamentTitle = title ?? ref.watch(tournamentTitleProvider);

    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(tournamentTitle),
      actions: _buildActions(context, ref),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
