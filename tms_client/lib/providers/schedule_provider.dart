import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tms/services/schedule_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleService _scheduleService = ScheduleService();
  PlatformFile? result;

  Future<void> selectCSV() async {
    // file picker
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (files.isNotEmpty) {
      result = files.first;
      notifyListeners();
    }
  }

  Future<int> uploadSchedule() async {
    if (result != null) {
      return await _scheduleService.uploadSchedule(await result!.readAsBytes());
    } else {
      return HttpStatus.badRequest;
    }
  }
}
