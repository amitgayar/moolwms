import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/pages/gms/suggestion_box.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';


class PersonOutPage extends StatefulWidget {
  const PersonOutPage({super.key});

  @override
  PersonOutPageState createState() => PersonOutPageState();
}

class PersonOutPageState extends State<PersonOutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MobileNoModel mobileNo = MobileNoModel();
  String? vehicleNo;
  TextEditingController mobileController  = TextEditingController();


  PersonStore personStore = PersonStore();

  @override
  void initState() {
    super.initState();
    //todo: country code
    mobileNo.countryCode = "";
        // Country.findByIsoCode(globals.countryCode);
  }
  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ('person_out'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: ColorConstants.primary),
          ),
        ),
        body:
        (personStore?.showProgress ?? false)?
        Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/images/verification.svg",
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                const SizedBox(height: 40),
                Text(("mobile_number"),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: mobileController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return
                        ("enter_mobile_number");
                    } else if (val.length < 6) {
                      return
                        ("enter_valid_mobile_number");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    mobileNo.number = val;
                  },
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    //todo: country picker decoration
                    // prefixIcon: CountryPicker(
                    //     showDialingCode: true,
                    //     showName: false,
                    //     dense: true,
                    //     selectedCountry: mobileNo.countryCode,
                    //     onChanged: (country) {
                    //       setState(() {
                    //         mobileNo.countryCode = country;
                    //       });
                    //     }),
                  ),
                ),
                const SizedBox(height: 24),
                Text("Person Already In facility suggestions",
                    style: Theme.of(context)
                        .textTheme
                        .caption),
                const SizedBox(height: 16),
                Expanded(
                    child: SuggestionBox(
                      onClick: (val){
                        mobileNo.number = val[0];
                        mobileController.text = val[0].toString();
                      },
                      isMobileNoVerified : false,
                      transactionType: 1,
                    )),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ):null,
        floatingActionButton:

        (personStore?.showProgress ?? false)?
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  PersonModel person =
                  await personStore.getPerson(mobileNo);
                  if (person != null) {
                    bool isInside =
                    await personStore.isPersonInside(mobileNo);
                    if (isInside) {
                      var outTxn =
                      await personStore.personOut( person);
                      if (outTxn != null) {
                        DialogViews.showSuccessBottomSheet(
                          context,
                          detailText:
                          ("person_out_successful"),
                          successText:
                          ("vehicle_out"),
                          onSuccess: () {
                            //todo : navigator personOut -> vehicleOut
                            Navigator.of(context)
                              ..pop()
                              ..pushNamed("/admin/gms/vehicle/out",
                                  arguments: {"mobileNo": mobileNo});
                          },
                        );
                      }
                    } else {
                      DialogViews.showErrorDialog(
                          context,

                          ("person_not_inside_facility"));
                    }
                  } else {
                    DialogViews.showErrorDialog(
                        context,

                        ("person_not_inside_facility"));
                  }
                }
              },
              child: const Text(("verify")),
            ),
          ],
        ):null,
      ),
    );
  }
}
