import 'package:dropdown_search/dropdown_search.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tms/generated/infra/database_schemas/team.dart';

class AddPodWidget extends StatelessWidget {
  final List<String> availablePods;
  final List<Team> availableTeams;
  final ValueNotifier<String> selectedPod;
  final ValueNotifier<Team> selectedTeam;

  const AddPodWidget({super.key, 
    required this.availablePods,
    required this.availableTeams,
    required this.selectedPod,
    required this.selectedTeam,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // team
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: DropdownSearch<Team>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
            ),
            compareFn: (a, b) => a == b,
            items: (filter, loadProps) => availableTeams,
            itemAsString: (t) => "${t.teamNumber} - ${t.name}",
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
                labelText: "Team",
                hintText: "Select Team",
              ),
            ),
            onSelected: (v) {
              if (v != null) selectedTeam.value = v;
            },
            selectedItem: selectedTeam.value,
          ),
        ),
        // pod
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
            ),
            items: (filter, loadProps) => availablePods,
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
                labelText: "Pod",
                hintText: "Select Pod",
              ),
            ),
            onSelected: (v) {
              if (v != null) selectedPod.value = v;
            },
            selectedItem: selectedPod.value,
          ),
        ),
      ],
    );
  }
}
