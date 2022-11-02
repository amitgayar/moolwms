// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:moolwms/api/PersonAPIs.dart';
// import 'package:moolwms/model/AppUserDetailModel.dart';
// import 'package:moolwms/model/PersonDetailModel.dart';
// import 'package:moolwms/store/PersonStore.dart';
// import 'package:moolwms/constants/Globals.dart' as globals;
// import 'package:moolwms/utils/AppLocalizations.dart';
// import 'package:moolwms/widgets/bottom_button_container.dart';
// import 'package:moolwms/widgets/custom_form_fields.dart';
// import 'package:moolwms/widgets/dialog_views.dart';
// import 'package:moolwms/widgets/gradient_button.dart';
// import 'package:moolwms/widgets/ProgressContainerView.dart';
// import 'package:moolwms/widgets/VisibilityExtended.dart';
// import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
// import 'package:moolwms/widgets/EmptyView.dart';
//
// class ContractedEmployeeDetailsPage extends StatefulWidget {
//   PersonModel personModel;
//   PersonStore personStore;
//   ContractedEmployeeDetailsPage(dynamic args) {
//     if (args is Map) {
//       personModel = args['person'];
//       personStore = args['store'];
//     }
//   }
//   @override
//   _ContractedEmployeeDetailsPageState createState() =>
//       _ContractedEmployeeDetailsPageState();
// }
//
// class _ContractedEmployeeDetailsPageState
//     extends State<ContractedEmployeeDetailsPage> {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   PersonModel personModel;
//
//   @override
//   void initState() {
//     super.initState();
//     personModel = widget.personModel;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(AppLocalizations.of(context)
//               .translate("contracted_employee_details"))),
//       body: Observer(builder: (_) {
//         return ProgressContainerView(
//           isProgressRunning: widget.personStore?.showProgress ?? false,
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   DropdownSearch<AppUserDetailsModel>(
//                     emptyBuilder: (context) {
//                       return const EmptyView();
//                     },
//                     showSearchBox: true,
//                     showSelectedItem: true,
//                     compareFn: (op1, op2) => op1?.id == op2?.id,
//                     mode: Mode.BOTTOM_SHEET,
//                     popupTitle: Container(
//                         margin: const EdgeInsets.only(top: 18),
//                         padding: const EdgeInsets.only(top: 12, left: 12),
//                         child: Text(AppLocalizations.of(context)
//                             .translate("reporting_manager"))),
//                     dropdownSearchDecoration:
//                         DecorationUtils.getDropDownFieldDecoration(context,
//                             labelText: AppLocalizations.of(context)
//                                 .translate("reporting_manager")),
//                     onChanged: (val) => personModel.reportingManager = val,
//                     selectedItem: personModel.reportingManager,
//                     onFind: (val) async {
//                       return globals.authStore.appUser.mappings
//                           .map((e) => e.appUser)
//                           .toSet()
//                           .toList();
//                     },
//                     itemAsString: (op) => op.name,
//                     autoFocusSearchBox: true,
//                     validator: (val) {
//                       if (val == null) {
//                         return AppLocalizations.of(context)
//                             .translate("select_reporting_manager");
//                       }
//                       return null;
//                     },
//                     onSaved: (val) => personModel.reportingManager = val,
//                   ),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//       bottomNavigationBar: Observer(builder: (_) {
//         return VisibilityExtended(
//           visible: !(widget.personStore?.showProgress ?? false),
//           child: BottomButtonsContainer(
//             children: [
//               FlatButton(
//                 child: Text(AppLocalizations.of(context).translate('cancel')),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               const SizedBox(width: 8),
//               GradientButton(
//                 onPressed: () async {
//                   if (_formKey.currentState.validate()) {
//                     _formKey.currentState.save();
//                     // TODO: DO ACTION
//                     if (personModel != null) {
//                       var inResp = await widget.personStore
//                           .personIn(context, personModel);
//                       if (inResp != null) {
//                         DialogViews.showSuccessBottomSheet(
//                           context,
//                           detailText: AppLocalizations.of(context)
//                               .translate("person_in_successful"),
//                           successText: (personModel?.hasVehicle ?? false)
//                               ? AppLocalizations.of(context)
//                                   .translate("vehicle_in")
//                               : null,
//                           onSuccess: (personModel?.hasVehicle ?? false)
//                               ? () {
//                                   Navigator.of(context).pushNamed(
//                                       "/admin/gms/vehicle/in",
//                                       arguments: {
//                                         "mobileNo": personModel.mobileNo,
//                                       });
//                                 }
//                               : null,
//                         );
//                       }
//                     }
//                   }
//                 },
//                 child: Text(AppLocalizations.of(context).translate("submit")),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
