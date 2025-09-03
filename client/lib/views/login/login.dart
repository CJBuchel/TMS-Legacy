import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tms/providers/auth_provider.dart';

class Login extends HookConsumerWidget {
  const Login({super.key});

  Widget _username(TextEditingController controller) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
            hintText: 'Enter username, e.g `admin`',
          ),
        ),
      ),
    );
  }

  Widget _password(TextEditingController controller) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 25),
        child: TextField(
          controller: controller,
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

  Widget _logout(WidgetRef ref) {
    final username = ref.read(authenticationProvider.notifier).username;
    return Column(
      children: [
        Text('Welcome back, $username!'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            ref.read(authenticationProvider.notifier).logout();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final authState = ref.watch(authenticationProvider);

    void handleLogin() async {
      isLoading.value = true;

      final success = await ref
          .read(authenticationProvider.notifier)
          .login(usernameController.text, passwordController.text);

      if (context.mounted) {
        if (success) {
          context.pop();
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login failed'),
              content: const Text('Please check your username and password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }

      isLoading.value = false;
    }

    Widget loginWidget() {
      return Column(
        children: [
          _username(usernameController),
          _password(passwordController),
          const SizedBox(height: 20),
          if (isLoading.value)
            const CircularProgressIndicator()
          else
            ElevatedButton(onPressed: handleLogin, child: const Text('Login')),
        ],
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: authState.when(
            data: (isLoggedIn) {
              return isLoggedIn ? _logout(ref) : loginWidget();
            },
            error: (error, _) {
              return loginWidget();
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
