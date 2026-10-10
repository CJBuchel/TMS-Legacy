import 'package:material_ui/material_ui.dart';
import 'package:tms/generated/infra/database_schemas/tms_time/tms_date_time.dart';
import 'package:tms/widgets/timers/time_until.dart';

class NextMatchTimeToScore extends StatelessWidget {
  final TmsDateTime? startTime;
  final double fontSize;

  const NextMatchTimeToScore({
    super.key,
    this.startTime,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${startTime?.time.toString()} (",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
        TimeUntil(
          time: startTime ?? TmsDateTime(),
          positiveStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            // fontFamily: 'monospace',
          ),
          negativeStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.red,
            // fontFamily: 'monospace',
          ),
        ),
        Text(
          ")",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
