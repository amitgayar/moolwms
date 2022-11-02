import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/visibility_extended.dart';

class PersonSpecialEntryDetailsPage extends StatefulWidget {
  final PersonModel? personModel;

  const PersonSpecialEntryDetailsPage({super.key, this.personModel});

  @override
  PersonSpecialEntryDetailsPageState createState() =>
      PersonSpecialEntryDetailsPageState();
}

class PersonSpecialEntryDetailsPageState
    extends State<PersonSpecialEntryDetailsPage> {
  PersonStore personStore = PersonStore();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersonSpecialEntryModel personSpecialEntryModel = PersonSpecialEntryModel();

  @override
  void initState() {
    super.initState();
    personSpecialEntryModel.mobileNo = MobileNoModel();
    personSpecialEntryModel.mobileNo!.countryCode = "";
    //todo: country code
    // Country.findByIsoCode(globals.countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(("special_entry")),
      ),
      body: SingleChildScrollView(
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
                    if (val!.isEmpty) {
                      return ("enter_full_name");
                    }
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                      labelText: ("full_name")),
                ),
                const SizedBox(height: 24),
                Text(("mobile_number"),
                    style: Theme.of(context).textTheme.caption),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return ("enter_mobile_number");
                    } else if (val.length < 6) {
                      return ("enter_valid_mobile_number");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    personSpecialEntryModel.mobileNo!.number = val;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      //todo: country picker
                      // prefixIcon: CountryPicker(
                      //     showDialingCode: true,
                      //     showName: false,
                      //     dense: true,
                      //     selectedCountry:
                      //         personSpecialEntryModel.mobileNo.countryCode,
                      //     onChanged: (country) {
                      //       setState(() {
                      //         personSpecialEntryModel.mobileNo.countryCode =
                      //             country;
                      //       });
                      //     }),
                      ),
                ),
                const SizedBox(height: 24),
                DropdownSearch<AppUserDetailsModel?>(
                  compareFn: (op1, op2) => op1?.id == op2?.id,
                  onChanged: (val) => personSpecialEntryModel.whomToMeet = val,
                  selectedItem: personSpecialEntryModel.whomToMeet,
                  itemAsString: (op) => op?.name,
                  validator: (val) {
                    if (val == null) {
                      return ("select_whom_to_meet");
                    }
                    return null;
                  },
                  onSaved: (val) => personSpecialEntryModel.whomToMeet = val,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: personSpecialEntryModel.purpose,
                  onSaved: (val) => personSpecialEntryModel.purpose = val,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return ("enter_purpose");
                    }
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText: ("purpose"),
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
                    labelText: ("remarks"),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: VisibilityExtended(
        visible: !(personStore.showProgress ?? false),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                child: const Text(("Cancel")),
                onPressed: () => Navigator.of(context).pop()),
            const SizedBox(width: 8),
            GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  var specialEntryResp = await personStore.specialEntry(
                       personSpecialEntryModel);
                  if (specialEntryResp) {
                    //todo: Navigator -> verifyOtp
                    Future.delayed(const Duration(milliseconds: 0), () =>
                        Navigator.of(context).pushNamed("/verifyOtp", arguments: {
                      "personName": personSpecialEntryModel.whomToMeet!.name,
                      "mobileNo": personSpecialEntryModel.whomToMeet?.mobileNo,
                      "isPerson": true,
                      "isOtpSent": true,
                      "specialPersonMobileNo":
                      personSpecialEntryModel.mobileNo,
                      "otpType": 1,
                    }).then((value) async {
                      if (value is bool && value) {
                        var person = await personStore.getPerson(
                             personSpecialEntryModel.mobileNo);
                        //todo: Navigator -> person-addEdit

                        Future.delayed(const Duration(milliseconds: 0), () =>
                        Navigator.of(context).pushReplacementNamed(
                            '/admin/gms/person/addEdit',
                            arguments: {
                              "store": personStore,
                              "mobileNo": personSpecialEntryModel.mobileNo,
                              "person": person
                            }));
                      }
                    }));
                  }
                }
              },
              child: const Text(("submit")),
            ),
          ],
        ),
      ),
    );
  }
}
