import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/repository/data_repository.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:http/http.dart' as http;


part 'my_app_state.dart';

class MyAppCubit extends Cubit<MyAppState> {
  MyAppCubit(MyAppState initialState) : super(initialState);

  final DataRepository dataRepository = DataRepository();
  // ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();



///stream for checkConnectivity
void checkConnectivityStream() {
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  connectivitySubscription = connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  connectivitySubscription.cancel();
}

///checkConnectivity
Future<ConnectivityResult?> checkConnectivity(ConnectivityResult res) async {
  late ConnectivityResult result;
  try {
    result = await connectivity.checkConnectivity();
    // return result;
  } on PlatformException catch (e) {
    logPrint.w("Couldn't check connectivity status \nerror: $e", );
    // return ConnectivityResult.none;
    result = ConnectivityResult.none;
  }
  emit(state.copyWith(connectionStatus: res));
  logPrint.e(result);
  return null;


}

Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  ///emit connectivity message
}

  void loadingState(val) async{
    emit(state.copyWith(isLoading: val));
    // await Future.delayed(const Duration(seconds: 3));
    // emit(state.copyWith(isLoading: false));
  }
  void loadedState() async{
    emit(state.copyWith(isLoading: false));
  }

    Future httpPost ( Map<String, dynamic> body) async{
    String url = "${APIConstants.baseUrlIndent}Indent/updateIndent";
    var token = 'RYRohWEBw6T89ol0JrYd6GB87ELNdseizsAGmDO9qxmKKqGum08AyyDaMs3ojlqX';
    logPrint.w("fetching from URL - $url with :\nbody: $body\ntoken: $token");
    loadingState(false);
    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": token
      },
      body: jsonEncode(body),
    ).timeout(
      const Duration(milliseconds: 5),
      onTimeout: () {
        return http.Response(jsonEncode({'timeOut':'Error'}), 408);
      },
    );
    var test =  parseResponse(response).toString();
    emit(state.copyWith(isLoading: false, test: test ));
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
      return responseMap;
      // throw Exception(
      //     'failed to fetch with response.statusCode = ${response.statusCode}');
    }
  }

  void getOrders(Map<String, dynamic> body) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    dataRepository.verifyOtp(body).then((value) async {
      // MyAppModel model = MyAppModel.fromJson(value);
      if (value['meta']['code'] == 200) {
        // setJwtData(_model.token!);
      }
      // Map data = await getSavedData().then((value) => value);
      emit(state.copyWith());
    });
  }
}
