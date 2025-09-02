import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/providers/auth_provider.dart';

class LoginAction extends ConsumerWidget {
  const LoginAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    return auth.when(
      data: (isLoggedIn) {
        return IconButton(
          icon: Icon(isLoggedIn ? Icons.person : Icons.login),
          onPressed: () {
            context.push('/login');
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
}
