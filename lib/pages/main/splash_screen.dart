import 'package:flutter/material.dart';
import 'package:moolwms/pages/common/login/login_with_otp.dart';
import 'package:moolwms/pages/main/my_home_page.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/utils/shared_pref_utils.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);
  static String routeName = "/splashScreen";

  @override
  State<MySplashScreen> createState() => MySplashScreenState();
}

class MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    routeMyApp();
  }

  @override
  void didUpdateWidget(MySplashScreen oldWidget) async {
    // routeMyApp();
    super.didUpdateWidget(oldWidget);
  }

  routeMyApp() async {
    var token = await PrefData.getPref(PrefData.token, defaultValue: '');
    logPrint.w("token: $token");
    //todo: check logic of routing
    WidgetsBinding.instance.addPostFrameCallback((_){
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (token.isEmpty) {
         // PrefData.setPref(PrefData.token,PrefData.dummyToken);
         // Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
         Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
      }
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Image.asset(
              "assets/images/moolcode_logo.png",
              height: kToolbarHeight * 0.9,
            )),
      ),
    );
  }
}
