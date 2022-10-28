import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/utils/api_utils.dart';
import 'package:moolwms/utils/dev_utils.dart';

class DataRepository {

  /// login

  Future fetchOtp(String? mobileEntered, {testApi = false}) async {
    if (testApi) {
      logPrint.w('test API(json) Used');
      await Future.delayed(const Duration(seconds: 4));
      return {};
    }
    String? url = "${APIConstants.baseUrl}/loginWithOtp";

    // final response = await http.post(Uri.parse(_url), body: {"mobile_number": mobileEntered});
    return ApiUtils.httpPost(url, {"mobile": mobileEntered}, await ApiUtils.getToken(user: ''));
  }

  Future verifyOtp(data, {testApi = false}) async {
    if (testApi) {
      logPrint.w('test API(json) Used');
      await Future.delayed(const Duration(seconds: 4));
      return {};
    }
    String? url = "${APIConstants.baseUrl}/verifyOtp";

    // final response = await http.post(Uri.parse(_url), body: {"otp":otp, "mobile_number": mobileEntered});
    return ApiUtils.httpPost(url, {}, await ApiUtils.getToken());
  }
}
