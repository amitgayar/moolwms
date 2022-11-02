import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moolwms/api/CustomerAPIs.dart';
import 'package:moolwms/constants/Globals.dart' as globals;
import 'package:moolwms/model/AppUserDetailModel.dart';
import 'package:moolwms/model/MoolwmsOrgModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/widgets/EmptyView.dart';

class SupplierDetailsPage extends StatefulWidget {
  PersonModel personModel;
  PersonStore personStore;
  SupplierDetailsPage(dynamic args) {
    if (args is Map) {
      personModel = args['person'];
      personStore = args['store'];
    }
  }
  @override
  _SupplierDetailsPageState createState() => _SupplierDetailsPageState();
}

class _SupplierDetailsPageState extends State<SupplierDetailsPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonModel personModel;

  @override
  void initState() {
    super.initState();
    personModel = widget.personModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(AppLocalizations.of(context).translate("supplier_details"))),
      body: Observer(builder: (_) {
        return ProgressContainerView(
          isProgressRunning: widget.personStore?.showProgress ?? false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  DropdownSearch<MoolwmsOrgModel>(
                    emptyBuilder: (context) {
                      return const EmptyView();
                    },
                    showSearchBox: true,
                    showSelectedItem: true,
                    compareFn: (op1, op2) => op1?.id == op2?.id,
                    mode: Mode.BOTTOM_SHEET,
                    popupTitle: Container(
                        margin: const EdgeInsets.only(top: 18),
                        // ignore: prefer_const_constructors
                        padding: EdgeInsets.only(top: 12, left: 12),
                        child: Text(AppLocalizations.of(context)
                            .translate("firm_name"))),
                    dropdownSearchDecoration:
                        DecorationUtils.getDropDownFieldDecoration(context,
                            labelText: AppLocalizations.of(context)
                                .translate("firm_name")),
                    onChanged: (val) => personModel.customer = val,
                    selectedItem: personModel.customer,
                    autoFocusSearchBox: true,
                    onFind: (val) async {
                      return await CustomerAPIs.getCustomers();
                    },
                    itemAsString: (op) => op.name,
                    validator: (val) {
                      if (val == null) {
                        return AppLocalizations.of(context)
                            .translate("select_firm_name");
                      }
                      return null;
                    },
                    onSaved: (val) => personModel.customer = val,
                  ),
                  const SizedBox(height: 24),
                  DropdownSearch<AppUserDetailsModel>(
                    emptyBuilder: (context) {
                      return const EmptyView();
                    },
                    showSearchBox: true,
                    showSelectedItem: true,
                    compareFn: (op1, op2) => op1?.id == op2?.id,
                    mode: Mode.BOTTOM_SHEET,
                    popupTitle: Container(
                        margin: const EdgeInsets.only(top: 18),
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Text(AppLocalizations.of(context)
                            .translate("whom_to_meet"))),
                    dropdownSearchDecoration:
                        DecorationUtils.getDropDownFieldDecoration(context,
                            labelText: AppLocalizations.of(context)
                                .translate("whom_to_meet")),
                    onChanged: (val) => personModel.reportingManager = val,
                    selectedItem: personModel.reportingManager,
                    onFind: (val) async {
                      return globals.authStore.getAppUsersListByOrgId(context);
                    },
                    itemAsString: (op) => op.name,
                    autoFocusSearchBox: true,
                    validator: (val) {
                      if (val == null) {
                        return AppLocalizations.of(context)
                            .translate("select_whom_to_meet");
                      }
                      return null;
                    },
                    onSaved: (val) => personModel.reportingManager = val,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Observer(builder: (_) {
        return VisibilityExtended(
          visible: !(widget.personStore?.showProgress ?? false),
          child: BottomButtonsContainer(
            children: [
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('cancel')),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              GradientButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // TODO: DO ACTION
                    if (personModel != null) {
                      var person = await widget.personStore
                          .addOrModifyPerson(context, personModel);
                      bool tpOtp = await widget.personStore
                          .sendThirdPersonAuthOTP(context, personModel.fullName,
                              personModel.mobileNo,
                              reportingManager: personModel.reportingManager);
                      if (tpOtp != null && tpOtp) {
                        Navigator.of(context)
                            .pushNamed("/verifyotp", arguments: {
                          "personName": personModel.reportingManager.name,
                          "mobileNo": personModel.reportingManager.mobileNo,
                          "isPerson": true,
                          "isOtpSent": true,
                          "otpType": 2,
                          "specialPersonMobileNo": personModel.mobileNo,
                        }).then((value) async {
                          if (value is bool && value) {
                            var inResp = await widget.personStore
                                .personIn(context, personModel);
                            if (inResp != null) {
                              DialogViews.showSuccessBottomSheet(
                                context,
                                detailText: AppLocalizations.of(context)
                                    .translate("person_in_successful"),
                                successText: (personModel?.hasVehicle ?? false)
                                    ? AppLocalizations.of(context)
                                        .translate("vehicle_in")
                                    : null,
                                onSuccess: (personModel?.hasVehicle ?? false)
                                    ? () {
                                        Navigator.of(context).pushNamed(
                                            "/admin/gms/vehicle/in",
                                            arguments: {
                                              "mobileNo": personModel.mobileNo,
                                            });
                                      }
                                    : null,
                              );
                            }
                          }
                        });
                      }
                    }
                  }
                },
                child: Text(AppLocalizations.of(context).translate("submit")),
              ),
            ],
          ),
        );
      }),
    );
  }
}
