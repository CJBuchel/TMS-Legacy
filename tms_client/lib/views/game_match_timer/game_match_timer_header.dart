import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tms/generated/infra/database_schemas/game_match.dart';
import 'package:tms/providers/local_storage_provider.dart';
import 'package:tms/providers/robot_game_providers/game_table_provider.dart';
import 'package:tms/models/timer_match_data.dart';

class GameMatchTimerHeader extends StatelessWidget {
  final TimerMatchData data;
  const GameMatchTimerHeader({
    super.key,
    required this.data,
  });

  String _getMatchSummary(List<GameMatch> loadedMatches, GameMatch? nextMatch) {
    if (loadedMatches.isEmpty) {
      if (nextMatch == null) {
        return "No Matches";
      } else {
        String t = nextMatch.startTime.toString();
        return "Next Match: ${nextMatch.matchNumber} - $t";
      }
    } else {
      // get the first match for cat/sub cat
      GameMatch? first = loadedMatches.first;
      String matchNumbers = loadedMatches.map((m) => m.matchNumber).join(", ");
      return "${first.category.category}: $matchNumbers";
    }
  }

  Widget _dropDownTableSelector(BuildContext context) {
    return Selector<GameTableProvider, List<String>>(
      selector: (context, provider) => provider.tables.map((t) => t.tableName).toList(),
      builder: (context, tables, _) {
        // list of initial tables, if they're in the tables list
        List<String> initialTables = TmsLocalStorageProvider().timerAssignedTables.where((t) {
          return tables.contains(t);
        }).toList();

        return _TableAssignButton(tables: tables, initialTables: initialTables);
      },
    );
  }

  Widget _tableSector(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      return Container(
        width: ResponsiveBreakpoints.of(context).screenWidth * 0.3,
        padding: const EdgeInsets.only(right: 10, top: 10),
        child: _dropDownTableSelector(context),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

    double fontSize = 20;
    double edgeInsets = 20;

    if (ResponsiveBreakpoints.of(context).isDesktop) {
      fontSize = 20;
      edgeInsets = 20;
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      fontSize = 18;
      edgeInsets = 10;
    } else if (ResponsiveBreakpoints.of(context).isMobile) {
      fontSize = 16;
      edgeInsets = 5;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(edgeInsets),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: 2,
              ),
              right: BorderSide(
                color: borderColor,
                width: 2,
              ),
            ),
          ),
          child: Text(
            _getMatchSummary(data.loadedMatches, data.nextMatch),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
        _tableSector(context),
      ],
    );
  }
}

// Button showing the tables this timer is assigned to, opens a dialog to change them
class _TableAssignButton extends StatefulWidget {
  final List<String> tables;
  final List<String> initialTables;

  const _TableAssignButton({required this.tables, required this.initialTables});

  @override
  State<_TableAssignButton> createState() => _TableAssignButtonState();
}

class _TableAssignButtonState extends State<_TableAssignButton> {
  late List<String> _selected = [...widget.initialTables];

  Future<void> _showDialog() async {
    final picked = [..._selected];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Assign Timer to Table/s"),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tables.map((table) {
              return FilterChip(
                label: Text(table),
                selected: picked.contains(table),
                onSelected: (selected) {
                  setDialogState(() => selected ? picked.add(table) : picked.remove(table));
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("OK")),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _selected = picked);
      TmsLocalStorageProvider().timerAssignedTables = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.blue.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _showDialog,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Assign Timer to Table/s"),
                  Icon(Icons.table_bar),
                ],
              ),
            ),
          ),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _selected.map((table) => Chip(label: Text(table))).toList(),
            ),
          ),
      ],
    );
  }
}
