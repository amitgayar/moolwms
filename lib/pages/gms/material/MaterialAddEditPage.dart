import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/Providers/FirebaseProvider.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/api/CustomerAPIs.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/model/MoolwmsOrgModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/model/VehicleModel.dart';
import 'package:moolwms/pages/stock/apiHit/apiHit.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Utils.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/widgets/EmptyView.dart';

class MaterialAddEditPage extends StatefulWidget {
  MobileNoModel mobileNo;
  String vehicleNo;
  PersonModel person;
  VehicleModel vehicle;
  String direction;

  MaterialAddEditPage(dynamic args) {
    if (args is Map) {
      mobileNo = args['mobileNo'];
      vehicleNo = args['vehicleNo'];
      direction = args['direction'];
      person = args['person'];
      vehicle = args['vehicle'];
    }
  }

  @override
  _MaterialAddEditPageState createState() => _MaterialAddEditPageState();
}

class _MaterialAddEditPageState extends State<MaterialAddEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _vieController = TextEditingController();
  MaterialModel materialModel = MaterialModel();
  bool hasStorageMaterial = false;
  List<MoolwmsOrgModel> customerList;
  @override
  void initState() {
    super.initState();
    materialModel.mobileNo = widget.mobileNo;
    materialModel.vehicleNo = widget.vehicleNo;
    materialModel.directionOfMovement = widget.direction;
    materialModel.personId = widget.person.id;
    materialModel.vehicleId = widget.vehicle.id;
    materialModel.dateOfMovement = DateTime.now();
    _vieController.text =
        DateFormat("dd/MM/yyyy").format(materialModel.dateOfMovement);
  }

  @override
  void dispose() {
    _vieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(AppLocalizations.of(context).translate("material_details"))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.person.fullName,
                enabled: false,
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("name"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: widget.mobileNo.fullNumber,
                enabled: false,
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("mobile_number"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: materialModel.vehicleNo,
                enabled: widget.vehicleNo.isEmptyOrNull,
                textCapitalization: TextCapitalization.characters,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_vehicle_number");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("vehicle_number"),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                  value: materialModel?.directionOfMovement ?? null,
                  isExpanded: true,
                  // disabledHint: widget.direction == null
                  //     ? null
                  //     : Text(AppLocalizations.of(context)
                  //         .translate(materialModel?.directionOfMovement)),
                  onChanged: (String newValue) {
                    setState(() {
                      materialModel.directionOfMovement = newValue;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    "inward",
                    "outward",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:
                          Text(AppLocalizations.of(context).translate(value)),
                    );
                  }).toList(),
                  iconEnabledColor: ColorConstants.PRIMARY,
                  validator: (val) {
                    if (val.isEmptyOrNull) {
                      return AppLocalizations.of(context)
                          .translate("select_direction_of_movement");
                    }
                    return null;
                  },
                  decoration: DecorationUtils.getDropDownFieldDecoration(
                      context,
                      labelText: AppLocalizations.of(context)
                          .translate("direction_of_movement"))),
              const SizedBox(height: 8),
              const Text(
                  "Select Inward for storing material in warehouse. Select Outward for taking out material from warehouse"),
              const SizedBox(height: 24),
              AbsorbPointer(
                child: TextFormField(
                    controller: _vieController,
                    autofocus: false,
                    enabled: true,
                    validator: (val) {
                      if (val.isEmptyOrNull) {
                        return AppLocalizations.of(context)
                            .translate("select_date_of_movement");
                      }
                      return null;
                    },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      labelText: AppLocalizations.of(context)
                          .translate("date_of_movement"),
                      suffixIcon:
                          const Icon(LineAwesomeIcons.calendar, color: Colors.grey),
                    )),
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () {
                  setState(() {
                    hasStorageMaterial = !hasStorageMaterial;
                    if (!hasStorageMaterial) {
                      materialModel.customer = null;
                    }
                  });
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                          value: hasStorageMaterial,
                          onChanged: (val) async{
                              hasStorageMaterial = val;
                              if (!hasStorageMaterial) {
                                // customerList  = await CustomerAPIs.getCustomers();
                                materialModel.customer = null;
                                setState(() {});
                              }
                          }),
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)
                        .translate("has_storage_material_of_customer?")),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              VisibilityExtended(
                visible: hasStorageMaterial,
                child: DropdownSearch<MoolwmsOrgModel>(
                  emptyBuilder: (context) {
                    return const EmptyView();
                  },
                  showSearchBox: true,
                  showSelectedItem: true,
                  showClearButton: true,
                  compareFn: (op1, op2) => op1?.id == op2?.id,
                  mode: Mode.BOTTOM_SHEET,
                  popupTitle: Container(
                      margin: const EdgeInsets.only(top: 18),
                      padding: const EdgeInsets.only(top: 12, left: 12),
                      child: Text(AppLocalizations.of(context)
                          .translate("customer_name"))),
                  dropdownSearchDecoration:
                      DecorationUtils.getDropDownFieldDecoration(context,
                          labelText: AppLocalizations.of(context)
                              .translate("customer_name")),
                  onChanged: (val) => materialModel.customer = val,
                  selectedItem: materialModel.customer,
                  autoFocusSearchBox: true,
                  onFind: (val) async {
                    logPrint.wtf('getting customers');
                    return await CustomerAPIs.getCustomers(limit: 1000);
                  },
                  // items: customerList,
                  itemAsString: (op) => op.name,
                  validator: (val) {
                    if (hasStorageMaterial && val == null) {
                      return AppLocalizations.of(context)
                          .translate("select_customer");
                    }
                    return null;
                  },
                  onSaved: (val) => materialModel.customer = val,
                ),
              ),
              const SizedBox(height: 24),
              // DropdownSearch<OptionModel>(
              //   showSearchBox: true,
              //   showSelectedItem: true,
              //   compareFn: (op1, op2) => op1?.value == op2?.value,
              //   mode: Mode.BOTTOM_SHEET,
              //   popupTitle: Padding(
              //       padding: EdgeInsets.only(top: 12, left: 12),
              //       child: Text(AppLocalizations.of(context)
              //           .translate("material_type"))),
              //   dropdownSearchDecoration:
              //       DecorationUtils.getDropDownFieldDecoration(
              //     context,
              //     labelText:
              //         AppLocalizations.of(context).translate("material_type"),
              //   ),
              //   onChanged: (val) => materialModel.materialType = val,
              //   selectedItem: materialModel?.materialType,
              //   autoFocusSearchBox: true,
              //   isFilteredOnline: false,
              //   itemAsString: (op) => op.label,
              //   onFind: (val) async {
              //     var materialTypes = await OptionAPIs.getOptions("MATERIALTYPE");
              //     if(widget.direction == "outward") {
              //       materialTypes.removeWhere((element) => element.label.toLowerCase() == "diesel");
              //     }
              //     return materialTypes;
              //   },
              //   validator: (val) {
              //     if (val == null) {
              //       return AppLocalizations.of(context)
              //           .translate("select_material_type");
              //     }
              //     return null;
              //   },
              //   onSaved: (val) => materialModel.materialType = val,
              // ),
              // SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButtonsContainer(
        children: [
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('back')),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          GradientButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.of(context).pushNamed(
                    '/admin/gms/material/materialtypes/list',
                    arguments: {"material": materialModel});
              }
            },
            child: Text(AppLocalizations.of(context).translate("next")),
          ),
        ],
      ),
    );
  }
}
