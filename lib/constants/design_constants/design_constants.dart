import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';

ButtonStyle myElevatedButtonStyle = ElevatedButton.styleFrom(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    minimumSize: const Size(double.infinity - 48, 56),
    maximumSize: const Size(double.infinity - 48, 56),
    backgroundColor: ColorConstants.actionButton
);
