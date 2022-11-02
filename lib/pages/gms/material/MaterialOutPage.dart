import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moolwms/api/DioClient.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/store/VehicleStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Extensions.dart';
import 'package:moolwms/constants/Globals.dart' as globals;
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';

class MaterialOutPage extends StatefulWidget {
  MobileNoModel mobileNo;
  String vehicleNo;
  MaterialOutPage(dynamic args) {
    if (args is Map) {
      mobileNo = args['mobileNo'];
      vehicleNo = args['vehicleNo'];
    }
  }

  @override
  _MaterialOutPageState createState() => _MaterialOutPageState();
}

class _MaterialOutPageState extends State<MaterialOutPage> {
  PersonStore personStore = PersonStore();
  VehicleStore vehicleStore = VehicleStore();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> _mobNoformFieldKey = GlobalKey<FormFieldState>();
  MobileNoModel mobileNo = MobileNoModel();
  bool isMobileNoVerified = false;
  String vehicleNo;

  @override
  void initState() {
    super.initState();
    if (widget.mobileNo != null) {
      mobileNo = widget.mobileNo;
      vehicleNo = widget.vehicleNo;
      isMobileNoVerified = true;
    } else {
      mobileNo.countryCode = Country.findByIsoCode(globals.countryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("material_out"))),
      body: Observer(builder: (_) {
        return ProgressContainerView(
          isProgressRunning: (personStore?.showProgress ?? false) ||
              (vehicleStore?.showProgress ?? false),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate("mobile_number"),
                      style: Theme.of(context).textTheme.caption),
                  AbsorbPointer(
                    absorbing: isMobileNoVerified,
                    child: TextFormField(
                      key: _mobNoformFieldKey,
                      enabled: !isMobileNoVerified,
                      initialValue: mobileNo?.number,
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
                        mobileNo.number = val;
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
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
                  ),
                  const SizedBox(height: 24),
                  VisibilityExtended(
                    visible: isMobileNoVerified,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: vehicleNo,
                          validator: (val) {
                            if (val.isEmptyOrNull) {
                              return AppLocalizations.of(context)
                                  .translate("enter_vehicle_number");
                            }
                            return null;
                          },
                          onSaved: (val) {
                            vehicleNo = val;
                          },
                          textCapitalization: TextCapitalization.characters,
                          decoration: DecorationUtils.getTextFieldDecoration(
                            context,
                            labelText: AppLocalizations.of(context)
                                .translate("vehicle_number"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Observer(builder: (_) {
        return VisibilityExtended(
          visible: !((personStore?.showProgress ?? false) ||
              (vehicleStore?.showProgress ?? false)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).translate("cancel")),
              ),
              const SizedBox(width: 8),
              isMobileNoVerified
                  ? GradientButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          var person =
                              await personStore.getPerson(context, mobileNo);
                          var vehicle =
                              await vehicleStore.getVehicle(context, vehicleNo);
                          Navigator.of(context).pushNamed(
                              '/admin/gms/material/addedit',
                              arguments: {
                                "mobileNo": mobileNo,
                                "vehicleNo": vehicleNo,
                                "person": person,
                                "vehicle": vehicle,
                                "direction": "outward"
                              });
                        }
                      },
                      child: Text(
                          AppLocalizations.of(context).translate("verify")),
                    )
                  : GradientButton(
                      onPressed: () async {
                        if (_mobNoformFieldKey.currentState.validate()) {
                          _mobNoformFieldKey.currentState.save();
                          var isPersonIn = await personStore.isPersonInside(
                              context, mobileNo);
                          if (isPersonIn) {
                            setState(() {
                              isMobileNoVerified = true;
                            });
                          } else {
                            showErrorDialog(
                                context,
                                AppLocalizations.of(context)
                                    .translate("person_not_inside_facility"));
                          }
                        }
                      },
                      child:
                          Text(AppLocalizations.of(context).translate("check")),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
