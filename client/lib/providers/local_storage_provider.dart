import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_provider.g.dart';

late SharedPreferences _gls;

Future<void> initializeLocalStorage() async {
  _gls = await SharedPreferences.getInstance();
}

SharedPreferences get localStorage => _gls;

// functional version
@riverpod
ThemeMode tmsThemeMode(Ref ref) {
  final String key = 'theme_mode';

  return switch (localStorage.getString(key)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
