import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/design_constants/color_constants.dart';

lightCustomBar(){
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark));
}

darkBlueCustomBar(){
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstants.actionButton,
      statusBarIconBrightness: Brightness.light));
}

