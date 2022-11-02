// import 'package:flutter/material.dart';
// import 'package:moolwms/utils/AppLocalizations.dart';
// import 'package:moolwms/widgets/gradient_button.dart';
// import 'package:moolwms/api/LocationAPIs.dart';
// import 'package:moolwms/model/LocationDetailModel.dart';
// import 'package:moolwms/model/AppUserRoleLocationMappingModel.dart';
// import 'package:moolwms/utils/Utils.dart';
// import 'package:moolwms/store/AuthStore.dart';
// import 'package:moolwms/widgets/bottom_button_container.dart';
// import 'package:moolwms/widgets/custom_form_fields.dart';
// import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
// import 'package:moolwms/widgets/EmptyView.dart';
//
// class AssignRolePage extends StatefulWidget {
//   int userId;
//   AppUserRoleLocationMappingModel userRoleMappingModel;
//   AssignRolePage(dynamic args) {
//     if (args != null) {
//       userId = args["userId"];
//       userRoleMappingModel = args["appUserRoleLocationMappingModel"];
//     }
//   }
//
//   @override
//   _AssignRolePageState createState() => _AssignRolePageState();
// }
//
// class _AssignRolePageState extends State<AssignRolePage> {
//   LocationDetailModel selectedLocation;
//   UserRole selectedRole;
//   AuthStore authStore = AuthStore();
//
//   @override
//   void initState() {
//     if (widget.userRoleMappingModel != null) {
//       selectedLocation = widget.userRoleMappingModel.locationDetail;
//       selectedRole = widget.userRoleMappingModel.role;
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).translate("assign_role")),
//       ),
//       body: Container(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DropdownSearch<LocationDetailModel>(
//                 emptyBuilder: (context) {
//                   return const EmptyView();
//                 },
//                 showSearchBox: true,
//                 showSelectedItem: true,
//                 compareFn: (op1, op2) => op1?.id == op2?.id,
//                 mode: Mode.BOTTOM_SHEET,
//                 popupTitle: Container(
//                     margin: const EdgeInsets.only(top: 18),
//                     padding: const EdgeInsets.only(top: 12, left: 12),
//                     child: Text(AppLocalizations.of(context)
//                         .translate("select_warehouse"))),
//                 dropdownSearchDecoration:
//                     DecorationUtils.getDropDownFieldDecoration(context,
//                         labelText: AppLocalizations.of(context)
//                             .translate("select_warehouse")),
//                 onChanged: (val) {
//                   selectedLocation = val;
//                 },
//                 selectedItem: selectedLocation,
//                 autoFocusSearchBox: true,
//                 isFilteredOnline: false,
//                 itemAsString: (op) => op?.name ?? "",
//                 onFind: (val) async {
//                   return await LocationAPIs.getLocations();
//                 },
//                 validator: (val) {
//                   if (val == null) {
//                     return AppLocalizations.of(context)
//                         .translate("select_warehouse");
//                   }
//                   return null;
//                 },
//                 onSaved: (val) {},
//               ),
//               const SizedBox(height: 20),
//               DropdownSearch<UserRole>(
//                 emptyBuilder: (context) {
//                   return const EmptyView();
//                 },
//                 showSearchBox: true,
//                 showSelectedItem: true,
//                 compareFn: (op1, op2) => op1 == op2,
//                 mode: Mode.BOTTOM_SHEET,
//                 popupTitle: Container(
//                     margin: const EdgeInsets.only(top: 18),
//                     padding: const EdgeInsets.only(top: 12, left: 12),
//                     child: Text(
//                         AppLocalizations.of(context).translate("select_role"))),
//                 dropdownSearchDecoration:
//                     DecorationUtils.getDropDownFieldDecoration(context,
//                         labelText: AppLocalizations.of(context)
//                             .translate("select_role")),
//                 onChanged: (val) {
//                   selectedRole = val;
//                 },
//                 selectedItem: selectedRole,
//                 autoFocusSearchBox: true,
//                 isFilteredOnline: false,
//                 itemAsString: (op) =>
//                     TextUtils.enumToString(op).splitMapJoin(RegExp("[A-Z]"),
//                         onMatch: (val) {
//                       if (val.start == 0) {
//                         return TextUtils.enumToString(op)
//                             .substring(val.start, val.end);
//                       }
//                       return " " +
//                           TextUtils.enumToString(op)
//                               .substring(val.start, val.end);
//                     }) ??
//                     "",
//                 onFind: (val) async {
//                   return [
//                     UserRole.Admin,
//                     UserRole.PlantManager,
//                     UserRole.DockSupervisor,
//                     UserRole.SecurityGuard,
//                     UserRole.Sales,
//                     UserRole.Hr,
//                     UserRole.Customer,
//                     //todo change
//                     UserRole.ThreePLCustomer,
//                   ];
//                 },
//                 validator: (val) {
//                   if (val == null) {
//                     return AppLocalizations.of(context)
//                         .translate("select_warehouse");
//                   }
//                   return null;
//                 },
//                 onSaved: (val) {},
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomButtonsContainer(children: [
//         FlatButton(
//             child: Text(AppLocalizations.of(context).translate("back")),
//             onPressed: () {
//               Navigator.of(context).pop();
//             }),
//         GradientButton(
//           child: Text(AppLocalizations.of(context).translate("save_role")),
//           onPressed: () async {
//             if (widget.userRoleMappingModel != null) {
//               authStore
//                   .modifyUserRoleLocationMapping(
//                       context,
//                       AppUserRoleLocationMappingModel(
//                           id: widget.userRoleMappingModel?.id,
//                           userId: widget.userId,
//                           role: selectedRole,
//                           locationId: selectedLocation?.id))
//                   .then((value) {
//                 Navigator.of(context).pop(true);
//               });
//             } else {
//               authStore
//                   .addUserRoleLocationMapping(
//                       context,
//                       AppUserRoleLocationMappingModel(
//                           userId: widget.userId,
//                           role: selectedRole,
//                           locationId: selectedLocation?.id))
//                   .then((value) {
//                 Navigator.of(context).pop(true);
//               });
//             }
//           },
//         )
//       ]),
//     );
//   }
// }
