
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moolwms/utils/dev_utils.dart';

extension StringExtensions on String {
  bool get isNullOrEmpty {
    return [null, "", "null"].contains(this);
  }

  String get convertDateStringTZ{
    dynamic temp1 = this;
    // temp1 = DateFormat('yyyy-MM-dd').format(selectedDate);
    temp1 = DateTime.parse(temp1);
    temp1 = temp1.toString();
    String dateWithTZ = temp1.substring(0, 10) + 'T' + temp1.substring(11, 23 ) + "Z";
    logPrint.wtf('convert : $dateWithTZ');
    return dateWithTZ;
  }


}

extension BoolExtensions on bool {
  bool get isNullOrTrue {
    return [null, true].contains(this);
  }
  bool get isNullOrFalse {
    return [null, false].contains(this);
  }

}



extension DateTimeExtensions on DateTime {
  bool isUnderage() =>
      (DateTime(DateTime.now().year, month, day)
              .isAfter(DateTime.now())
          ? DateTime.now().year - year - 1
          : DateTime.now().year - year) <
      18;

}


extension DateTimeTZExtensions on DateTime {


  String  get convertMyDateTZ{
    dynamic temp1;
    temp1 = DateFormat('yyyy-MM-dd').format(this);
    temp1 = DateTime.parse(temp1);
    temp1 = temp1.toString();
    String dateWithTZ = temp1.substring(0, 10) + 'T' + temp1.substring(11, 23 ) + "Z";
    logPrint.wtf('convert : $dateWithTZ');
    return dateWithTZ;
  }
}


extension DurationExtensions on Duration {
  String get hms {
    if (inMicroseconds < 0) {
      return "-${-this}";
    }
    String twoDigitMinutes =
        _twoDigits(inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        _twoDigits(inSeconds.remainder(Duration.secondsPerMinute));
    return "${inHours}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  }

  String get hm {
    if (inMicroseconds < 0) {
      return "-${-this}";
    }
    String twoDigitMinutes =
        _twoDigits(inMinutes.remainder(Duration.minutesPerHour));
    return "${inHours}h ${twoDigitMinutes}m";
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
