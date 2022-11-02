import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moolwms/pages/gms/vehicle/model.dart';
import 'package:moolwms/utils/shared_pref_utils.dart';

class GateTransactionModel {
  int? id;
  int? transactionType;
  bool? isPerson;
  bool? isVehicle;
  bool? isMaterial;
  bool? personHaveVehicle;
  bool? personHaveMaterial;
  bool? cameForMaterialOut;
  bool? borrowsVehicle;
  int? locationId;
  int? personId;
  int? vehicleId;
  int? materialId;
  OptionModel? personType;
  PersonModel? person;
  VehicleModel? vehicle;
  MaterialModel? material;
  String? visitorPurpose;

  bool? isActive;
  DateTime? createdDate;
  DateTime? lastModifiedDate;

  String get personTypeString {
    switch (personType?.value ?? 0) {
      case 1:
        return "E";
      case 2:
        return "L";
      case 3:
        return "TD";
      case 4:
        return "C";
      case 5:
        return "V";
      case 6:
        return "CE";
      case 7:
        return "S";
      case 8:
        return "I";
      default:
        return "X";
    }
  }

  static Future<GateTransactionModel> fromJson(
      Map<String, dynamic> json) async {
    GateTransactionModel gateTxn = GateTransactionModel();

    gateTxn.id = json['id'];
    gateTxn.transactionType = json['transactionType'];
    gateTxn.isPerson = json['isPerson'];
    gateTxn.isVehicle = json['isVehicle'];
    gateTxn.isMaterial = json['isMaterial'];
    gateTxn.personHaveVehicle = json['personHaveVehicle'] ?? false;
    gateTxn.personHaveMaterial = json['personHaveMaterial'] ?? false;
    gateTxn.cameForMaterialOut = json['cameForMaterialOut'] ?? false;
    gateTxn.borrowsVehicle = json['borrowsVehicle'] ?? false;
    gateTxn.locationId = json['locationId'];
    gateTxn.personId = json['personId'];
    gateTxn.vehicleId = json['vehicleId'];
    gateTxn.materialId = json['materialId'];
    gateTxn.isActive = json['isActive'];
    gateTxn.createdDate = DateTime.tryParse(json['createdDate'])?.toLocal();
    gateTxn.lastModifiedDate =
        DateTime.tryParse(json['lastModifiedDate'])?.toLocal();
    gateTxn.personType = json['personType'] != null && json['personType'] > 0
        ? await OptionAPIs.getOptionByValue("PERSONTYPE", json['personType'])
        : null;
    gateTxn.person = json['person'] != null
        ? await PersonModel.fromJson(json['person'])
        : null;
    gateTxn.vehicle = json['vehicle'] != null
        ? await VehicleModel.fromJson(json['vehicle'])
        : null;
    gateTxn.material = json['material'] != null
        ? await MaterialModel.fromJson(json['material'])
        : null;
    gateTxn.visitorPurpose = json["visitorPurpose"];
    return gateTxn;
  }

  Map toJson() {
    return {
      "transactionType": transactionType,
      "isPerson": isPerson ?? false,
      "isMaterial": isMaterial ?? false,
      "isVehicle": isVehicle ?? false,
      "personHaveVehicle": personHaveVehicle ?? false,
      "personHaveMaterial": personHaveMaterial ?? false,
      "cameForMaterialOut": cameForMaterialOut ?? false,
      "borrowsVehicle": borrowsVehicle ?? false,
      "id": id,
      "locationId": PrefData.getPref(PrefData.locationId),
      "materialId": materialId,
      "personId": personId,
      "vehicleId": vehicleId,
      "personType": personType?.value,
      "visitorPurpose": visitorPurpose,
      "fk_id_org": PrefData.getPref(PrefData.orgId),
    };
  }

  Widget getTransactionListItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // child: Row(
      //   children: [
      //     Expanded(
      //         child: Text(
      //             DateFormat("dd MMM yyyy hh:mm:ss aa").format(createdDate))),
      //     Card(
      //       elevation: 4,
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Container(
      //           child: Text(
      //             transactionType == 1
      //                 ? AppLocalizations.of(context).translate("in")
      //                 : AppLocalizations.of(context).translate("out"),
      //             style: Theme.of(context).textTheme.bodyText1.copyWith(
      //                 fontWeight: FontWeight.bold,
      //                 color: transactionType == 1 ? Colors.green : Colors.red),
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      decoration: BoxDecoration(
        color: transactionType == 1 ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget getPersonListItemWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/admin/gms/person/details",
            arguments: {"gateTxn": this, "person": person});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
          //       SizedBox(
          //         width: 50,
          //         child: Center(
          //           child: Text(
          //             transactionType == 1 ? "IN" : "OUT",
          //             style: Theme.of(context).textTheme.bodyText2.copyWith(
          //                 color:
          //                     transactionType == 1 ? Colors.green : Colors.red),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //           flex: 6,
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 person?.fullName ?? "",
          //               ),
          //               Text(person?.mobileNo?.number ?? "",
          //                   style: Theme.of(context).textTheme.caption)
          //             ],
          //           )),
          //       Expanded(
          //           flex: 2,
          //           child: Center(child: Text(personTypeString ?? "X"))),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Text(DateFormat("dd-MMM-yyyy").format(createdDate)),
          //           Text(DateFormat("hh:mm aa").format(createdDate),
          //               style: Theme.of(context).textTheme.caption.copyWith(
          //                   color: Colors.grey[700],
          //                   fontWeight: FontWeight.w700))
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget getVisitorListItemWidgetCustomer(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/admin/gms/person/details",
            arguments: {"gateTxn": this, "person": person});
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          // child: Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           person?.fullName ?? "",
          //           style: const TextStyle(
          //               color: ColorConstants.PRIMARY_LIGHT,
          //               fontWeight: FontWeight.w400),
          //         ),
          //         Text(
          //           transactionType == 1 ? "IN" : "OUT",
          //           style: Theme.of(context).textTheme.bodyText2.copyWith(
          //               color: transactionType == 1 ? Colors.green : Colors.red,
          //               fontSize: 14,
          //               fontWeight: FontWeight.w400),
          //         ),
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     Row(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "Mobile Number",
          //                 style: TextStyle(
          //                     fontSize: 12, fontWeight: FontWeight.w400),
          //               ),
          //               Text(person?.mobileNo?.number ?? "",
          //                   style: const TextStyle(fontSize: 12)),
          //             ],
          //           ),
          //         ),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: const [
          //               Text(
          //                 "Email",
          //                 style: TextStyle(
          //                     fontSize: 12, fontWeight: FontWeight.w400),
          //               ),
          //               Text("Test Email",
          //                   style: TextStyle(fontSize: 12)), //TODO:change this
          //             ],
          //           ),
          //         ),
          //         const Icon(
          //           Icons.arrow_forward_ios,
          //           size: 12,
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget getVehicleListItemWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/admin/gms/vehicle/details",
            arguments: {"gateTxn": this, "vehicle": vehicle});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
          //       Expanded(
          //         flex: 1,
          //         child: Center(
          //           child: Text(
          //             transactionType == 1 ? "IN" : "OUT",
          //             style: Theme.of(context).textTheme.bodyText2.copyWith(
          //                 color:
          //                     transactionType == 1 ? Colors.green : Colors.red),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //           flex: 2,
          //           child: Center(child: Text(vehicle?.vehicleNumber ?? ""))),
          //       Expanded(
          //           flex: 2,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(DateFormat("dd-MMM-yyyy").format(createdDate)),
          //               Text(DateFormat("hh:mm aa").format(createdDate),
          //                   style: Theme.of(context).textTheme.caption.copyWith(
          //                       color: Colors.grey[700],
          //                       fontWeight: FontWeight.w700))
          //             ],
          //           )),
          //     ],
          //   ),
          // ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget getVehicleListItemWidgetCustomer(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/admin/gms/person/details",
            arguments: {"gateTxn": this, "person": person});
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          // child: Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           vehicle?.vehicleNumber ?? "",
          //           style: const TextStyle(
          //               color: ColorConstants.PRIMARY_LIGHT,
          //               fontWeight: FontWeight.w400),
          //         ),
          //         Text(
          //           transactionType == 1 ? "IN" : "OUT",
          //           style: Theme.of(context).textTheme.bodyText2.copyWith(
          //               color: transactionType == 1 ? Colors.green : Colors.red,
          //               fontSize: 14,
          //               fontWeight: FontWeight.w400),
          //         ),
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     Row(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: const [
          //               Text(
          //                 "Mobile Number",
          //                 style: TextStyle(
          //                     fontSize: 12, fontWeight: FontWeight.w400),
          //               ),
          //               Text("Test mobile", //TODO:change here
          //                   style: TextStyle(fontSize: 12)),
          //             ],
          //           ),
          //         ),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "Date & Time",
          //                 style: TextStyle(
          //                     fontSize: 12, fontWeight: FontWeight.w400),
          //               ),
          //               Text(
          //                   DateFormat("dd/MMM/yyyy hh:mm AM")
          //                       .format(createdDate),
          //                   style: const TextStyle(fontSize: 12)), //TODO:change this
          //             ],
          //           ),
          //         ),
          //         const Icon(
          //           Icons.arrow_forward_ios,
          //           size: 12,
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget getMaterialListItemWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/admin/gms/material/details",
            arguments: {"gateTxn": this, "material": material});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
          //       Expanded(
          //           flex: 1,
          //           child: Center(
          //               child: Text(
          //             cameForMaterialOut == true ? "OUT" : "IN",
          //             style: Theme.of(context).textTheme.bodyText2.copyWith(
          //                 color: cameForMaterialOut == true
          //                     ? Colors.red
          //                     : Colors.green),
          //           ))),
          //       Expanded(
          //           flex: 2,
          //           child: Center(child: Text(vehicle?.vehicleNumber ?? ""))),
          //       Expanded(
          //           flex: 2,
          //           child: Center(child: Text(material?.customer?.name ?? ""))),
          //       Expanded(
          //           flex: 2,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(DateFormat("dd-MMM-yyyy").format(createdDate)),
          //               Text(DateFormat("hh:mm aa").format(createdDate),
          //                   style: Theme.of(context).textTheme.caption.copyWith(
          //                       color: Colors.grey[700],
          //                       fontWeight: FontWeight.w700))
          //             ],
          //           )),
          //     ],
          //   ),
          // ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget getMaterialListItemWidgetCustomer(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/admin/gms/person/details",
            arguments: {"gateTxn": this, "person": person});
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          // child: Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           vehicle?.vehicleNumber ?? "",
          //           style: const TextStyle(
          //               color: ColorConstants.PRIMARY_LIGHT,
          //               fontWeight: FontWeight.w400),
          //         ),
          //         Row(
          //           children: [
          //             const Icon(
          //               Icons.circle,
          //               size: 12,
          //               color: Colors.green,
          //             ),
          //             const SizedBox(
          //               width: 10,
          //             ),
          //             Text(
          //               "Navjyot Singh", //TODO:change this
          //               style: Theme.of(context).textTheme.bodyText2.copyWith(
          //                   color: transactionType == 1
          //                       ? Colors.green
          //                       : Colors.red,
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.w400),
          //             ),
          //             const SizedBox(
          //               width: 10,
          //             ),
          //             const Icon(Icons.keyboard_arrow_down)
          //           ],
          //         ),
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     Row(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "Customer",
          //                 style: TextStyle(
          //                     fontSize: 12, fontWeight: FontWeight.w400),
          //               ),
          //               Text(material?.customer?.name ?? "", //TODO:change here
          //                   style: const TextStyle(fontSize: 12)),
          //             ],
          //           ),
          //         ),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: const [
          //               Text(
          //                 "Dock",
          //                 style: TextStyle(
          //                     fontSize: 12, fontWeight: FontWeight.w400),
          //               ),
          //               Text("8", //TODO: change this
          //                   style: TextStyle(fontSize: 12)),
          //             ],
          //           ),
          //         ),
          //         const Icon(
          //           Icons.arrow_forward_ios,
          //           size: 12,
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}

class GateStore {
  get vehicleProductList => null;

  getVehicleProductList({required int limit, int? transactionType}) {}

  getVehicleList({required int limit, int? customerId,  offset}) {}

  getPersonList({required int limit}) {}

  getLastPersonInTransaction(id) {}

  void generateReport( String s) {}
}
