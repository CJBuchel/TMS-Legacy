import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tms/providers/auth_provider.dart';
import 'package:tms/providers/tournament_provider.dart';

class BaseAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const BaseAppBar({super.key});

  Widget _loginButton(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    return auth.when(
      data: (isLoggedIn) {
        return IconButton(
          icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
          onPressed: () {
            // Handle login/logout action
          },
        );
      },
      error: (error, stackTrace) => IconButton(
        icon: Icon(Icons.error),
        onPressed: () {
          // Handle error action
        },
      ),
      loading: () {
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch the tournament title provider
    final tournamentTitle = ref.watch(tournamentTitleProvider);

    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(tournamentTitle),
      actions: [_loginButton(context, ref)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
