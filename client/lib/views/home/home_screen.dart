import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tms/helpers/permissions.dart';
import 'package:tms/providers/auth_provider.dart';
import 'package:tms/views/home/admin_views.dart';

/// Pastel colors
/// 0xff8E97FD blue/purple
/// 0xffFFC97E yellow
/// 0xffFA6E5A red
/// 0xff6CB28E green
/// 0xffD291BC violet
/// 0xff2ACAC8 cyan
/// 0xFF828282 grey
/// 0xFF2D7F9D steel blue

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  Widget _showWidgetWithRole(WidgetRef ref, Widget widget, Role role) {
    if (ref.read(authenticationProvider.notifier).hasPermission(role)) {
      return widget;
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final showBottomGradient = useState(true);
    final userAuth = ref.watch(authenticationProvider);

    useEffect(() {
      void checkScrollPosition() {
        if (scrollController.hasClients) {
          final isAtBottom =
              scrollController.offset >=
              scrollController.position.maxScrollExtent - 50;
          showBottomGradient.value = !isAtBottom;
        }
      }

      scrollController.addListener(checkScrollPosition);

      // Initial check
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkScrollPosition();
      });

      return () => scrollController.removeListener(checkScrollPosition);
    }, [scrollController]);

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _showWidgetWithRole(ref, AdminViews(), Role.admin),
              ]),
            ),
            // Add some bottom padding to show the gradient better
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
        // Bottom gradient to indicate more content below
        if (showBottomGradient.value)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                      Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
