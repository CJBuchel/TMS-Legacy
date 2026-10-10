import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/widgets/app_bar/app_bar.dart';

class BaseScaffold extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const BaseScaffold({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmsAppBar(state: state),
      body: child,
    );
  }
}
