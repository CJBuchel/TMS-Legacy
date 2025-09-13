import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tms/views/setup/setup_widget.dart';

// Example of how to use the SetupWidget in your app
// This could be added to your router or called from another view

class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SetupWidget();
  }
}

// // Alternative usage as a dialog or modal
// Future<void> showSetupDialog(BuildContext context) {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog.fullscreen(
//         child: ProviderScope(child: const SetupWidget()),
//       );
//     },
//   );
// }
