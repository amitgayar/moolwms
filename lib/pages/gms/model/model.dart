import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';

class GateStore {
  get vehicleProductList => null;

  getVehicleProductList({required int limit, int? transactionType}) {}

  getVehicleList({required int limit, int? customerId,  offset}) {}

  getPersonList({required int limit,  int? customerId,  int? personType,  int? offset}) {}

  getLastPersonInTransaction(id) {}

  void generateReport( String s) {}

  getPersonListByDateRange(id, DateTime dateTime, DateTime dateTime2) {}
}

class MobileNoModel {
  var countryCode;

  var fullNumber;

  String? number;

  static fromString(value) {}
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

  int? empId;

  var employee;

  var fathersName;

  var gender;

  var address;

  var govtIdType;

  var govtIdNumber;

  var reportingManager;

  var image;

  var internCode;

  var labour;

  var truckDriver;

  var dob;

  var hasVehicle;

  var imageFile;

  get id => null;

  static fromJson(json) {}

   getPersonListItemWidget() {}
}
class StateModel {
  var id;

  var name;
}
class AadhaarDataModel {
  var name;

  var gender;

  var dob;

  var address;

  var city;

  String? pincode;
}
class AddressModel {
}
class CustomContact {
  final Contact? contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}
class EmployeeModel {
  String? personType;

  var mobileNo;

  var personalDetail;
}
class PersonSpecialEntryModel {
  MobileNoModel? mobileNo;

  AppUserDetailsModel? whomToMeet;

  var purpose;

  var fullName;

  var remarks;
}

class Contact {
  List? phones = [];
  List? emails = [];

  Contact({
    this.displayName,
    this.givenName,
    this.middleName,
    this.prefix,
    this.suffix,
    this.familyName,
    this.company,
    this.jobTitle,
    this.birthday,
    this.androidAccountName,
  });

  String? identifier,
      displayName,
      givenName,
      middleName,
      prefix,
      suffix,
      familyName,
      company,
      jobTitle;
  String? androidAccountTypeRaw, androidAccountName;
  DateTime? birthday;

  String initials() {
    return ((this.givenName?.isNotEmpty == true ? this.givenName![0] : "") +
        (this.familyName?.isNotEmpty == true ? this.familyName![0] : ""))
        .toUpperCase();
  }

  Contact.fromMap(Map m) {
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    androidAccountTypeRaw = m["androidAccountType"];
    androidAccountName = m["androidAccountName"];
    try {
      birthday = m["birthday"] != null ? DateTime.parse(m["birthday"]) : null;
    } catch (e) {
      birthday = null;
    }
  }

  static Map _toMap(Contact contact) {
    var emails = [];
    var phones = [];
    var postalAddresses = [];

    final birthday = contact.birthday == null
        ? null
        : "${contact.birthday!.year.toString()}-${contact.birthday!.month.toString().padLeft(2, '0')}-${contact.birthday!.day.toString().padLeft(2, '0')}";

    return {
      "identifier": contact.identifier,
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company": contact.company,
      "jobTitle": contact.jobTitle,
      "androidAccountType": contact.androidAccountTypeRaw,
      "androidAccountName": contact.androidAccountName,
      "emails": emails,
      "phones": phones,
      "postalAddresses": postalAddresses,
      "birthday": birthday
    };
  }

  Map toMap() {
    return Contact._toMap(this);
  }
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

  personIn(PersonModel? personDetail) {}

  personOut(PersonModel person) {}

  getPersonList({required String personSearch,  int? limit,  int? offset}) {}

  addEmployee( employeeModel) {}

  void suspendPerson(int? empId) {}

  specialEntry(PersonSpecialEntryModel personSpecialEntryModel) {}
}
class AuthStore {
  getAppUserByMobileNumber(mobileNo) {}

  createAppUserWithoutMapping( mobileNo, fullName, email, none) {}
}
class AppUserDetailsModel {
  var id;

  var name;

  var mobileNo;
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


