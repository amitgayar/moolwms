import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';

class VehicleModel {
  var vehicleNumber;

  var personId;

  bool? borrowsVehicle;

  var insuranceExpiry;

  var containsMaterial;

  var ownerName;

  OptionModel? vehicleType;

  var vehicleRcImage;

  File? rcImage;

  var insuranceImage;

  var vehicleInsuranceImage;

  var vehicleRc;

  OptionModel? vehicleInsurance;

  OptionModel? ownerType;

  static fromJson(json) {}
}

class PersonModel {
  var mobileNo;

  var fullName;

  get id => null;

  static fromJson(json) {}
}

class VehicleStore {
  getVehicle(String? vehicleNo) {}

  isVehicleInside(String? vehicleNo) {}

  vehicleOut(VehicleModel vehicle) {}

  sendBorrowVehicleOTP(String mobileNo, String vehicleNo) {}

  vehicleIn(BuildContext context, VehicleModel vehicleModel) {}
}

class PersonStore {
  var personList = [];

  getPerson(String? mobileNo) {}

  isPersonInside(String? mobileNo) {}
}


class OptionAPIs {
  static getOptionByValue(String s, json) {}

  static getOptions(String s) {}
}

class MaterialModel {
  static fromJson(json) {}
}

class OptionModel {
  String? label;

  int? id;

  get value => null;
}

class MobileNoModel {
}
