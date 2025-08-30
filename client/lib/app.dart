import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tms/providers/local_storage_provider.dart';
import 'package:tms/router.dart';
import 'package:tms/theme.dart';

class TmsApp extends ConsumerWidget {
  const TmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(tmsThemeModeProvider);

    return MaterialApp.router(
      title: 'TMS',
      routerConfig: router,
      themeMode: themeMode, // default
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
