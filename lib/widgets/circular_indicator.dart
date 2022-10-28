import 'package:flutter/material.dart';

class CircularProgressIndicatorApp extends StatelessWidget {
  const CircularProgressIndicatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          constraints:  const BoxConstraints(
            maxHeight: 60.0,
            maxWidth: 60.0,
          ),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,

          ),
          child: const SizedBox.expand(
              child: Center(child: CircularProgressIndicator.adaptive()))),
    );
  }
}

class MyLoader{
  static dialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CircularProgressIndicatorApp(),
        );
      },
    );
  }

}

