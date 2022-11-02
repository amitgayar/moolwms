import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moolwms/model/AppUserDetailModel.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/constants/Globals.dart' as globals;
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Extensions.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/widgets/EmptyView.dart';

class PersonSpecialEntryDetailsPage extends StatefulWidget {
  PersonModel personModel;
  PersonSpecialEntryDetailsPage(dynamic args) {
    if (args is Map) {
      personModel = args['person'];
    }
  }
  @override
  _PersonSpecialEntryDetailsPageState createState() =>
      _PersonSpecialEntryDetailsPageState();
}

class _PersonSpecialEntryDetailsPageState
    extends State<PersonSpecialEntryDetailsPage> {
  PersonStore personStore = PersonStore();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonSpecialEntryModel personSpecialEntryModel = PersonSpecialEntryModel();

  @override
  void initState() {
    super.initState();
    personSpecialEntryModel.mobileNo = MobileNoModel();
    personSpecialEntryModel.mobileNo.countryCode =
        Country.findByIsoCode(globals.countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("special_entry")),
      ),
      body: Observer(builder: (_) {
        return ProgressContainerView(
          isProgressRunning: personStore?.showProgress ?? false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    TextFormField(
                      initialValue: personSpecialEntryModel.fullName,
                      onSaved: (val) => personSpecialEntryModel.fullName = val,
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return AppLocalizations.of(context)
                              .translate("enter_full_name");
                        }
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                          context,
                          labelText: AppLocalizations.of(context)
                              .translate("full_name")),
                    ),
                    const SizedBox(height: 24),
                    Text(
                        AppLocalizations.of(context).translate("mobile_number"),
                        style: Theme.of(context).textTheme.caption),
                    TextFormField(
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return AppLocalizations.of(context)
                              .translate("enter_mobile_number");
                        } else if (val.length < 6) {
                          return AppLocalizations.of(context)
                              .translate("enter_valid_mobile_number");
                        }
                        return null;
                      },
                      onSaved: (val) {
                        personSpecialEntryModel.mobileNo.number = val;
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        prefixIcon: CountryPicker(
                            showDialingCode: true,
                            showName: false,
                            dense: true,
                            selectedCountry:
                                personSpecialEntryModel.mobileNo.countryCode,
                            onChanged: (country) {
                              setState(() {
                                personSpecialEntryModel.mobileNo.countryCode =
                                    country;
                              });
                            }),
                      ),
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
                      popupTitle: Padding(
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Text(AppLocalizations.of(context)
                              .translate("whom_to_meet"))),
                      onChanged: (val) =>
                          personSpecialEntryModel.whomToMeet = val,
                      selectedItem: personSpecialEntryModel.whomToMeet,
                      onFind: (val) async {
                        return globals.authStore
                            .getAppUsersListByOrgId(context);
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
                      onSaved: (val) =>
                          personSpecialEntryModel.whomToMeet = val,
                      dropdownSearchDecoration:
                          DecorationUtils.getDropDownFieldDecoration(context,
                              labelText: AppLocalizations.of(context)
                                  .translate("whom_to_meet")),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: personSpecialEntryModel.purpose,
                      onSaved: (val) => personSpecialEntryModel.purpose = val,
                      validator: (val) {
                        if (val.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("enter_purpose");
                        }
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText:
                            AppLocalizations.of(context).translate("purpose"),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: personSpecialEntryModel.remarks,
                      onSaved: (val) => personSpecialEntryModel.remarks = val,
                      validator: (val) {
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText:
                            AppLocalizations.of(context).translate("remarks"),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Observer(builder: (_) {
        return VisibilityExtended(
          visible: !(personStore?.showProgress ?? false),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                  child: Text(AppLocalizations.of(context).translate("Cancel")),
                  onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 8),
              GradientButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    var specialEntryResp = await personStore.specialEntry(
                        context, personSpecialEntryModel);
                    if (specialEntryResp) {
                      Navigator.of(context).pushNamed("/verifyotp", arguments: {
                        "personName": personSpecialEntryModel.whomToMeet.name,
                        "mobileNo": personSpecialEntryModel.whomToMeet.mobileNo,
                        "isPerson": true,
                        "isOtpSent": true,
                        "specialPersonMobileNo":
                            personSpecialEntryModel.mobileNo,
                        "otpType": 1,
                      }).then((value) async {
                        if (value is bool && value) {
                          var person = await personStore.getPerson(
                              context, personSpecialEntryModel.mobileNo);
                          Navigator.of(context).pushReplacementNamed(
                              '/admin/gms/person/addedit',
                              arguments: {
                                "store": personStore,
                                "mobileNo": personSpecialEntryModel.mobileNo,
                                "person": person
                              });
                        }
                      });
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
