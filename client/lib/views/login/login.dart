import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/providers/auth_provider.dart';

class Login extends ConsumerWidget {
  // text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Login({super.key});

  Widget _username() {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
            hintText: 'Enter username, e.g `admin`',
          ),
        ),
      ),
    );
  }

  Widget _password() {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 25),
        child: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
            hintText: 'Enter password, e.g `admin`',
          ),
        ),
      ),
    );
  }

  Widget _login(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 5,
      children: [
        _username(),
        _password(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle login
            ref
                .read(authenticationProvider.notifier)
                .login(usernameController.text, passwordController.text)
                .then((success) {
                  if (success && context.mounted) {
                    context.pop();
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Login failed'),
                          content: Text(
                            'Please check your username and password.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                });
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  Widget _logout(WidgetRef ref) {
    final username = ref.read(authenticationProvider.notifier).username;
    return Column(
      spacing: 20,
      children: [
        Text('Welcome back, $username!'),
        ElevatedButton(
          onPressed: () {
            ref.read(authenticationProvider.notifier).logout();
          },
          child: Text('Logout'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authenticationProvider);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: isLoggedIn.when(
            data: (isLoggedIn) {
              return isLoggedIn ? _logout(ref) : _login(context, ref);
            },
            error: (error, _) {
              return Text('Error: $error');
            },
            loading: () {
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
