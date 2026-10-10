import 'package:material_ui/material_ui.dart';
import 'package:tms/widgets/tables/base_table.dart';

class FilterRowCell extends BaseTableCell {
  final BuildContext context;
  final String text;
  final Color? color;

  FilterRowCell({
    required this.context,
    required this.text,
    super.flex,
    this.color,
  }) : super(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Center(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
}
