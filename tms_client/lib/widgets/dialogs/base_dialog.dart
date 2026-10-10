import 'package:material_ui/material_ui.dart';

enum DialogType { error, info, success, warn }

abstract class BaseDialog {
  void show(BuildContext context);
}
