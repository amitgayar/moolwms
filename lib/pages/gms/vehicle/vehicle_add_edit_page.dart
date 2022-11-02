import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/gms/vehicle/model.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/my_image_cropper.dart';

class VehicleAddEditPage extends StatefulWidget {
  final MobileNoModel? mobileNo;
  final String? vehicleNo;
  final String? purpose;
  final VehicleModel? vehicleModel;
  final PersonModel? personModel;
  final VehicleStore? vehicleStore;

 const VehicleAddEditPage({super.key, this.mobileNo, this.vehicleModel, this.vehicleNo, this.vehicleStore, this.personModel, this.purpose});

  @override
  VehicleAddEditPageState createState() => VehicleAddEditPageState();
}



class VehicleAddEditPageState extends State<VehicleAddEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _vieController = TextEditingController();
  VehicleModel? vehicleModel = VehicleModel();
  @override
  void initState() {
    super.initState();
    if (widget.vehicleModel != null) {
      vehicleModel = widget.vehicleModel!;
      if (vehicleModel?.insuranceExpiry != null) {
        _vieController.text =
            DateFormat("dd/MM/yyyy").format(vehicleModel?.insuranceExpiry);
      }
    } else {
      vehicleModel?.vehicleNumber = widget.vehicleNo;
    }
    vehicleModel?.personId = widget.personModel?.id;
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
            title: Text((
                widget.vehicleModel == null ? "add_vehicle" : "edit_vehicle"))),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: vehicleModel?.ownerName,
                  onSaved: (val) => vehicleModel?.ownerName = val,
                  enabled: widget.vehicleModel == null,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return
                        ("enter_owner_name");
                    }
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText:
                    ("owner_name"),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: vehicleModel?.vehicleNumber,
                  enabled: widget.vehicleNo?.isEmpty,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return
                        ("enter_vehicle_number");
                    }
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText:
                    ("vehicle_number"),
                  ),
                ),
                const SizedBox(height: 24),
                DropdownSearch<OptionModel?>(

                  // showSearchBox: true,
                  // showSelectedItem: true,
                  enabled: widget.vehicleModel == null,
                  compareFn: (op1, op2) => op1?.id == op2?.id,
                  // mode: Mode.BOTTOM_SHEET,
                  // popupTitle: Padding(
                  //     padding: const EdgeInsets.only(top: 12, left: 12),
                  //     child: Text(
                  //         ("select_owner_type"))),
                  // dropdownSearchDecoration:
                  // DecorationUtils.getDropDownFieldDecoration(context,
                  //     labelText:
                  //     ("owner_type")),
                  onChanged: (val) => vehicleModel?.ownerType = val,
                  selectedItem: vehicleModel?.ownerType,
                  // autoFocusSearchBox: true,
                  // onFind: (val) async {
                  //   return await OptionAPIs.getOptions("ownerType");
                  // },
                  itemAsString: (op) => op!.label!,
                  // validator: (val) {
                  //   if (val == null) {
                  //     return
                  //         ("select_person_type");
                  //   }
                  //   return null;
                  // },
                  onSaved: (val) => vehicleModel?.ownerType = val,
                ),
                const SizedBox(height: 24),
                DropdownSearch<OptionModel?>(

                  // showSearchBox: true,
                  // showSelectedItem: true,
                  compareFn: (op1, op2) => op1?.id == op2?.id,
                  // mode: Mode.BOTTOM_SHEET,
                  // popupTitle: Container(
                  //     margin: const EdgeInsets.only(top: 18),
                  //     padding: const EdgeInsets.only(top: 12, left: 12),
                  //     child: Text(("vehicle_insurance_company"))),
                  // dropdownSearchDecoration: DecorationUtils.getDropDownFieldDecoration(context,
                  //     labelText: ("vehicle_insurance_company")),
                  onChanged: (val) => vehicleModel?.vehicleInsurance = val,
                  selectedItem: vehicleModel?.vehicleInsurance,
                  // autoFocusSearchBox: true,
                  // onFind: (val) async {
                  //   return await OptionAPIs.getOptions("vehicleInsurance");
                  // },
                  itemAsString: (op) => op!.label!,
                  // validator: (val) {
                  //   if (val == null) {
                  //     return
                  //         ("select_vehicle_insurance_company");
                  //   }
                  //   return null;
                  // },
                  onSaved: (val) => vehicleModel?.vehicleInsurance = val,
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
                      vehicleModel?.insuranceExpiry = selectedDate;
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
                              //     return
                              //         (
                              //             "select_vehicle_insurance_expiry");
                              //   }
                              //   return null;
                              // },
                              decoration:
                              DecorationUtils.getTextFieldDecoration(
                                labelText:
                                ("vehicle_insurance_expiry"),
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
                  //     return
                  //         ("enter_vehicle_rc_number");
                  //   }
                  //   return null;
                  // },
                  initialValue: vehicleModel?.vehicleRc,
                  onSaved: (val) => vehicleModel?.vehicleRc = val,
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText:
                    ("vehicle_rc_number"),
                  ),
                ),
                const SizedBox(height: 24),
                DropdownSearch<OptionModel?>(

                  // showSearchBox: true,
                  // showSelectedItem: true,
                  enabled: widget.vehicleModel == null,
                  compareFn: (op1, op2) => op1?.id == op2?.id,
                  // mode: Mode.BOTTOM_SHEET,
                  // popupTitle: Padding(
                  //     padding: const EdgeInsets.only(top: 12, left: 12),
                  //     child: Text(
                  //         ("vehicle_type"))),
                  // dropdownSearchDecoration: DecorationUtils.getDropDownFieldDecoration(
                  //     labelText:
                  //     ("vehicle_type")),
                  onChanged: (val) => vehicleModel?.vehicleType = val,
                  selectedItem: vehicleModel?.vehicleType,
                  // autoFocusSearchBox: true,
                  // onFind: (val) async {
                  //   List<OptionModel> vehicleTypes =
                  //   await OptionAPIs.getOptions("vehicleType");
                  //   vehicleTypes.removeWhere((element) =>
                  //       element.label.toLowerCase().contains("on foot"));
                  //   return vehicleTypes;
                  // },
                  itemAsString: (op) => op!.label!,
                  validator: (val) {
                    if (val == null) {
                      return
                        ("select_vehicle_type");
                    }
                    return null;
                  },
                  onSaved: (val) => vehicleModel?.vehicleType = val,
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
                      const Text(
                          ("contains_material?")),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (vehicleModel?.rcImage != null ||
                        !vehicleModel?.vehicleRcImage.isEmptyOrNull)
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
                                  APIConstants.VEHICLE_INSURANCE_IMAGE_CONTAINER,
                                  vehicleModel?.vehicleRcImage),
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3)
                              : Image.file(vehicleModel!.rcImage!,
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
                            // todo:
                            // vehicleModel?.rcImage = value;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(LineAwesomeIcons.camera,
                                color: ColorConstants.primary),
                            const SizedBox(width: 8),
                            Text(

                                ("upload_rc"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                    color:
                                    ColorConstants.primary))
                          ],
                        ),
                      ),
                    ),
                    (vehicleModel?.insuranceImage != null ||
                        !vehicleModel?.vehicleInsuranceImage.isEmptyOrNull)
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
                            vehicleModel?.insuranceImage = value;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(LineAwesomeIcons.camera,
                                color: ColorConstants.primary),
                            const SizedBox(width: 8),
                            Text(

                                ("upload_insurance"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                    color:
                                    ColorConstants.primary))
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
        bottomNavigationBar: BottomButtonsContainer(
          children: [
            TextButton(
              child: const Text(('cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  var inResp = await widget.vehicleStore!
                      .vehicleIn(context, vehicleModel!);
                  if (inResp != null) {
                    DialogViews.showSuccessBottomSheet(
                      context,
                      detailText:
                      ("vehicle_in_successful"),
                      successText:
                      (vehicleModel?.containsMaterial ?? false) ||
                          (inResp.personHaveMaterial ?? false) ||
                          (inResp.cameForMaterialOut ?? false)
                          ? (
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
              child: const Text(("submit")),
            ),
          ],
        ),
      ),
    );
  }
}


