import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/visibility_extended.dart';


class MaterialInPage extends StatefulWidget {
  final MobileNoModel? mobileNo;
  final String vehicleNo;

  const MaterialInPage({super.key, required this.mobileNo, required this.vehicleNo});

  @override
  MaterialInPageState createState() => MaterialInPageState();
}

class MaterialInPageState extends State<MaterialInPage> {
  PersonStore personStore = PersonStore();
  VehicleStore vehicleStore = VehicleStore();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _mobNoFieldKey = GlobalKey<FormFieldState>();
  MobileNoModel mobileNo = MobileNoModel();
  bool isMobileNoVerified = false;
  String? vehicleNo;

  @override
  void initState() {
    super.initState();
    if (widget.mobileNo != null) {
      mobileNo = widget.mobileNo!;
      vehicleNo = widget.vehicleNo;
      isMobileNoVerified = true;
    } else {
      //todo: country code
      mobileNo.countryCode = "";
          // Country.findByIsoCode(globals.countryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              ("material_in"))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(("mobile_number"),
                  style: Theme.of(context).textTheme.caption),
              AbsorbPointer(
                absorbing: isMobileNoVerified,
                child: TextFormField(
                  key: _mobNoFieldKey,
                  initialValue: mobileNo.number,
                  enabled: !isMobileNoVerified,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: DecorationUtils.getTextFieldDecoration(
                    // todo: country picker
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
              ),
              const SizedBox(height: 24),
              VisibilityExtended(
                // visible: isMobileNoVerified,
                visible: true,
                child: TextFormField(
                  initialValue: widget.vehicleNo,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return
                        ("enter_vehicle_number");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    vehicleNo = val;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText:
                    ("vehicle_number"),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              suggestionBox(size)

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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                bool isVehicleIn = await vehicleStore.isVehicleInside(
                    vehicleNo);
                if (isVehicleIn) {
                  var person =
                  await personStore.getPerson( mobileNo);
                  var vehicle = await vehicleStore.getVehicle(
                      vehicleNo);
                  Future.delayed(const Duration(milliseconds: 0), () => Navigator.of(context).pushNamed(
                      '/admin/gms/material/addEdit',
                      arguments: {
                        "mobileNo": mobileNo,
                        "vehicleNo": vehicleNo,
                        "person": person,
                        "vehicle": vehicle,
                        "direction": "inward"
                      }));
                } else {
                  DialogViews.showErrorDialog(
                      context,

                      ("vehicle_not_inside_facility"));
                }
              }
            },
            child: const Text(
                ("verify")),
          )
              : GradientButton(
            onPressed: () async {
              if (_mobNoFieldKey.currentState!.validate()) {
                _mobNoFieldKey.currentState!.save();
                var isPersonIn = await personStore.isPersonInside(
                    mobileNo);
                if (isPersonIn) {
                  setState(() {
                    isMobileNoVerified = true;
                  });
                } else {
                  DialogViews.showErrorDialog(
                      context,

                      ("person_not_inside_facility"));
                }
              }
            },
            child:
            const Text(("check")),
          ),
        ],
      ),
    );
  }
  suggestionBox(Size size) {
    var choices = [
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
      'suggestion1',
    ];
    return Container(
      constraints: BoxConstraints(maxWidth: size.width, maxHeight: size.height*0.6),
      color: Colors.white,
      child: Wrap(
        spacing:8,
        runSpacing: 8,
        children: choices.map((e) {
          return chipTile(
            child: e,
          );
        }).toList(),
      ),
    );
  }

  Widget chipTile({String? child}) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          // ignore: unnecessary_const
          borderRadius: const BorderRadius.all(const Radius.circular(24)),
          color: Colors.blue[100]),
      child: FittedBox(child: Text(child!)),


    );
  }


}
