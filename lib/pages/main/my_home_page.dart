import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moolwms/pages/main/cubit/my_app_cubit/my_app_cubit.dart';
import 'package:moolwms/pages/common/drawer/drawer_common.dart';
import 'package:moolwms/widgets/circular_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static String routeName = "/homePage";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }
  bool temp = true;

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return BlocConsumer<MyAppCubit, MyAppState>(
        listenWhen: (previous, current) {
      return
        current.isLoading != previous.isLoading
      || current.connectionStatus == current.connectionStatus;
    }, listener: (context, state) {
      if (state.isLoading) {
        MyLoader.dialog(context);
      } else {
        // Navigator.pop(context);
      }
      if(temp){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are Offline", textAlign: TextAlign.center,), backgroundColor: Colors.redAccent,));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are Online", textAlign: TextAlign.center), backgroundColor: Colors.lightGreen,));
      }
    },
        // buildWhen: (previous, current) {
        //   // return true/false to determine whether or not
        //   // to rebuild the widget with state
        // },
        builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: () {  },),
          drawer: const CommonDrawer(),
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // Text('Loading = ${state.isLoading}'),
                // Text('test...${state.test}'),
                // TextButton(
                //   onPressed: () async{
                //     if(temp) {
                //       context.read<MyAppCubit>().checkConnectivity(ConnectivityResult.none);
                //       temp = false;
                //     }
                //     else{
                //       context.read<MyAppCubit>().checkConnectivity(ConnectivityResult.wifi);
                //       temp = true;
                //     }
                //
                //     // logPrint.w(await PrefData.getPref(PrefData.token));
                //   },
                //   child: const Text("Press"),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
