import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/base/app_bar.dart';
import 'package:tms/base/base_scaffold.dart';
import 'package:tms/helpers/permissions.dart';
import 'package:tms/providers/auth_provider.dart';
import 'package:tms/views/home/home_screen.dart';
import 'package:tms/views/login/login.dart';
import 'package:tms/views/setup/setup.dart';

final _homeRoute = '/';
final _loginRoute = '/login';
final _adminRoute = '/admin';
final _setupRoute = '$_adminRoute/setup';

final _adminRoutes = Provider<GoRoute>((ref) {
  return GoRoute(
    path: _adminRoute,
    routes: [
      GoRoute(
        name: 'setup',
        path: _setupRoute,
        builder: (context, state) =>
            BaseScaffold(state: state, child: const SetupPage()),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authenticationProvider.notifier);
      if (!authState.hasPermission(Role.admin)) {
        return _loginRoute;
      }
      return null;
    },
  );
});

final _publicRoutes = <GoRoute>[
  GoRoute(
    name: 'login',
    path: _loginRoute,
    builder: (context, state) => Scaffold(
      body: Login(),
      appBar: BaseAppBar(title: 'Login', showActions: false),
    ),
  ),
];

final router = GoRouter(
  initialLocation: _homeRoute,
  routes: <RouteBase>[
    GoRoute(
      name: 'home',
      path: _homeRoute,
      builder: (context, state) =>
          BaseScaffold(state: state, child: const HomeScreen()),
    ),
    ..._publicRoutes,
    ..._adminRoutes.read(ProviderContainer()).routes,
  ],
);
