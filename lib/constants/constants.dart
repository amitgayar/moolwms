class UserRole {
  static const String driver = 'driver';
  static const String admin = 'admin';
  static const String client = 'client';
  static const String supervisor = 'supervisor';
}

class AppConstants {
  static const double itemRadius = 16;
  static const double orderRadius = 8;
  static const String shareMessage =
      'Checkout the Coolbox app - https://play.google.com/store/apps/details?id=com.indicold.coolbox';
  static const String helpEmail = 'support@moolcode.com';
  static const String playStoreAddress =
      'https://play.google.com/store/apps/details?id=com.indicold.coolbox';

  static const String tncLink = "https://www.moolcode.com/terms-and-conditions/";
  static const String policyLink = "https://www.moolcode.com/privacy-policy/";
}

class APIConstants {
  static const String apiSource = "app";
  static const String apiVersion = "1";

  //static const String baseUrl = "https://staging.moolwms.com/api/";
  static const String baseUrl =
      "http://43.204.216.25/";
      // "https://baa6-117-214-223-129.in.ngrok.io/";
      // "https://app.moolwms.com/api/";
  static const String baseUrlIndent = "http://43.204.216.25/";
  static const int timeOut = 60;
  static const String timeOutMsg = "Response taking too much time. \nCheck your connection and try again";
  static const String VEHICLE_INSURANCE_IMAGE_CONTAINER = "";

  static var VEHICLE_RC_IMAGE_CONTAINER;

}
