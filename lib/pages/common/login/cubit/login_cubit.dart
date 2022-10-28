import 'package:bloc/bloc.dart';
import 'package:moolwms/constants/app_enum.dart';
import 'package:moolwms/repository/data_repository.dart';
import 'package:moolwms/utils/dev_utils.dart';

class LoginCubit extends Cubit<LoginPageState?> {
  LoginCubit(LoginPageState initialState) : super(initialState);

  final DataRepository _dataRepository = DataRepository();

  void verifyMobile(val, mobile, pageType) {
    emit(state?.copyWith(
        isValidMobile: val, mobileEntered: mobile, pageType: pageType));
  }

  void otpUpdate(val) {
    emit(state?.copyWith(isValidMobile: true, otpEntered: val));
  }

  void sendOtp(mobile, fromWhere) async {
    logPrint.v("mobile: $mobile\ncalledFrom : $fromWhere");
    emit(state?.copyWith(mobileEntered: mobile, isLoading: true));
    _dataRepository.fetchOtp(mobile).then((apiResponse) {
      // LoginModel loginModel = LoginModel.fromJson(apiResponse);
      if (apiResponse['meta']['code'] == 200) {
        // setJwtData(apiResponse['token'], isLogin: true);
        emit(state?.copyWith(
            isValidMobile: true,
            mobileEntered: mobile,
            isLoading: false,
            pageType: PageType.otp));
      } else {
        emit(state?.copyWith(
            isValidMobile: true,
            mobileEntered: mobile,
            isLoading: false,
            pageType: PageType.mobile));
      }
    });
  }

  void verifyOtp(otp) async {
    emit(
        state?.copyWith(isValidMobile: true, isLoading: true, otpEntered: otp));

    _dataRepository.verifyOtp({}).then((apiResponse) {
      // LoginModel loginModel = LoginModel.fromJson(apiResponse);
      // var meta = loginModel.meta;
      if (apiResponse['meta']['code'] == 200) {
        emit(state?.copyWith(
            isValidMobile: true, isValidOtp: true, otpEntered: otp));
        // setJwtData(apiResponse['token']);
      } else {
        emit(state?.copyWith(
            isValidMobile: true, isValidOtp: false, otpEntered: otp));
      }

      // logPrint.wtf('otp : $otp : ${loginModel.toJson()}');
      // emit(state?.copyWith(isValidMobile: true, isValidOtp: true));
    });
  }

  // "status": true,
  // "message": "Otp verification failed, Enter valid otp!",
  // "code": 409

  // "status": true,
  // "message": "Otp verified successfully!",
  // "code": 200
  void jwtExtraction() {}

// @override
// void onChange(Change<LoginPageState> change) {
//   super.onChange(change);
//   logPrint.d(change);
// }
//
// @override
// void onError(Object error, StackTrace stackTrace) {
//   logPrint.d('cubit : $error, $stackTrace');
//   super.onError(error, stackTrace);
// }
}

class LoginPageState {
  bool? isLoading = false;
  bool? isValidMobile = false;
  bool? isValidOtp = false;
  String? mobileEntered = "";
  String? otpEntered = "";
  PageType pageType = PageType.mobile;

  LoginPageState.initial() : this._();

  LoginPageState._({
    this.isLoading = false,
    this.isValidOtp = false,
    this.isValidMobile = false,
    this.mobileEntered = '',
    this.otpEntered = '',
    this.pageType = PageType.mobile,
  });

  LoginPageState copyWith(
      {isLoading = false,
      isValidOtp = false,
      isValidMobile = false,
      mobileEntered,
      otpEntered,
      pageType}) {
    return LoginPageState._(
        isLoading: isLoading,
        isValidOtp: isValidOtp,
        isValidMobile: isValidMobile,
        mobileEntered: mobileEntered ?? this.mobileEntered,
        otpEntered: otpEntered ?? '',
        pageType: pageType ?? this.pageType);
  }
}

// todo: observer cubit
// class LoginBlocObserver extends BlocObserver {
//   @override
//   void onCreate(BlocBase bloc) {
//     super.onCreate(bloc);
//     logPrint.d('onCreate -- ${bloc.runtimeType}');
//   }
//
//   @override
//   void onChange(BlocBase bloc, Change change) {
//     super.onChange(bloc, change);
//     logPrint.d('onChange -- ${bloc.runtimeType}, $change');
//   }
//
//   @override
//   void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
//     logPrint.d('onError -- ${bloc.runtimeType}, $error');
//     super.onError(bloc, error, stackTrace);
//   }
//
//   @override
//   void onClose(BlocBase bloc) {
//     super.onClose(bloc);
//     logPrint.d('onClose -- ${bloc.runtimeType}');
//   }
// }
