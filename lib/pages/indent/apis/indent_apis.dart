import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/pages/indent/model/indent_list_model.dart';
import 'package:moolwms/utils/api_utils.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/utils/shared_pref_utils.dart';




class IndentDataRepository {

  static Future<String> getToken({String user = '', bool dummy = false}) async{
    return await PrefData.getPref(PrefData.token);
    // return "RYRohWEBw6T89ol0JrYd6GB87ELNdseizsAGmDO9qxmKKqGum08AyyDaMs3ojlqX";
  }


  ///Indent/getIndents
  static Future<IndentListModel> getIndentsList(Map<String, dynamic> body) async{
    // {
    //  "locationId": "53",
    //  "pageNumber":1,
    //  "pageSize":4
    // }
    String url = "${APIConstants.baseUrlIndent}Indent/getIndents";
    var model = IndentListModel.fromJson(await ApiUtils.httpPost(url, body,  await getToken()));
    return model;
  }
  ///indent/deleteIndentById
  static Future deleteIndentById(Map<String, dynamic> body) async{
    // {
    //   "indentId":1
    // }
    String url = "${APIConstants.baseUrlIndent}indent/deleteIndentById";
    var model = (ApiUtils.httpPost(url, body,  await getToken()));
    return model;
  }

  ///indent/addIndent
  static Future<Map<String, dynamic>> addIndent(Map<String, dynamic> body) async{
    // {
    //   "requestType": "Inward",
    // "fkDockId": 1,
    // "driverMobileNumber": "+919899543112",
    // "vehicleNumber": "CD GK ki h",
    // "serviceDate": "12/05/2022",
    // "serviceSlot": "03:00 AM - 04:00 AM",
    // "otherDocUrl": "",
    // "invoiceDocUrl": "",
    // "ewayDocUrl": "",
    // "remarks": "testing by dev",
    // "locationId":"1"
    // }
    String url = "${APIConstants.baseUrlIndent}indent/addIndent";
    var model = (ApiUtils.httpPost(url, body,  await getToken()));
    return model;
  }

  ///Indent/updateIndent
  static Future updateIndent(Map<String, dynamic> body) async{
    // {
    //   "updatedIndentData": {
    // "requestType": "indentListItem.requestType",
    // "fkDockId": 1,
    // "driverMobileNumber": "87878787878",
    // "vehicleNumber": "hssdkf",
    // "serviceDate": "123",
    // "otherDocUrl": "indentListItem.otherDocUrl",
    // "invoiceDocUrl": "indentListItem.invoiceDocUrl",
    // "ewayDocUrl": "indentListItem.ebayDocUrl",
    // "remarks": "remarks",
    // "id": 123,
    // "locationId": "123"
    // }
    // }
    String url = "${APIConstants.baseUrlIndent}Indent/updateIndent";
    var model = (ApiUtils.httpPost(url, body,  await getToken()));
    return model;
  }

  ///Indent/uploadDoc
  static Future uploadImage(filename) async {
    String url = "${APIConstants.baseUrlIndent}file/upload";
    var token = await getToken();
    var request = http.MultipartRequest('POST', Uri.parse(url));

    //todo: must do
    request.headers.putIfAbsent('Authorization', () => token);
    request.headers.putIfAbsent("content", () => "application/json");
    request.headers.putIfAbsent('source', () => APIConstants.apiSource);
    request.headers.putIfAbsent('version', () => APIConstants.apiVersion);
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    logPrint.w('respStr : $respStr');
    // var res = jsonDecode(respStr);
    final parsedJson = json.decode(respStr.toString());
    if(parsedJson['meta']['code'] == 200){
      final result = parsedJson['data']["file_url"];
      return result;
    }
    else{
      return "";
    }

  }

}
