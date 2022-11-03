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

class MyToast{
  static  normal(String message, {Color? bgColor, Color? textColor}) {
    Fluttertoast.showToast(
        msg: message,
        //toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor??Colors.white,
        textColor: textColor??Colors.black,
        fontSize: 16.0);
  }

  static  error(String message, {Color? bgColor, Color? textColor}) {
    Fluttertoast.showToast(
        msg: message,
        //toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[100],
        textColor: Colors.red[900],
        fontSize: 16.0);
  }
  static  success(String message, {Color? bgColor, Color? textColor}) {
  Fluttertoast.showToast(
  msg: message,
  //toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.CENTER,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.green[900],
  textColor: Colors.green[100],
  fontSize: 16.0);
  }
}