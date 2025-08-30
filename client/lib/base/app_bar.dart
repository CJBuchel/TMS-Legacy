import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tms/providers/tournament_provider.dart';

class BaseAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const BaseAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch the tournament title provider
    final tournamentTitle = ref.watch(tournamentTitleProvider);

    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(tournamentTitle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
