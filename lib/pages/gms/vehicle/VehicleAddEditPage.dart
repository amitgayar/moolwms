import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/Providers/FirebaseProvider.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/constants/APIConstants.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/model/VehicleModel.dart';
import 'package:moolwms/store/VehicleStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Utils.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/widgets/EmptyView.dart';

class VehicleAddEditPage extends StatefulWidget {
  MobileNoModel mobileNo;
  String vehicleNo;
  String purpose;
  VehicleModel vehicleModel;
  PersonModel personModel;
  VehicleStore vehicleStore;

  VehicleAddEditPage(dynamic args) {
    if (args is Map) {
      mobileNo = args['mobileNo'];
      vehicleNo = args['vehicleNo'];
      purpose = args['purpose'];
      vehicleModel = args['vehicle'];
      personModel = args['person'];
      vehicleStore = args['store'];
    }
  }

  @override
  _VehicleAddEditPageState createState() => _VehicleAddEditPageState();
}

class _VehicleAddEditPageState extends State<VehicleAddEditPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _vieController = TextEditingController();
  VehicleModel vehicleModel = VehicleModel();
  @override
  void initState() {
    super.initState();
    if (widget.vehicleModel != null) {
      vehicleModel = widget.vehicleModel;
      if (vehicleModel.insuranceExpiry != null) {
        _vieController.text =
            DateFormat("dd/MM/yyyy").format(vehicleModel.insuranceExpiry);
      }
    } else {
      vehicleModel.vehicleNumber = widget.vehicleNo;
    }
    vehicleModel.personId = widget.personModel?.id;
  }
  @override
  void dispose() {
    _vieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate(
                widget.vehicleModel == null ? "add_vehicle" : "edit_vehicle"))),
        body: Observer(builder: (_) {
          return ProgressContainerView(
            isProgressRunning: widget.vehicleStore?.showProgress ?? false,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: vehicleModel.ownerName,
                      onSaved: (val) => vehicleModel.ownerName = val,
                      enabled: widget.vehicleModel == null,
                      validator: (val) {
                        if (val.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("enter_owner_name");
                        }
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText: AppLocalizations.of(context)
                            .translate("owner_name"),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: vehicleModel.vehicleNumber,
                      enabled: widget.vehicleNo.isEmptyOrNull,
                      validator: (val) {
                        if (val.isEmptyOrNull) {
                          return AppLocalizations.of(context)
                              .translate("enter_vehicle_number");
                        }
                        return null;
                      },
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText: AppLocalizations.of(context)
                            .translate("vehicle_number"),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownSearch<OptionModel>(
                      emptyBuilder: (context) {
                        return const EmptyView();
                      },
                      showSearchBox: true,
                      showSelectedItem: true,
                      enabled: widget.vehicleModel == null,
                      compareFn: (op1, op2) => op1?.id == op2?.id,
                      mode: Mode.BOTTOM_SHEET,
                      popupTitle: Padding(
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Text(AppLocalizations.of(context)
                              .translate("select_owner_type"))),
                      dropdownSearchDecoration:
                          DecorationUtils.getDropDownFieldDecoration(context,
                              labelText: AppLocalizations.of(context)
                                  .translate("owner_type")),
                      onChanged: (val) => vehicleModel.ownerType = val,
                      selectedItem: vehicleModel.ownerType,
                      autoFocusSearchBox: true,
                      onFind: (val) async {
                        return await OptionAPIs.getOptions("OWNERTYPE");
                      },
                      itemAsString: (op) => op.label,
                      // validator: (val) {
                      //   if (val == null) {
                      //     return AppLocalizations.of(context)
                      //         .translate("select_person_type");
                      //   }
                      //   return null;
                      // },
                      onSaved: (val) => vehicleModel.ownerType = val,
                    ),
                    const SizedBox(height: 24),
                    DropdownSearch<OptionModel>(
                      emptyBuilder: (context) {
                        return const EmptyView();
                      },
                      showSearchBox: true,
                      showSelectedItem: true,
                      compareFn: (op1, op2) => op1?.id == op2?.id,
                      mode: Mode.BOTTOM_SHEET,
                      popupTitle: Container(
                          margin: const EdgeInsets.only(top: 18),
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Text(AppLocalizations.of(context)
                              .translate("vehicle_insurance_company"))),
                      dropdownSearchDecoration:
                          DecorationUtils.getDropDownFieldDecoration(context,
                              labelText: AppLocalizations.of(context)
                                  .translate("vehicle_insurance_company")),
                      onChanged: (val) => vehicleModel.vehicleInsurance = val,
                      selectedItem: vehicleModel.vehicleInsurance,
                      autoFocusSearchBox: true,
                      onFind: (val) async {
                        return await OptionAPIs.getOptions("VEHICLEINSURANCES");
                      },
                      itemAsString: (op) => op.label,
                      // validator: (val) {
                      //   if (val == null) {
                      //     return AppLocalizations.of(context)
                      //         .translate("select_vehicle_insurance_company");
                      //   }
                      //   return null;
                      // },
                      onSaved: (val) => vehicleModel.vehicleInsurance = val,
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () async {
                        var selectedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                vehicleModel?.insuranceExpiry ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2099));
                        if (selectedDate != null) {
                          vehicleModel.insuranceExpiry = selectedDate;
                          _vieController.text =
                              DateFormat("dd/MM/yyyy").format(selectedDate);
                        }
                      },
                      child: AbsorbPointer(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  controller: _vieController,
                                  autofocus: false,
                                  // validator: (val) {
                                  //   if (val.isEmptyOrNull) {
                                  //     return AppLocalizations.of(context)
                                  //         .translate(
                                  //             "select_vehicle_insurance_expiry");
                                  //   }
                                  //   return null;
                                  // },
                                  decoration:
                                      DecorationUtils.getTextFieldDecoration(
                                    context,
                                    labelText: AppLocalizations.of(context)
                                        .translate("vehicle_insurance_expiry"),
                                    suffixIcon: const Icon(LineAwesomeIcons.calendar,
                                        color: Colors.grey),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      autofocus: false,
                      enabled: widget.vehicleModel == null,
                      textCapitalization: TextCapitalization.characters,
                      // validator: (val) {
                      //   if (val.isEmptyOrNull) {
                      //     return AppLocalizations.of(context)
                      //         .translate("enter_vehicle_rc_number");
                      //   }
                      //   return null;
                      // },
                      initialValue: vehicleModel.vehicleRc,
                      onSaved: (val) => vehicleModel.vehicleRc = val,
                      decoration: DecorationUtils.getTextFieldDecoration(
                        context,
                        labelText: AppLocalizations.of(context)
                            .translate("vehicle_rc_number"),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownSearch<OptionModel>(
                      emptyBuilder: (context) {
                        return const EmptyView();
                      },
                      showSearchBox: true,
                      showSelectedItem: true,
                      enabled: widget.vehicleModel == null,
                      compareFn: (op1, op2) => op1?.id == op2?.id,
                      mode: Mode.BOTTOM_SHEET,
                      popupTitle: Padding(
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Text(AppLocalizations.of(context)
                              .translate("vehicle_type"))),
                      dropdownSearchDecoration:
                          DecorationUtils.getDropDownFieldDecoration(context,
                              labelText: AppLocalizations.of(context)
                                  .translate("vehicle_type")),
                      onChanged: (val) => vehicleModel.vehicleType = val,
                      selectedItem: vehicleModel.vehicleType,
                      autoFocusSearchBox: true,
                      onFind: (val) async {
                        List<OptionModel> vehicleTypes =
                            await OptionAPIs.getOptions("VEHICLETYPE");
                        vehicleTypes.removeWhere((element) =>
                            element.label.toLowerCase().contains("on foot"));
                        return vehicleTypes;
                      },
                      itemAsString: (op) => op.label,
                      validator: (val) {
                        if (val == null) {
                          return AppLocalizations.of(context)
                              .translate("select_vehicle_type");
                        }
                        return null;
                      },
                      onSaved: (val) => vehicleModel.vehicleType = val,
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        setState(() {
                          vehicleModel?.containsMaterial =
                              !(vehicleModel?.containsMaterial ?? false);
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: Checkbox(
                                value: vehicleModel?.containsMaterial ?? false,
                                onChanged: (val) {
                                  setState(() {
                                    vehicleModel?.containsMaterial = val;
                                  });
                                }),
                          ),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)
                              .translate("contains_material?")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (vehicleModel.rcImage != null ||
                                !vehicleModel.vehicleRcImage.isEmptyOrNull)
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: !(vehicleModel?.vehicleRcImage
                                                ?.isEmptyOrNull ??
                                            true)
                                        ? ImageUtils.loadImage(
                                            FileContainerAPIs.getFileURL(
                                                APIConstants
                                                    .VEHICLE_INSURANCE_IMAGE_CONTAINER,
                                                vehicleModel?.vehicleRcImage),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3)
                                        : Image.file(vehicleModel?.rcImage,
                                            width: MediaQuery.of(context).size.width / 3,
                                            height: MediaQuery.of(context).size.width / 3),
                                  ),
                                  InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        setState(() {
                                          vehicleModel?.rcImage = null;
                                          vehicleModel?.vehicleRcImage = "";
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                              )
                                            ]),
                                        child: const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.close,
                                              size: 20, color: Colors.black),
                                        ),
                                      )),
                                ],
                              )
                            : InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  ImageUtils.pickAndCropImage(
                                          ImageSource.camera)
                                      .then((value) {
                                    setState(() {
                                      vehicleModel.rcImage = value;
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(LineAwesomeIcons.camera,
                                          color: ColorConstants.PRIMARY),
                                      const SizedBox(width: 8),
                                      Text(
                                          AppLocalizations.of(context)
                                              .translate("upload_rc"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  color:
                                                      ColorConstants.PRIMARY))
                                    ],
                                  ),
                                ),
                              ),
                        (vehicleModel?.insuranceImage != null ||
                                !vehicleModel
                                    .vehicleInsuranceImage.isEmptyOrNull)
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: !(vehicleModel?.vehicleInsuranceImage
                                                ?.isEmptyOrNull ??
                                            true)
                                        ? ImageUtils.loadImage(
                                            FileContainerAPIs.getFileURL(
                                                APIConstants
                                                    .VEHICLE_INSURANCE_IMAGE_CONTAINER,
                                                vehicleModel
                                                    ?.vehicleInsuranceImage),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            height:
                                                MediaQuery.of(context).size.width /
                                                    3)
                                        : Image.file(vehicleModel?.insuranceImage,
                                            width: MediaQuery.of(context).size.width / 3,
                                            height: MediaQuery.of(context).size.width / 3),
                                  ),
                                  InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        setState(() {
                                          vehicleModel?.insuranceImage = null;
                                          vehicleModel?.vehicleInsuranceImage =
                                              "";
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                              )
                                            ]),
                                        child: const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white,
                                          // ignore: unnecessary_const
                                          child: const Icon(Icons.close,
                                              size: 20, color: Colors.black),
                                        ),
                                      )),
                                ],
                              )
                            : InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  ImageUtils.pickAndCropImage(
                                          ImageSource.camera)
                                      .then((value) {
                                    setState(() {
                                      vehicleModel.insuranceImage = value;
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(LineAwesomeIcons.camera,
                                          color: ColorConstants.PRIMARY),
                                      const SizedBox(width: 8),
                                      Text(
                                          AppLocalizations.of(context)
                                              .translate("upload_insurance"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  color:
                                                      ColorConstants.PRIMARY))
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }),
        bottomNavigationBar: Observer(builder: (_) {
          return VisibilityExtended(
            visible: !(widget.vehicleStore?.showProgress ?? false),
            child: BottomButtonsContainer(
              children: [
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('cancel')),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                GradientButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      var inResp = await widget.vehicleStore
                          .vehicleIn(context, vehicleModel);
                      if (inResp != null) {
                        DialogViews.showSuccessBottomSheet(
                          context,
                          detailText: AppLocalizations.of(context)
                              .translate("vehicle_in_successful"),
                          successText:
                              (vehicleModel?.containsMaterial ?? false) ||
                                      (inResp.personHaveMaterial ?? false) ||
                                      (inResp.cameForMaterialOut ?? false)
                                  ? AppLocalizations.of(context).translate(
                                      (inResp.cameForMaterialOut ?? false)
                                          ? "material_in_out"
                                          : "material_in_out")
                                  : null,
                          onSuccess:
                              (vehicleModel?.containsMaterial ?? false) ||
                                      (inResp.personHaveMaterial ?? false) ||
                                      (inResp.cameForMaterialOut ?? false)
                                  ? () {
                                      Navigator.of(context).pushNamed(
                                          (inResp.cameForMaterialOut ?? false)
                                              ? "/admin/gms/material/out"
                                              : "/admin/gms/material/in",
                                          arguments: {
                                            "mobileNo": widget.mobileNo,
                                            "vehicleNo": widget.vehicleNo,
                                          });
                                    }
                                  : null,
                        );
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context).translate("submit")),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
