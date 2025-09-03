import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/providers/auth_provider.dart';

class LoginAction extends ConsumerWidget {
  const LoginAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);

    return IconButton(
      onPressed: () {
        context.push('/login');
      },
      icon: auth.when(
        data: (isLoggedIn) => Icon(isLoggedIn ? Icons.person : Icons.login),
        error: (error, stackTrace) => Icon(Icons.error),
        loading: () => Icon(Icons.login),
      ),
    );
  }
}
