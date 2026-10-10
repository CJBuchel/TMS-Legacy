import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NoMobileViewWrapper extends StatelessWidget {
  final Widget child;

  const NoMobileViewWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return const Center(
        child: Text("There is no mobile view for this page"),
      );
    } else {
      return child;
    }
  }
}
