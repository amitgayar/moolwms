import 'package:flutter/src/widgets/framework.dart';

class VehicleModel {
  var vehicleNumber;

  var personId;

  bool? borrowsVehicle;

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
}

class PersonStore {
  var personList = [];

  getPerson(String? mobileNo) {}

  isPersonInside(String? mobileNo) {}
}


class OptionAPIs {
  static getOptionByValue(String s, json) {}
}

class MaterialModel {
  static fromJson(json) {}
}

class OptionModel {
  get value => null;
}
