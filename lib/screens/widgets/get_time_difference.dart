import 'package:intl/intl.dart';

int getTimeDifference(DateTime timeStarted) {
  Duration diff =
      DateTime.parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()))
          .difference(timeStarted);
  return diff.inSeconds;
}
