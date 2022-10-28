import 'dart:math';

import 'package:logger/logger.dart';


class MyLogFilter extends LogFilter{
  @override
  bool shouldLog(LogEvent event) {
    return
      true;
    // false;
  }
}

// Logger logPrint = Logger(filter: MyLogFilter());

Logger logPrint = Logger();


logLargeString(String text){
  var max = text.length;
  for( var v = 0; v < text.length ; v += 900){
    if(max > v + 900) {
      logPrint.w("text.length : ${text.length}, \noffset:$v : ${text.substring(v, v+900)}");
    }
    else{
      logPrint.w("text.length : ${text.length}, \noffset:$v : ${text.substring(v)}");

    }
  }
}


class TempFunc{
  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) {
        var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
        var rnd = Random();
        return chars.codeUnitAt(rnd.nextInt(chars.length));
      }));
}
///todo: temp check
