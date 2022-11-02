class VehicleModel {
  var vehicleNumber;

  static fromJson(json) {}
}

class PersonModel {
  var mobileNo;

  var fullName;

  static fromJson(json) {}
}

class VehicleStore {
  getVehicle(String? vehicleNo) {}

  isVehicleInside(String? vehicleNo) {}

  vehicleOut(VehicleModel vehicle) {}
}

class PersonStore {
  var personList = [];

  getPerson(String mobileNo) {}

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
