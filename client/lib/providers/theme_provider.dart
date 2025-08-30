import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tms/helpers/local_storage.dart';

part 'theme_provider.g.dart';

@riverpod
ThemeMode tmsThemeMode(Ref ref) {
  final String key = 'theme_mode';

  return switch (localStorage.getString(key)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
