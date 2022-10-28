import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

myToast(String message, {Color? bgColor, Color? textColor}) {
  Fluttertoast.showToast(
      msg: message,
      //toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor??Colors.white,
      textColor: textColor??Colors.black,
      fontSize: 16.0);
}