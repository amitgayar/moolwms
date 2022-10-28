import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/main/cubit/my_app_cubit/my_app_cubit.dart';
import 'package:moolwms/pages/common/login/login_with_otp.dart';
import 'package:moolwms/pages/common/login/otp_page.dart';
import 'package:moolwms/pages/indent/indent_list_page.dart';
import 'package:moolwms/pages/main/my_home_page.dart';
import 'package:moolwms/pages/main/splash_screen.dart';
import 'package:moolwms/utils/app_color_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    lightCustomBar();
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyAppCubit>(
          create: (BuildContext context) => MyAppCubit(MyAppState.initial()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoolWMS',
        theme: ThemeData(
          // useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.appBlue),
          // primarySwatch: Colors.blueGrey,
          fontFamily: 'Nunito',
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
            // brightness: Brightness.light,
            color: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(
              // color: Colors.grey[800],
            ),
            // foregroundColor: ColorConstants.primary,
            // textTheme: Theme.of(context).textTheme.copyWith(
            //       headline6: Theme.of(context).textTheme.headline6.copyWith(
            //           fontFamily: 'Nunito',
            //           fontWeight: FontWeight.w500,
            //           color: ColorConstants.PRIMARY),
            //     )
          ),
        ),
      routes: {
        '/': (context) => const MySplashScreen(),
        MySplashScreen.routeName : (context) => const MySplashScreen(),
        MyHomePage.routeName : (context) => const MyHomePage(),
        LoginPage.routeName : (context) => const LoginPage(),
        VerificationCodePage.routeName : (context) =>  const VerificationCodePage(),
        IndentListPage.routeName: (context) => const IndentListPage(),

      },
        // home: const MyHomePage(),
      ),
    );
  }
}


