import 'package:go_router/go_router.dart';
import 'package:tms/base/base_scaffold.dart';
import 'package:tms/views/home/home_screen.dart';

final _protectedRoutes = <GoRoute>[];

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
