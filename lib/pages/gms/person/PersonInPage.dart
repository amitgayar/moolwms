import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/Providers/FirebaseProvider.dart';
import 'package:moolwms/api/DioClient.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/AppUserDetailModel.dart';
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

class PersonInPage extends StatefulWidget {
  const PersonInPage(dynamic args);

  @override
  _PersonInPageState createState() => _PersonInPageState();
}

class _PersonInPageState extends State<PersonInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MobileNoModel mobileNo = MobileNoModel();
  PersonStore personStore = PersonStore();
  final FirebaseProvider _firebaseProvider = locator<FirebaseProvider>();

  TextEditingController mobileController  = TextEditingController();

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
            AppLocalizations.of(context).translate('person_in'),
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
                        } else if (val.length < 10 || val.length > 10) {
                          return AppLocalizations.of(context)
                              .translate("enter_ten_digit_mobile_number");
                        }
                        return null;
                      },
                      onSaved: (val) {
                        mobileNo.number = val;
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    const SizedBox(height: 16),
                    Text("Recent Visitors",
                        style: Theme.of(context)
                            .textTheme
                            .caption),
                    const SizedBox(height: 16),

                    Expanded(
                        child: SuggestionBox(
                            onClick: (val)async{
                              mobileNo.number = val[0];
                              mobileController.text = val[0].toString();
                            },
                            isMobileNoVerified : false,
                          transactionType: 2,
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
                FlatButton(
                  onPressed: () {
                    _firebaseProvider.analytics
                        .logEvent(name: "SpecialEntryClicked");
                    Navigator.of(context).pushReplacementNamed(
                        '/admin/gms/person/specialentry',
                        arguments: {"purpose": "PersonIn"});
                  },
                  child: Text(
                      AppLocalizations.of(context).translate("special_entry")),
                ),
                const SizedBox(width: 8),
                GradientButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      PersonModel personDetail =
                          await personStore.getPerson(context, mobileNo);
                      if (personDetail != null) {
                        bool isPersonInside =
                            await personStore.isPersonInside(context, mobileNo);
                        if (isPersonInside) {
                          showErrorDialog(
                              context,
                              AppLocalizations.of(context)
                                  .translate("person_already_inside_facility"));
                          return;
                        }
                      }
                      // if (personDetail == null &&
                      //     !globals.user.checkUserRole([
                      //       UserRole.SuperAdmin,
                      //       UserRole.Admin,
                      //       UserRole.HR
                      //     ])) {
                      //   DialogViews.showUnauthorizedBottomSheet(context);
                      //   return;
                      // }
                      Map<String, String> userMap = {
                        "mobileNumber": mobileNo.fullNumber
                      };

                      _firebaseProvider.analytics.logEvent(
                          name: "PersonInOTPVerificationStart",
                          parameters: userMap);

                      Navigator.of(context).pushNamed("/verifyotp", arguments: {
                        "mobileNo": mobileNo,
                        "isPerson": true,
                        "otpType": 3,
                      }).then((value) {
                        if (value is bool && value) {
                          if (personDetail != null &&
                              (personDetail?.personType?.value == 1 ||
                                  personDetail?.personType?.value == 6 ||
                                  personDetail?.personType?.value == 8)) {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: Card(
                                    margin: const EdgeInsets.all(0),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    color: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Icon(Icons.person,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                              "Welcome\n${personDetail?.fullName ?? ""}",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          const SizedBox(height: 18),
                                          GradientButton(
                                              child: Text(
                                                  "Person IN as ${personDetail?.personType?.label ?? ""}"),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await personStore
                                                    .personIn(
                                                        context, personDetail)
                                                    .then((value) {
                                                  DialogViews
                                                      .showSuccessBottomSheet(
                                                    context,
                                                    detailText: AppLocalizations
                                                            .of(context)
                                                        .translate(
                                                            "person_in_successful"),
                                                    successText: AppLocalizations
                                                            .of(context)
                                                        .translate("vehicle_in"),
                                                    onSuccess: () {
                                                      Navigator.of(context).pushNamed(
                                                          "/admin/gms/vehicle/in",
                                                          arguments: {
                                                            "mobileNo":
                                                                personDetail
                                                                    ?.mobileNo,
                                                          });
                                                    },
                                                  );
                                                });
                                              }),
                                          const SizedBox(height: 8),
                                          FlatButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4.0),
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("cancel")),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          else {
                            Navigator.of(context).pushReplacementNamed(
                                '/admin/gms/person/addedit',
                                arguments: {
                                  "store": personStore,
                                  "mobileNo": mobileNo,
                                  "person": personDetail,
                                });
                          }
                        }
                      });
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
