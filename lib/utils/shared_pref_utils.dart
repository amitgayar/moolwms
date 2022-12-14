import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static const token = 'token';
  static const userId = 'userId';
  static const userName = 'userName';
  static const userNumber = 'userNumber';

  static const String userRole = "userRole";
  static const String autoLogin = "autoLogin";
  static const String isLoggedIn = "isLogin";
  static const String fcmToken = "fcmToken";
  static const String jwtToken = "jwtToken";
  static const String languageCode = "languageCode";
  //todo: save locationId
  static const String locationId = "locationId";
  static const String customerId = "customerId";
  static const String locationMappingId = "locationMappingId";
  static const String orgId = "orgId";


  static Future<void> setJwtData(String tokenVal, {isLogin = false}) async {
    if (tokenVal.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenVal);
      logPrint.w('decodedToken : $decodedToken');
      String json = jsonEncode(decodedToken["user"]);
      setPref(jwtToken, json);
      setPref(token, tokenVal);
    }
  }

  static setPref(String key, dynamic value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case String:
        pref.setString(key, value);
        return;
      case bool:
        pref.setBool(key, value);
        return;
      case double:
        pref.setDouble(key, value);
        return;
      case int:
        pref.setInt(key, value);
        return;
      case List:
        pref.setStringList(key, value);
        return;
    }
  }

  static dynamic getPref(String key, {dynamic defaultValue}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey(key)) {
      return pref.get(key);
    } else {
      return defaultValue;
    }
  }

  static Future<void> clearSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
