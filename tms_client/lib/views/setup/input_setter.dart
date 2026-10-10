import 'package:material_ui/material_ui.dart';
import 'package:tms/widgets/dialogs/confirm_dialogs.dart';
import 'package:tms/widgets/dialogs/dialog_style.dart';

class InputSetter extends StatefulWidget {
  final String label;
  final Widget input;
  final Future<void> Function() onSet;

  final DialogStyle? dialogStyle;
  final String? info;
  final double height;

  const InputSetter({super.key, 
    required this.label,
    required this.input,
    required this.onSet,
    this.info,
    this.dialogStyle,
    this.height = 70,
  });

  @override
  State<InputSetter> createState() => _InputSetterState();
}

class _InputSetterState extends State<InputSetter> {
  Future<void>? _future;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          height: widget.height,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(widget.label),
              ),
              Expanded(
                flex: 2,
                child: widget.input,
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (widget.dialogStyle != null) {
                              ConfirmDialog(
                                style: widget.dialogStyle!,
                                onConfirm: () {
                                  setState(() {
                                    _future = widget.onSet();
                                  });
                                },
                              ).show(context);
                            } else {
                              setState(() {
                                _future = widget.onSet();
                              });
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.2,
        ),
      ],
    );
  }
}
