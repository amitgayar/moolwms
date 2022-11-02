import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';

class GateStore {
  get vehicleProductList => null;

  getVehicleProductList({required int limit, int? transactionType}) {}

  getVehicleList({required int limit, int? customerId,  offset}) {}

  getPersonList({required int limit}) {}

  getLastPersonInTransaction(id) {}

  void generateReport( String s) {}
}

class MobileNoModel {
  var countryCode;

  var fullNumber;

  String? number;
}
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

  var personType;

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

  bool? showProgress;

  getPerson(mobileNo) {}

  isPersonInside( mobileNo) {}

  getPersonById( int? personId) {}

  personIn(BuildContext context, PersonModel personDetail) {}
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


