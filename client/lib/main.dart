import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tms/app.dart';
import 'package:tms/providers/local_storage_provider.dart';

void main() async {
  // Initialize local storage
  await initializeLocalStorage();

  // Run app
  runApp(ProviderScope(child: TmsApp()));
}
