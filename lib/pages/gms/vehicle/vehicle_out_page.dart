import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/suggestion_box.dart';
import 'package:moolwms/pages/gms/vehicle/model.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';

class VehicleOutPage extends StatefulWidget {
  final String? mobileNo;

  const VehicleOutPage({super.key, this.mobileNo});

  @override
  VehicleOutPageState createState() => VehicleOutPageState();
}

class VehicleOutPageState extends State<VehicleOutPage> {
  PersonStore personStore = PersonStore();
  VehicleStore vehicleStore = VehicleStore();
  GateStore gateStore = GateStore();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _mobNoFormFieldKey = GlobalKey<FormFieldState>();
  String? mobileNo;
  PersonModel? personModel;
  GateTransactionModel? gateTxn;
  bool isMobileNoVerified = false, hasMaterial = false;
  String vehicleNo = "";
  bool isVehiclePresent = false;


  TextEditingController vehController = TextEditingController();
  TextEditingController mobileController  = TextEditingController();


  @override
  void initState() {
    super.initState();
    vehController  = TextEditingController();
    mobileController  = TextEditingController(text: widget.mobileNo??'');
  }

  @override
  void dispose() {
    vehController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(("vehicle_out"))),
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    ("mobile_number"),
                    style: Theme.of(context).textTheme.caption),
                AbsorbPointer(
                  absorbing: isMobileNoVerified,
                  child: TextFormField(
                    controller: mobileController,
                    key: _mobNoFormFieldKey,
                    // enabled: !isMobileNoVerified,
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
                      mobileNo = val;
                    },
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: DecorationUtils.getTextFieldDecoration(
                      // prefixIcon:
                      //todo: prefix icon
                      // CountryPicker(
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
                ),
                const SizedBox(height: 24),
                if(isMobileNoVerified)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: vehController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return
                              ("enter_vehicle_number");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          vehicleNo = val!;
                        },
                        textCapitalization: TextCapitalization.characters,
                        decoration: DecorationUtils.getTextFieldDecoration(
                          labelText:
                          ("vehicle_number"),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                          child: SuggestionBox(
                            onClick: (val){
                              vehController.text = val[1].toString();
                              // if(!isMobileNoVerified){
                              mobileNo = val[0];
                              mobileController.text = val[0].toString();
                              vehicleNo = val[1];
                              // }
                            },
                            isMobileNoVerified : isMobileNoVerified,
                            transactionType: 1,
                          )),

                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       hasMaterial = !hasMaterial;
                      //     });
                      //   },
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       SizedBox(
                      //         width: 12,
                      //         height: 12,
                      //         child: Checkbox(
                      //             value: hasMaterial,
                      //             onChanged: (val) {
                      //               setState(() {
                      //                 hasMaterial = val;
                      //               });
                      //             }),
                      //       ),
                      //       SizedBox(width: 8),
                      //       Text(
                      //           ("contains_material?")),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 24),
                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       borrowsVehicle = !borrowsVehicle;
                      //     });
                      //   },
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       SizedBox(
                      //         width: 12,
                      //         height: 12,
                      //         child: Checkbox(
                      //             value: borrowsVehicle,
                      //             onChanged: (val) {
                      //               setState(() {
                      //                 borrowsVehicle = val;
                      //               });
                      //             }),
                      //       ),
                      //       SizedBox(width: 8),
                      //       Text(
                      //           ("borrows_vehicle?")),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(("cancel")),
            ),
            const SizedBox(width: 8),
            isMobileNoVerified
                ? GradientButton(
              onPressed: ()  async{
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  VehicleModel? vehicle = await vehicleStore
                      .getVehicle(vehicleNo);
                  if (vehicle != null) {
                    bool isVehicleInside = await vehicleStore
                        .isVehicleInside(vehicleNo);
                    if (isVehicleInside) {
                      personModel ??= await personStore.getPerson(
                          mobileNo);
                      vehicle.personId = personModel?.id;
                      if (gateTxn?.vehicle != null &&
                          gateTxn?.vehicle?.vehicleNumber !=
                              vehicleNo) {
                        vehicle.borrowsVehicle = true;
                      } else {
                        vehicle.borrowsVehicle = false;
                      }
                      if (vehicle.borrowsVehicle!) {
                        // PersonModel ownerInfo = vehicleStore.sendBorrowVehicleOTP(mobileNo!, vehicleNo);
                        //todo:
                        // Navigator.of(context).pushNamed("/verifyOtp", arguments: {
                        //   "personName": ownerInfo.fullName,
                        //   "mobileNo": ownerInfo.mobileNo,
                        //   "isPerson": true,
                        //   "isOtpSent": true,
                        //   "otpType": 4,
                        //   "specialPersonMobileNo": mobileNo,
                        // }).then((value)  {
                        //   if (value is bool && value) {
                        //     vehicleOut(vehicle);
                        //   }
                        // });
                      } else {
                        vehicleOut(vehicle);
                      }
                    } else {
                      DialogViews.showErrorDialog(
                          context,
                          ( "vehicle_not_inside_facility"));
                    }
                  } else {
                    DialogViews.showErrorDialog(
                        context,
                        ("vehicle_not_available"));
                  }
                }
              },
              child: const Text(
                  ("verify")),
            )
                : GradientButton(
              onPressed: () async {
                if (_mobNoFormFieldKey.currentState!.validate()) {
                  _mobNoFormFieldKey.currentState!.save();
                  personModel =
                  await personStore.getPerson( mobileNo);
                  if (personModel != null) {
                    GateTransactionModel? gateTxn = await GateStore()
                        .getLastPersonInTransaction(personModel!.id);
                    if (gateTxn?.vehicle != null) {
                      vehicleNo = gateTxn?.vehicle?.vehicleNumber;
                      vehController.text =
                          gateTxn?.vehicle?.vehicleNumber ?? "";
                    }
                    setState(() {
                      isMobileNoVerified = true;
                    });
                  } else {
                    DialogViews.showErrorDialog(
                        context,
                        ("person_not_found"));
                  }
                }
              },
              child: const Text(
                  ("check")),
            ),
          ],
        ),
      ),
    );
  }

  void vehicleOut(VehicleModel vehicle) async {
    var outResp = await vehicleStore.vehicleOut(vehicle);
    if (outResp != null) {
      Future.delayed(const Duration(milliseconds: 0), () => DialogViews.showSuccessBottomSheet(
        context,
        detailText:
        ("vehicle_out_successful"),
        successText: hasMaterial
            ? ("material_out")
            : null,
        onSuccess: hasMaterial
            ? () {
          Navigator.of(context)
              .pushNamed("/admin/gms/material/out", arguments: {
            "mobileNo": mobileNo,
            "vehicleNo": vehicleNo,
          });
        }
            : null,
      ));
    }
  }
}


