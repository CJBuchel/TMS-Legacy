import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tms/helpers/permissions.dart';
import 'package:tms/providers/auth_provider.dart';
import 'package:tms/providers/tournament_provider.dart';
import 'package:tms/views/home/admin_views.dart';
import 'package:tms/widgets/dialogs/confirm_dialog.dart';
import 'package:tms/widgets/dialogs/dialog_style.dart';

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
    final isAuthenticated = ref.watch(authenticationProvider);
    final tournamentData = ref.watch(tournamentDataProvider);
    final hasShownDialog = useState(false);

    // Handle showing the dialog when not authenticated
    useEffect(() {
      if (isAuthenticated.hasValue &&
          !isAuthenticated.value! &&
          !hasShownDialog.value &&
          !tournamentData.bootstrapped) {
        hasShownDialog.value = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ConfirmDialog.future(
            style: DialogStyle.info(
              title: "Initial Setup",
              message: const Text("Run through first time setup?"),
            ),
            onConfirm: () async {
              // login with default credentials
              final success = await ref
                  .read(authenticationProvider.notifier)
                  .login('admin', 'admin');

              if (success) {
                // Navigate to setup screen
                if (context.mounted) {
                  // remove all previous routes, and push from home screen to setup
                  context.goNamed('home');
                  context.pushNamed('setup');
                }
              } else {
                // Show error dialog
                if (context.mounted) {
                  ConfirmDialog(
                    style: DialogStyle.error(
                      title: "Login Failed",
                      message: const Text(
                        "Failed to login with default credentials. Please check server connection.",
                      ),
                    ),
                  ).show(context);
                }
              }
            },
          ).show(context);
        });
      }

      // Reset the flag when user becomes authenticated
      if (isAuthenticated.hasValue && isAuthenticated.value!) {
        hasShownDialog.value = false;
      }

      return null;
    }, [isAuthenticated]);

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

    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            isAuthenticated.when(
              data: (isAuthenticated) {
                if (isAuthenticated) {
                  return _showWidgetWithRole(ref, AdminViews(), Role.admin);
                } else {
                  // Just return empty widget - dialog is handled in useEffect
                  return const SizedBox.shrink();
                }
              },
              error: (error, stack) {
                return Center(child: Text('Error: $error'));
              },
              loading: () => const CircularProgressIndicator(),
            ),
          ]),
        ),
        // Add some bottom padding to show the gradient better
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}
