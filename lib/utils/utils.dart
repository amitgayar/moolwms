import 'package:flutter/services.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/utils/dev_utils.dart';

export 'Extensions.dart';


class TextUtils {
  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(email);
  }

  static String trimSpecific(String data, String trimChar) {
    if (data.startsWith(trimChar)) {
      return data.replaceFirst(trimChar, '');
    }
    return data;
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(
      e.value)}')
      .join('&');
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

getColorCode(String? colorCode) {

  if(colorCode == null ||  colorCode.isEmpty) {
    return ColorConstants.boxOutline;
  }
  else{
    try {
      return Color(int.parse(colorCode.substring(1), radix: 16)+0xFF000000
      );
    } catch(e) {
      logPrint.e('color: $colorCode,\nerror : $e');
      return ColorConstants.boxOutline;
    }

  }

}




