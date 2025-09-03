import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/base/app_bar.dart';
import 'package:tms/base/base_scaffold.dart';
import 'package:tms/views/home/home_screen.dart';
import 'package:tms/views/login/login.dart';

final _protectedRoutes = <GoRoute>[
  // login route
  GoRoute(
    path: '/login',
    builder: (context, state) => Scaffold(
      body: Login(),
      appBar: BaseAppBar(title: 'Login', showActions: false),
    ),
  ),
];

final _publicRoutes = <GoRoute>[];

final router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) =>
          BaseScaffold(state: state, child: const HomeScreen()),
    ),
    ..._publicRoutes,
    ..._protectedRoutes,
  ],
);
