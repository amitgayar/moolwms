import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/pages/gms/suggestion_box.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';

class PersonInPage extends StatefulWidget {
  const PersonInPage({super.key});


  @override
  PersonInPageState createState() => PersonInPageState();
}

class PersonInPageState extends State<PersonInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MobileNoModel mobileNo = MobileNoModel();
  PersonStore? personStore = PersonStore();

  TextEditingController mobileController  = TextEditingController();

  @override
  void initState() {
    super.initState();
    mobileNo.countryCode = "";
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
            ('person_in'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: ColorConstants.primary),
          ),
        ),
        body: Form(
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
                    } else if (val.length < 10 || val.length > 10) {
                      return
                        ("enter_ten_digit_mobile_number");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    mobileNo.number = val;
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
                    //     selectedCountry: mobileNo.countryCode,
                    //     onChanged: (country) {
                    //       setState(() {
                    //         mobileNo.countryCode = country;
                    //       });
                    //     }),
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
        floatingActionButton: (personStore?.showProgress)??false?Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                //todo: person navigator special entry
                // Navigator.of(context).pushReplacementNamed(
                //     '/admin/gms/person/specialEntry',
                //     arguments: {"purpose": "PersonIn"});
              },
              child: const Text(
                  ("special_entry")),
            ),
            const SizedBox(width: 8),
            GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  PersonModel? personDetail =
                  await personStore!.getPerson( mobileNo);
                  if (personDetail != null) {
                    bool isPersonInside =
                    await personStore?.isPersonInside(mobileNo);
                    if (isPersonInside) {
                      DialogViews.showErrorDialog(
                          context,
                          ("person_already_inside_facility"));
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
                  // Map<String, String> userMap = {
                  //   "mobileNumber": mobileNo.fullNumber
                  // };

                  //todo: Navigator person in -> verifyOtp

                  Future.delayed(const Duration(milliseconds: 0), () => Navigator.of(context).pushNamed("/verifyOtp", arguments: {
                    "mobileNo": mobileNo,
                    "isPerson": true,
                    "otpType": 3,
                  }).then((value) {
                    if (value is bool && value) {
                      if (personDetail != null &&
                          (personDetail.personType?.value == 1 ||
                              personDetail.personType?.value == 6 ||
                              personDetail.personType?.value == 8)) {
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
                                          "Welcome\n${personDetail.fullName ?? ""}",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      const SizedBox(height: 18),
                                      GradientButton(
                                          child: Text(
                                              "Person IN as ${personDetail.personType?.label ?? ""}"),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await personStore!
                                                .personIn(
                                                 personDetail)
                                                .then((value) {
                                              DialogViews
                                                  .showSuccessBottomSheet(
                                                context,
                                                detailText:
                                                (
                                                    "person_in_successful"),
                                                successText:
                                                ("vehicle_in"),
                                                onSuccess: () {
                                                  //todo: Navigator personIn -> VehicleIn

                                                  Navigator.of(context).pushNamed(
                                                      "/admin/gms/vehicle/in",
                                                      arguments: {
                                                        "mobileNo":
                                                        personDetail.mobileNo,
                                                      });
                                                },
                                              );
                                            });
                                          }),
                                      const SizedBox(height: 8),
                                      TextButton(
                                          child: const Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 4.0),
                                            child: Text(

                                                ("cancel")),
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
                        //todo: Navigator addEditPerson
                        Navigator.of(context).pushReplacementNamed(
                            '/admin/gms/person/addEdit',
                            arguments: {
                              "store": personStore,
                              "mobileNo": mobileNo,
                              "person": personDetail,
                            });
                      }
                    }
                  }));
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
