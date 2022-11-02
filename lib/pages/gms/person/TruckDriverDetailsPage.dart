import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/api/CustomerAPIs.dart';
import 'package:moolwms/model/MoolwmsOrgModel.dart';
import 'package:moolwms/model/OptionModel.dart';
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

class TruckDriverDetailsPage extends StatefulWidget {
  PersonModel personModel;
  PersonStore personStore;
  TruckDriverDetailsPage(dynamic args) {
    if (args is Map) {
      personModel = args['person'];
      personStore = args['store'];
    }
  }
  @override
  _TruckDriverDetailsPageState createState() => _TruckDriverDetailsPageState();
}

class _TruckDriverDetailsPageState extends State<TruckDriverDetailsPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonModel personModel;

  @override
  void initState() {
    super.initState();
    personModel = widget.personModel;
    personModel.truckDriver ??= TruckDriverModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate("truck_driver_details"))),
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
                        padding: const EdgeInsets.only(top: 12, left: 12),
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
                      return await CustomerAPIs.getCustomers(limit:1000);
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
                  TextFormField(
                    initialValue: personModel?.truckDriver?.drivingLicense,
                    onSaved: (val) =>
                        personModel?.truckDriver?.drivingLicense = val,
                    // validator: (val) {
                    //   if (val.isEmpty) {
                    //     return AppLocalizations.of(context)
                    //         .translate("enter_driving_license");
                    //   }
                    //   return null;
                    // },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      labelText: AppLocalizations.of(context)
                          .translate("driving_license"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: personModel?.truckDriver?.transporterCompany,
                    onSaved: (val) =>
                        personModel?.truckDriver?.transporterCompany = val,
                    // validator: (val) {
                    //   if (val.isEmpty) {
                    //     return AppLocalizations.of(context)
                    //         .translate("enter_transporter_company");
                    //   }
                    //   return null;
                    // },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      labelText: AppLocalizations.of(context)
                          .translate("transporter_company"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownSearch<OptionModel>(
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
                            .translate("is_driver_sober"))),
                    dropdownSearchDecoration:
                        DecorationUtils.getDropDownFieldDecoration(context,
                            labelText: AppLocalizations.of(context)
                                .translate("is_driver_sober")),
                    onChanged: (val) => personModel.isDriverSober = val,
                    selectedItem: personModel.isDriverSober,
                    itemAsString: (op) => op?.label ?? "",
                    autoFocusSearchBox: true,
                    onFind: (val) async {
                      return await OptionAPIs.getOptions("ISDRIVERSOBER");
                    },
                    validator: (val) {
                      if (val == null) {
                        return AppLocalizations.of(context)
                            .translate("select_is_driver_sober");
                      }
                      return null;
                    },
                    onSaved: (val) => personModel.isDriverSober = val,
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
                    if (personModel != null &&
                        personModel?.truckDriver != null) {
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
