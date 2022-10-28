
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/common/login/otp_page.dart';
import 'package:moolwms/utils/api_utils.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/utils/shared_pref_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool passObscure = true;
  String mobileNo = "";
  String password="123456";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? token;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var width = size.width;
    // var height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/moolcode_logo.png",
          height: kToolbarHeight * 0.9,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: PopupMenuButton(
              child: const Icon(Icons.more_vert),
              onSelected: (val) async {
                if (val == "CHANGE_LANGUAGE") {
                  ///todo: changeLanguage push
                  // Navigator.of(context).pushNamed('/changeLanguage');
                } else if (val == "CHAT_SUPPORT") {
                  ///todo: FlutterFreshChat push

                  // await FlutterFreshChat.showConversations(
                  //     title: 'MoolWMS Chat Support');
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: "CHANGE_LANGUAGE",
                    child: Row(children: <Widget>[
                      Icon(Icons.translate, size: 20, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      const Text(
                          ("Change Language"))
                    ]),
                  ),
                  PopupMenuItem(
                    value: "CHAT_SUPPORT",
                    child: Row(children: <Widget>[
                      Icon(Icons.live_help, size: 20, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      const Text(
                          ("Chat Support"))
                    ]),
                  )
                ];
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/images/verification.svg",
                  width: width / 2,
                ),
              ),
              const SizedBox(height: 18),
              Text(("Login"),
                  textAlign: TextAlign.center,
                  style: textTheme.headline5),
              const SizedBox(height: 4),
              Text(
                  (
                      "Enter details to login to your account"),
                  textAlign: TextAlign.center,
                  style: textTheme
                      .bodyText2
                  !.copyWith(color: ColorConstants.registerDark)),
              const SizedBox(height: 32),
              Text(("Mobile Number"),
                  style: textTheme
                      .subtitle1
                  !.copyWith(fontWeight: FontWeight.w700)),
              TextFormField(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (val!.isEmpty) {
                    return
                      ("Enter Mobile Number");
                  } else if (val.length < 6) {
                    return
                      ("Enter valid Mobile Number");
                  }
                  return null;
                },
                onSaved: (val) {
                  mobileNo = val!;
                },
                maxLength: 10,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: DecorationUtils.getTextFieldDecoration(
                  prefixText: "+91   ",
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),

                  ///todo:CountryPicker
                  // prefixIcon: CountryPicker(
                  //     showDialingCode: true,
                  //     showName: false,
                  //     dense: true,
                  //     selectedCountry: mobileNo.countryCode,
                  //     onChanged: (country) {
                  //       setState(() {
                  //         mobileNo.countryCode = country;
                  //       });
                  //     }),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      String appSignature = "";
                      FocusManager.instance.primaryFocus!.unfocus();
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // String token = await globals.authStore
                        //     ?.loginWithPassword(
                        //     context, mobileNo.fullNumber, password,
                        //     isRedirectToAdmin: false);
                        if (token == null) {

                          ///todo: _firebaseProvider.analytics.logEvent(name: "SignInSuccess
                          // _firebaseProvider.analytics
                          //     .logEvent(name: "SignInSuccess");
                          ///todo: verifyOtp push, arguments navigator
                          // Navigator.of(context).pushNamed(VerificationCodePage.routeName,
                          //     arguments: {
                          //       "mobileNo": mobileNo,
                          //       "flowType": 1
                          //     });
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  VerificationCodePage(mobileNo: mobileNo,)));
                          // String appSignature = await SmsRetriever.getAppSignature();
                          if (appSignature.isEmpty) {
                             appSignature = TempFunc.getRandomString(11);
                          }
                          ///todo: countryCode compulsory
                          var resp = await ApiUtils.httpPost(
                              "${APIConstants.baseUrl}loginWithOtp",
                              // "${APIConstants.baseUrl}AppUsers/generateOTP",
                              {"mobile": "+91$mobileNo"}, '');
                          logPrint.w(resp);
                          if(resp["meta"]["code"] == 200 ){
                            await PrefData.setJwtData(resp["token"]);
                          }

                        }
                      }


                      // appUser = await AuthAPIs.getUserDetails();
                      // GlobalData().locationId = SharedPrefs.getPref(PrefConstants.LOCATION_ID);
                      // var resp = await DioClient.getClient().get("AppUsers/fetchUserDetails");
                      // AppUserDetailsModel appUser = AppUserDetailsModel.fromJson(resp.data);
                      // AppUserDetailsModel user = appUser;
                      // getUserRoleLocationMapping
                      //       Map<String, dynamic> data = {'userId': userId};
                      //       var resp = await DioClient.getClient()
                      //           .post("/AppUsers/getAllLocations", data: data);
                            if ('resp.statusCode' == '200') {
                            try {
                            // List data = resp.data;
                            // List<AppUserRoleLocationMappingModel> appUserRoleLocationMappings = <AppUserRoleLocationMappingModel>[];
                            // for (int i = 0; i < data.length; i++) {
                            // var item = await AppUserRoleLocationMappingModel.fromJson(data[i]);
                            // appUserRoleLocationMappings.add(item);
                            // }
                            // if (SharedPrefs.getPref(PrefConstants.LOCATION_ID) != null) {
                            // GlobalData().selectedLocId =
                            // SharedPrefs.getPref(PrefConstants.LOCATION_ID);
                            // }
                            // if (GlobalData().user.id == userId) {
                            // GlobalData().setRoleEngineMapping(appUserRoleLocationMappings);
                            // }
                            // return appUserRoleLocationMappings;



                      // List<AppUserRoleLocationMappingModel> mappings = await AuthAPIs.getUserRoleLocationMapping(appUser.id);
                      // List locationList = await userStore.getLocation(context);
                      //
                      // if (appUser != null && locationList != null && locationList.isNotEmpty && mappings != null && mappings.isNotEmpty) {
                      //   Navigator.of(context).pushNamedAndRemoveUntil(appUser.routeToDashboard, (_) => false);
                      // } else if (mappings.any((element) => element.role == UserRole.Admin)) {
                      //   Navigator.of(context).pushReplacementNamed("/warehouse/list", arguments: {"isFromRegister": true});
                      // }
                            }
                            catch(e){
                              logPrint.e(e);
                            }
                            }
                    },

                    child: Container(
                      // width: width-48 ,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                            // enabled ?
                            [ColorConstants.buttonLight, ColorConstants.buttonDark]
                                // : [Colors.grey, Colors.grey],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical:  16),
                      child: Text(
                          ("Login"),style: textTheme.button!.copyWith(color:Colors.white),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(AppConstants.tncLink))) {
                  await launchUrl(Uri.parse(AppConstants.tncLink), mode: LaunchMode.inAppWebView);
                }
              },
              child: Text(
                ("Terms and Conditions"),
                style: textTheme.bodyText2!.copyWith(
                  color: ColorConstants.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "|",
              style: textTheme.bodyText2!.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(AppConstants.policyLink))) {
                  await launchUrl(Uri.parse(AppConstants.policyLink),  mode: LaunchMode.inAppWebView);
                }
              },
              child: Text(
                ("Privacy Policy"),
                style: textTheme.bodyText2!.copyWith(
                  color: ColorConstants.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
