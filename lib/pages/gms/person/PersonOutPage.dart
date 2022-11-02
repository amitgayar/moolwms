import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/Providers/FirebaseProvider.dart';
import 'package:moolwms/api/DioClient.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/pages/gms/suggestion_box.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/constants/Globals.dart' as globals;
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';

import '../../../locator.dart';

class PersonOutPage extends StatefulWidget {
  const PersonOutPage(dynamic args);

  @override
  _PersonOutPageState createState() => _PersonOutPageState();
}

class _PersonOutPageState extends State<PersonOutPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MobileNoModel mobileNo = MobileNoModel();
  String vehicleNo;
  final FirebaseProvider _firebaseProvider = locator<FirebaseProvider>();
  TextEditingController mobileController  = TextEditingController();


  PersonStore personStore = PersonStore();

  @override
  void initState() {
    super.initState();
    mobileNo.countryCode = Country.findByIsoCode(globals.countryCode);
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
            AppLocalizations.of(context).translate('person_out'),
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: ColorConstants.PRIMARY),
          ),
        ),
        body: Observer(builder: (_) {
          return ProgressContainerView(
            isProgressRunning: personStore?.showProgress ?? false,
            child: Form(
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
                    Text(AppLocalizations.of(context).translate("mobile_number"),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: mobileController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("enter_mobile_number");
                        } else if (val.length < 6) {
                          return AppLocalizations.of(context)
                              .translate("enter_valid_mobile_number");
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
                        prefixIcon: CountryPicker(
                            showDialingCode: true,
                            showName: false,
                            dense: true,
                            selectedCountry: mobileNo.countryCode,
                            onChanged: (country) {
                              setState(() {
                                mobileNo.countryCode = country;
                              });
                            }),
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
            ),
          );
        }),
        floatingActionButton: Observer(builder: (_) {
          return VisibilityExtended(
            visible: !(personStore?.showProgress ?? false),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GradientButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      PersonModel person =
                          await personStore.getPerson(context, mobileNo);
                      if (person != null) {
                        bool isInside =
                            await personStore.isPersonInside(context, mobileNo);
                        if (isInside) {
                          var outTxn =
                              await personStore.personOut(context, person);
                          if (outTxn != null) {
                            _firebaseProvider.analytics.logEvent(
                                name: "PersonOutSuccess",
                                parameters: {
                                  "mobileNumber": mobileNo.fullNumber
                                });
                            DialogViews.showSuccessBottomSheet(
                              context,
                              detailText: AppLocalizations.of(context)
                                  .translate("person_out_successful"),
                              successText: AppLocalizations.of(context)
                                  .translate("vehicle_out"),
                              onSuccess: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed("/admin/gms/vehicle/out",
                                      arguments: {"mobileNo": mobileNo});
                              },
                            );
                          }
                        } else {
                          showErrorDialog(
                              context,
                              AppLocalizations.of(context)
                                  .translate("person_not_inside_facility"));
                        }
                      } else {
                        showErrorDialog(
                            context,
                            AppLocalizations.of(context)
                                .translate("person_not_inside_facility"));
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context).translate("verify")),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
