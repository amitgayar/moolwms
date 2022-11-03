import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/main/my_home_page.dart';
import 'package:moolwms/utils/api_utils.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/utils/shared_pref_utils.dart';
import 'package:moolwms/widgets/my_toast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

enum VerificationStatus { verified, invalid, notEntered }

enum FlowType { login, verify }

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage(
      {Key? key, this.mobileNo, this.otpType, this.flowType = FlowType.login})
      : super(key: key);
  static const String routeName = "/verifyOtp";
  final String? mobileNo;
  final int? otpType;
  final FlowType flowType;

  @override
  VerificationCodePageState createState() => VerificationCodePageState();
}

class VerificationCodePageState extends State<VerificationCodePage> {
  bool isError = false, isOTPEntered = false;
  VerificationStatus verificationStatus = VerificationStatus.notEntered;
  late String smsId, otp;
  late TextEditingController _otpEditingController;
  int secondsRemaining = 30, otpLength = 6;

  //todo: CountDown
  // CountDown cd;
  late StreamSubscription<Duration> sub;
  late String smsCode;

  @override
  void initState() {
    super.initState();
    _otpEditingController = TextEditingController();
    startListeningForSms();
    //todo: CountDown
    // startCountdown();
    logPrint.w("${widget.mobileNo}");
  }

  void startCountdown() {
    // cd = CountDown(const Duration(seconds: 30), refresh: const Duration(seconds: 1));
    // sub = cd.stream.listen(null);
    // sub.onData((Duration d) {
    //   setState(() {
    //     secondsRemaining = d.inSeconds;
    //   });
    // });

    sub.onDone(() {
      setState(() {
        secondsRemaining = 0;
      });
    });
  }

  @override
  void dispose() {
    //todo: SmsRetriever
    // try {
    //   if (sub != null) {
    //     sub.cancel();
    //   }
    //   SmsRetriever.stopListening();
    // } catch (ex) {
    //   logPrint.w(ex);
    // }
    _otpEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logPrint.w('build');
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            // ("verification")
            ("Verification")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        shrinkWrap: true,
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/images/verification.svg",
              width: width / 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
              // ('please_enter_verification_code_sent_to')
              ('Please Enter the verification code sent to')
                  .replaceAll('#PhoneNo#', "+${widget.mobileNo}"),
              textAlign: TextAlign.center,
              style: textTheme.bodyText1!.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Center(
            child: PinCodeTextField(
              autofocus: true,
              controller: _otpEditingController,
              hideCharacter: false,
              maxLength: otpLength,
              hasError: isError,
              errorBorderColor: Colors.red,
              pinBoxWidth: (width * 0.5) / otpLength,
              pinBoxOuterPadding: const EdgeInsets.all(8),
              onTextChanged: (text) {
                if (text.length < otpLength) {
                  setState(() {
                    isOTPEntered = false;
                  });
                }
              },
              onDone: (text) {
                setState(() {
                  isOTPEntered = true;
                });
              },
              wrapAlignment: WrapAlignment.center,
              defaultBorderColor: Colors.grey,
              hasTextBorderColor: Colors.grey[600]!,
              pinBoxBorderWidth: 1.4,
              pinBoxDecoration:
                  ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
              pinTextStyle: textTheme.headline5!.copyWith(
                  color: ColorConstants.primary, fontWeight: FontWeight.w400),
              pinTextAnimatedSwitcherTransition:
                  ProvidedPinBoxTextAnimation.scalingTransition,
              pinTextAnimatedSwitcherDuration:
                  const Duration(milliseconds: 1),
            ),
          ),
          const SizedBox(height: 52),
          Visibility(
            visible: verificationStatus != VerificationStatus.verified,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        child: Container(
                          // width: double.infinity,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorConstants.buttonLight,
                                  ColorConstants.buttonDark
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          child:  Text(
                              // ("verify")
                              ("Verify"),
                          style: textTheme.button!.copyWith(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          if (_otpEditingController.text.length == otpLength) {
                            verify(_otpEditingController.text);
                          } else {
                            setState(() {
                              verificationStatus = VerificationStatus.invalid;
                            });
                            MyToast.error(
                                // ("enter_verification_code")
                                ("Enter verification code"));
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 20),
                Visibility(
                  // visible: !(widget.isOtpSent && widget.isPerson),
                  visible: false,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                          // ("didnt_receive_otp"),
                          ("Didn't receive otp"),
                          style: textTheme.bodyText1!.copyWith(
                              color: Colors.black
                                  .withOpacity(secondsRemaining > 0 ? 0.4 : 1),
                              fontWeight: FontWeight.w700)),
                      InkWell(
                          onTap: secondsRemaining > 0
                              ? null
                              : () {
                                  _otpEditingController.text = "";
                                  get();
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                // ("resend"),
                                ("Resend"),
                                style: textTheme.bodyText1!.copyWith(
                                    color: ColorConstants.primary.withOpacity(
                                        secondsRemaining > 0 ? 0.4 : 1),
                                    fontWeight: FontWeight.w700)),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Visibility(
                    visible:
                        //todo: timer on otp page
                    // secondsRemaining > 0,
                    -1 > 0,
                    child: Text("$secondsRemaining ${('sec')}",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyText2!
                            .copyWith(color: ColorConstants.primary))),
              ],
            ),
          ),
          Visibility(
            visible: verificationStatus == VerificationStatus.verified,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: ColorConstants.green,
                    radius: 14,
                    child: Icon(Icons.done, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                      // ("verified"),
                      ("Verified"),
                      style: textTheme.subtitle1!.copyWith(
                          color: ColorConstants.green,
                          fontWeight: FontWeight.w800))
                ],
              ),
            ),
          ),
          Visibility(
            visible: verificationStatus == VerificationStatus.invalid,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: ColorConstants.red,
                    radius: 12,
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                      // ("invalid_otp"),
                      ("Invalid Otp"),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.red[600], fontWeight: FontWeight.w800))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> get() async {
    verificationStatus = VerificationStatus.invalid;
    startCountdown();

    if ('widget.isPerson' == '') {
      // var resp = await DioClient.getClient().post("Persons/sendPersonOTP", data: {
      //   "mobileNumber": mobileNo,
      //   "locationId": globals.location.id,
      //   "signature": appSignature
      // });
      //
      // if (resp.statusCode == 200) {
      //   return resp.data['success'] as bool;
      // }

    } else if ('widget.otpType' == '5') {
      // String appSignature = await SmsRetriever.getAppSignature();
      // var resp =
      // await DioClient.getClient().post("Docks/sendSecurityGuardOTP", data: {
      //   "dockId": dockId,
      //   "locationId": SharedPrefs.getPref(PrefConstants.LOCATION_ID),
      //   "signature": appSignature,
      // });
      //
      // if (resp.statusCode == 200) {
      //   return resp.data['success'] as bool;
      // }
    } else if ('widget.otpType' == '6') {
      // String appSignature = await SmsRetriever.getAppSignature();
      // var resp = await DioClient.getClient().post("Docks/sendDriverOTP", data: {
      //   "dockId": dockId,
      //   "locationId": SharedPrefs.getPref(PrefConstants.LOCATION_ID),
      //   "signature": appSignature,
      //   "mobileNumber": mobileNumber
      // });
      //
      // if (resp.statusCode == 200) {
      //   return resp.data['success'] as bool;
      // }
    } else if ('widget.otpType' == '8') {
      // var resp =
      // await DioClient.getClient().post("Persons/sendProfileUpdateOTP", data: {
      //   "mobileNumber": mobileNo,
      //   "locationId": globals.location.id,
      // });
      //
      // if (resp.statusCode == 200) {
      //   return resp.data['success'] as bool;
      // }
    } else {
      // String appSignature = await SmsRetriever.getAppSignature();
      // if (appSignature.isEmpty) {
      //   appSignature = getRandomString(11);
      // }
      // var resp = await DioClient.getClient().post("AppUsers/generateOTP",
      //     data: {"mobileNumber": mobileNo, "signature": appSignature});
      //
      // if (resp.statusCode == 200) {
      //   return resp.data['success'] as bool;
      // }

      ///
      // var resp = await DioClient.getClient().post("AppUsers/verifyOTP",
      //     data: {"mobileNumber": mobileNo, "otp": otp});
      // if (resp.statusCode == 200) {
      //   return resp.data['token'] as String;
      // }
    }
  }

  ///todo: implement sms retriever
  void startListeningForSms() {
    // logPrint.w("Started Listening for SMS");
    // SmsRetriever.startListening().then((sms) {
    //   try {
    //     logPrint.w(sms);
    //     smsCode = sms;
    //     smsCode = RegExp('(?<!\\d)\\d{6}(?!\\d)').firstMatch(sms)!.group(0)!;
    //     _otpEditingController.text = smsCode;
    //     verify(smsCode);
    //   } catch (e) {
    //     logPrint.w(e);
    //   }
    // }).whenComplete(() {
    //   SmsRetriever.stopListening();
    // });
  }

  void verify(String otp) async {
    // sub.cancel();
    secondsRemaining = 0;

    String? token;
    // String? resp;

    if ('widget.isPerson' == "") {
      /// widget.otpType == 3  ? widget.mobileNo.fullNumber : widget.specialPersonMobileNo.fullNumber,
      // var resp =
      // await DioClient.getClient().post("Persons/verifyPersonOTP", data: {
      //   "mobileNumber": mobileNo,
      //   "locationId": SharedPrefs.getPref(PrefConstants.LOCATION_ID),
      //   "otp": otp,
      //   "otpType": otpType ?? 3,
      // });
      // if (resp.statusCode == 200) {
      //   if (resp.data['token'] != null) {
      //     return resp.data['token'];
      //   } else if (resp.data['success'] != null) {
      //     return resp.data['success'].toString();
      //   } else {
      //     throw resp.data;
      //   }
      // }
    } else if ('widget.otpType' == '5') {
      // var resp =
      // await DioClient.getClient().post("Docks/verifySecurityGuardOTP", data: {
      //   "dockId": dockId,
      //   "otp": otp,
      //   "locationId": SharedPrefs.getPref(PrefConstants.LOCATION_ID)
      // });
      // if (resp.statusCode == 200) {
      //   if (resp.data['token'] != null) {
      //     return resp.data['token'];
      //   } else if (resp.data['success'] != null) {
      //     return resp.data['success'].toString();
      //   } else {
      //     throw resp.data;
      //   }
      // }
    } else if ('widget.otpType' == '6') {
      // var resp = await DioClient.getClient().post("Docks/verifyDriverOTP", data: {
      //   "dockId": dockId,
      //   "otp": otp,
      //   "locationId": SharedPrefs.getPref(PrefConstants.LOCATION_ID)
      // });
      // if (resp.statusCode == 200) {
      //   if (resp.data['token'] != null) {
      //     return resp.data['token'];
      //   } else if (resp.data['success'] != null) {
      //     return resp.data['success'].toString();
      //   } else {
      //     throw resp.data;
      //   }
      // }
    } else if ('widget.otpType' == '8') {
      // var resp =
      // await DioClient.getClient().post("Persons/verifyPersonOTP", data: {
      //   "mobileNumber": mobileNo,
      //   "locationId": SharedPrefs.getPref(PrefConstants.LOCATION_ID),
      //   "otp": otp,
      //   "otpType": otpType ?? 3,
      // });
      // if (resp.statusCode == 200) {
      //   if (resp.data['token'] != null) {
      //     return resp.data['token'];
      //   } else if (resp.data['success'] != null) {
      //     return resp.data['success'].toString();
      //   } else {
      //     throw resp.data;
      //   }
      // }
    } else {
      logPrint.w("${widget.mobileNo}, $otp");
      ///todo: country code
      String token = await PrefData.getPref(PrefData.token);
      await ApiUtils.httpPost("${APIConstants.baseUrl}otp/verifyOtp",
          {"mobile": "${widget.mobileNo}", "otp": otp}, token).then((res) {
            var resp = res ;
        logPrint.w(resp);
        if(resp['meta']['code'] == 200){
          // dynamic temp = jsonDecode(resp['data']);
          PrefData.setJwtData(resp['token']);
          setState(() {
            verificationStatus = VerificationStatus.verified;
          });
          Future.delayed(const Duration(milliseconds:500), (){
            Navigator.of(context).pushNamed(MyHomePage.routeName);
          });
        }
        else{
          setState(() {
            verificationStatus = VerificationStatus.invalid;
          });
          logPrint.wtf(resp);
        }
      });



    }
    // if (resp != null && resp == 'true') {
    //   token = await PrefData.getPref(PrefData.JWT_TOKEN);
    // }
    setState(() {
      if (token != null) {
        Map<String, String> userMap = {};
        userMap["mobileNumber"] = widget.mobileNo!;
        switch (widget.otpType) {
          case 3:
            userMap["otpType"] = "PersonIn";
            break;
          case 5:
            userMap["otpType"] = "SecurityGuard";
            break;
          case 6:
            userMap["otpType"] = "Driver";
            break;

          case 8:
            userMap["otpType"] = "ProfileChange";
            break;
        }
        verificationStatus = VerificationStatus.verified;
        if ('widget.flowType' == '0') {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            // globals.authStore?.redirectToAdmin(context, token);
          });
        }
        verificationStatus = VerificationStatus.verified;

        // Future.delayed(Duration(seconds: 1), () {
        //   Navigator.of(context).pop(true);
        // });
      } else {
        _otpEditingController.clear();
        verificationStatus = VerificationStatus.invalid;
      }
    });
  }
}
