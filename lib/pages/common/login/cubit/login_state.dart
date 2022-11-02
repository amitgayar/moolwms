part of 'login_cubit.dart';


enum PageType {
  mobile,
  otp
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
