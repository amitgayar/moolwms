import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/gms/suggestion_box.dart';
import 'package:moolwms/pages/gms/vehicle/model.dart';
import 'package:moolwms/utils/dev_utils.dart';

class VehicleInPage extends StatefulWidget {
  final String? mobileNo;
  final String? vehicleNo;

  const VehicleInPage({super.key, this.mobileNo, this.vehicleNo});

  @override
  VehicleInPageState createState() => VehicleInPageState();
}

class VehicleInPageState extends State<VehicleInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _mobNoFormFieldKey =
      GlobalKey<FormFieldState>();
  final PersonStore personStore = PersonStore();
  final VehicleStore vehicleStore = VehicleStore();

  ///new
  TextEditingController vehController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isMobileNoVerified = false;
  String? mobileNo;
  String? vehicleNo;

  @override
  void initState() {
    super.initState();
    vehController = TextEditingController(text: widget.vehicleNo ?? '');
    mobileController = TextEditingController(text: widget.mobileNo ?? '');
  }

  @override
  void dispose() {
    vehController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logPrint.w(
      'widget.mobileNo : ${widget.mobileNo!}, isMobileNoVerified : $isMobileNoVerified',
    );
    // Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text(("vehicle_in"))),
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(("mobile_number"),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption),
                TextFormField(
                  controller: mobileController,
                  key: _mobNoFormFieldKey,
                  // enabled: !isMobileNoVerified,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return ("enter_mobile_number");
                    } else if (val.length < 6) {
                      return ("enter_valid_mobile_number");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    mobileNo = val;
                  },
                  // onChanged: (val) {
                  //   mobileNo.number = val;
                  // },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: DecorationUtils.getTextFieldDecoration(
                    prefixIcon: null, //todo: countryPicker
                  ),
                ),
                const SizedBox(height: 24),
                if (isMobileNoVerified)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: vehController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("enter_vehicle_number");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          vehicleNo = val;
                        },
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                            labelText: ("vehicle_number")),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                !isMobileNoVerified
                    ? Text("Person Already In facility suggestions",
                        style: Theme.of(context).textTheme.caption)
                    : Container(),
                const SizedBox(height: 16),
                !isMobileNoVerified
                    ? Expanded(
                        child: SuggestionBox(
                        onClick: (val) {
                          vehController.text = val[1].toString();
                          mobileController.text = val[0].toString();
                          // if(!isMobileNoVerified){
                          mobileNo = val[0];
                          // mobileController.text = val[0].toString();
                          vehicleNo = val[1];
                          // }
                        },
                        isMobileNoVerified: isMobileNoVerified,
                        // isMobileNoVerified : false,
                        transactionType: 1,
                      ))
                    : Container(),
                const SizedBox(height: 24),
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
              child: const Text(
                  // ("cancel")
                  ("Cancel")),
            ),
            const SizedBox(width: 8),
            isMobileNoVerified
                ? ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        PersonModel person =
                            await personStore.getPerson(mobileNo!);
                        VehicleModel? vehicle =
                            await vehicleStore.getVehicle(vehicleNo);
                        if (vehicle != null) {
                          bool isVehicleInside =
                              await vehicleStore.isVehicleInside(vehicleNo);
                          if (isVehicleInside) {
                            showErrorDialog(
                                // ("vehicle_already_inside_facility")
                                ("Vehicle already inside facility"));
                          } else {
                            Future.delayed(
                                const Duration(milliseconds: 0),
                                () => Navigator.of(context).pushNamed(
                                        '/admin/gms/vehicle/addEdit',
                                        arguments: {
                                          'mobileNo': mobileNo,
                                          'vehicleNo': vehicleNo,
                                          'store': vehicleStore,
                                          'vehicle': vehicle,
                                          'person': person,
                                        }));
                          }
                        } else {
                          await Future.delayed(
                              const Duration(milliseconds: 0),
                              () => Navigator.of(context).pushNamed(
                                      '/admin/gms/vehicle/addEdit',
                                      arguments: {
                                        'mobileNo': mobileNo,
                                        'vehicleNo': vehicleNo,
                                        'store': vehicleStore,
                                        'person': person,
                                      }));
                        }
                      }
                    },
                    child: const Text(
                        // ("verify")
                        ("Verify")),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      logPrint.w(
                          'personStore.personList :${personStore.personList}');
                      if (_mobNoFormFieldKey.currentState!.validate()) {
                        _mobNoFormFieldKey.currentState!.save();
                        bool isInside =
                            await personStore.isPersonInside(mobileNo);
                        logPrint.w("isInside: $isInside");

                        if (isInside) {
                          setState(() {
                            isMobileNoVerified = true;
                          });
                        } else {
                          showErrorDialog(
                              // ("person_not_inside_facility")
                              ("Person not inside facility"));
                        }
                      }
                    },
                    child: const Text(("check")),
                  ),
          ],
        ),
      ),
    );
  }

  //todo: !!!!!! error message on network error
  void showErrorDialog(String s, {Function? onOKPressed}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              title: Text(s),
              // content: Text(errorMsg),
              actions: <Widget>[
                TextButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                    if (onOKPressed != null) {
                      onOKPressed();
                    }
                  }),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        });
  }
}
