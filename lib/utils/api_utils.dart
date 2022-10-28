import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/utils/dev_utils.dart';




class ApiUtils {

  /// indent api token
  static Future<String> getToken({String user = '', bool dummy = false}) async{
    return "RYRohWEBw6T89ol0JrYd6GB87ELNdseizsAGmDO9qxmKKqGum08AyyDaMs3ojlqX";
  }

  /// ---------------------------------------------- hit functions ----------------------------------------------

  static Future<Map<String, dynamic>> httpGet(String url, token) async{
    logPrint.d("fetching from URL - $url");
    final response = await http.get(Uri.parse(url),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   "Authorization": token
        // }
        headers: <String, String>{
        "source": APIConstants.apiSource,
        "version": APIConstants.apiVersion,
        "Accept": "application/json",
        "Authorization": token
        }

    ).timeout(
      const Duration(seconds: APIConstants.timeOut),
      onTimeout: () {
        return http.Response(jsonEncode({"message":APIConstants.timeOutMsg}), 408);
      },
    );
    return parseResponse(response);
  }

  static  Future<Map<String, dynamic>> httpPost (String url, Map<String, dynamic> body, String token) async{
    logPrint.d("fetching from URL - $url with :\nbody: $body\ntoken: $token");
    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": token,
        "source": APIConstants.apiSource,
        "version": APIConstants.apiVersion,
      },
      body: jsonEncode(body),
    ).timeout(
       const Duration(seconds: APIConstants.timeOut),
      onTimeout: () {
        return http.Response(jsonEncode({"message":APIConstants.timeOutMsg}), 408);
      },
    );
    return parseResponse(response);
  }

  static Future oldHttpGet(String url, token) async{
    logPrint.d("fetching from URL - $url");
    final response = await http.get(Uri.parse(url),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   "Authorization": token
        // }
        headers: <String, String>{
          "source": APIConstants.apiSource,
          "version": APIConstants.apiVersion,
          "Accept": "application/json",
          "Authorization": token
        }

    ).timeout(
      const Duration(seconds: APIConstants.timeOut),
      onTimeout: () {
        return http.Response(jsonEncode({"message":APIConstants.timeOutMsg}), 408);
      },
    );
    return (response);
  }

  static  Future oldHttpPost (String url, Map<String, dynamic> body, String token) async{
    logPrint.d("fetching from URL - $url with :\nbody: $body\ntoken: $token");
    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": token,
        "source": APIConstants.apiSource,
        "version": APIConstants.apiVersion,
      },
      body: jsonEncode(body),
    ).timeout(
      const Duration(seconds: APIConstants.timeOut),
      onTimeout: () {
        return http.Response(jsonEncode({"message":APIConstants.timeOutMsg}), 408);
      },
    );
    return (response);
  }

  /// RESPONSE PARSERS

  static Map<String, dynamic> parseResponse(http.Response response) {
    //todo: ALICE
    // alice.onHttpResponse(response);
    // logPrint.wtf("response: ${response.body}");
    final Map<String, dynamic> responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      logPrint.d("server responseMap - $responseMap");
      return responseMap;
    }
    else {
      logPrint.e("status : ${response.statusCode} with serverData response - $responseMap");
      throw Exception(
          'failed to fetch with response.statusCode = ${response.statusCode}');
    }
  }


}
