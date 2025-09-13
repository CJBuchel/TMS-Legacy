import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/widgets/dialogs/base_dialog.dart';
import 'package:tms/widgets/dialogs/dialog_style.dart';

class ConfirmDialog extends BaseDialog {
  final DialogStyle style;
  final Function? onConfirm;
  final Function? onCancel;
  final bool isAsync;

  ConfirmDialog({
    required this.style,
    this.onConfirm,
    this.onCancel,
    this.isAsync = false,
  });

  // Factory method for async operations
  factory ConfirmDialog.future({
    required DialogStyle style,
    Future<dynamic> Function()? onConfirm,
    Function? onCancel,
  }) {
    return ConfirmDialog(
      style: style,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isAsync: true,
    );
  }

  Widget _buildTitle() {
    IconData iconData;
    Color iconColor;

    switch (style.type) {
      case DialogType.info:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
      case DialogType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case DialogType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      case DialogType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
    }

    return Row(
      children: [
        Icon(iconData, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            style.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    Color color;

    switch (style.type) {
      case DialogType.error:
        color = Colors.red;
        break;
      case DialogType.info:
        color = Colors.blue;
        break;
      case DialogType.warning:
        color = Colors.orange;
        break;
      case DialogType.success:
        color = Colors.green;
        break;
    }

    return [
      TextButton(
        onPressed: () {
          onCancel?.call();
          context.pop();
        },
        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
      ),
      TextButton(
        onPressed: () {
          onConfirm?.call();
          context.pop();
        },
        child: Text("Confirm", style: TextStyle(color: color)),
      ),
    ];
  }

  @override
  void show(BuildContext context) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return isAsync
            ? _AsyncConfirmDialog(
                style: style,
                onConfirm: onConfirm as Future<dynamic> Function()?,
                onCancel: onCancel,
              )
            : AlertDialog(
                title: _buildTitle(),
                content: style.message,
                actions: _buildActions(context),
              );
      },
    );
  }
}

class _AsyncConfirmDialog extends HookWidget {
  final DialogStyle style;
  final Future<void> Function()? onConfirm;
  final Function? onCancel;

  const _AsyncConfirmDialog({
    required this.style,
    required this.onConfirm,
    this.onCancel,
  });

  Widget _buildTitle() {
    IconData iconData;
    Color iconColor;

    switch (style.type) {
      case DialogType.info:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
      case DialogType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case DialogType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      case DialogType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
    }

    return Row(
      children: [
        Icon(iconData, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            style.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    Color color;
    switch (style.type) {
      case DialogType.error:
        color = Colors.red;
        break;
      case DialogType.info:
        color = Colors.blue;
        break;
      case DialogType.warning:
        color = Colors.orange;
        break;
      case DialogType.success:
        color = Colors.green;
        break;
    }

    Future<void> handleConfirm() async {
      if (onConfirm == null) {
        context.pop();
        return;
      }

      isLoading.value = true;

      try {
        await onConfirm!();
        if (context.mounted) {
          context.pop();
        }
      } catch (error) {
        // Handle error if needed - you might want to show an error dialog
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    return AlertDialog(
      title: _buildTitle(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          style.message,
          if (isLoading.value) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(color: color),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading.value
              ? null
              : () {
                  onCancel?.call();
                  context.pop();
                },
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: isLoading.value ? null : handleConfirm,
          child: Text("Confirm", style: TextStyle(color: color)),
        ),
      ],
    );
  }
}
