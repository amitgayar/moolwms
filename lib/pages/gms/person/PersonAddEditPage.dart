import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/constants/APIConstants.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/MobileNoModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/model/AadhaarDataModel.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Utils.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/EmptyView.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';
import 'package:moolwms/widgets/searchable_dropdown/dropdown_search.dart';
import 'package:moolwms/model/AddressModel.dart';

class PersonAddEditPage extends StatefulWidget {
  MobileNoModel mobileNo = MobileNoModel();
  String purpose;
  PersonModel personModel;
  PersonStore personStore;

  PersonAddEditPage(dynamic args) {
    if (args is Map) {
      mobileNo = args['mobileNo'];
      purpose = args['purpose'];
      personModel = args['person'];
      personStore = args['store'] ?? PersonStore();
    }
  }

  @override
  _PersonAddEditPageState createState() => _PersonAddEditPageState();
}

class _PersonAddEditPageState extends State<PersonAddEditPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dobController = TextEditingController();
  PersonModel personModel = PersonModel();

  @override
  void initState() {
    super.initState();
    if (widget.personModel != null) {
      personModel = widget.personModel;
      personModel.address ??= AddressModel();
      if (personModel?.dob != null) {
        _dobController.text = DateFormat("dd/MM/yyyy").format(personModel.dob);
      }
    } else {
      personModel.mobileNo = widget.mobileNo;
    }
  }
  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate(
              widget.personModel != null ? "edit_person" : "add_person"),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed('/aadhaarscan')
                .then((adata) async {
              if (adata != null) {
                AadhaarDataModel adm = adata;
                personModel?.fullName = adm.name;

                personModel?.gender =
                    await OptionAPIs.getOptionByValue("GENDER", adm.gender);
                personModel?.dob = adm.dob;
                _dobController.text =
                    DateFormat("dd/MM/yyyy").format(personModel?.dob);
                personModel?.address ??= AddressModel();
                personModel?.address?.addressLine1 = adm.address;
                personModel?.address?.city = adm.city;
                personModel?.address?.pincode = int.tryParse(adm.pincode);

                setState(() {});
              }
            }),
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      body: Observer(builder: (_) {
        return ProgressContainerView(
          isProgressRunning: widget.personStore?.showProgress ?? false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: personModel.fullName,
                    onSaved: (val) => personModel.fullName = val,
                    //enabled: widget.personModel == null,
                    validator: (val) {
                      if (val.isEmptyOrNull) {
                        return AppLocalizations.of(context)
                            .translate("enter_full_name");
                      }
                      return null;
                    },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      labelText:
                          AppLocalizations.of(context).translate("full_name"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: personModel.fathersName,
                    onSaved: (val) => personModel.fathersName = val,
                    //enabled: widget.personModel == null,
                    // validator: (val) {
                    //   if (val.isEmptyOrNull) {
                    //     return AppLocalizations.of(context)
                    //         .translate("enter_father_name");
                    //   }
                    //   return null;
                    // },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      labelText:
                          AppLocalizations.of(context).translate("father_name"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownSearch<OptionModel>(
                          emptyBuilder: (context) {
                            return const EmptyView();
                          },
                          showSearchBox: true,
                          showSelectedItem: true,
                          //enabled: widget.personModel == null,
                          compareFn: (op1, op2) => op1?.id == op2?.id,
                          mode: Mode.BOTTOM_SHEET,
                          popupTitle: Container(
                              margin: const EdgeInsets.only(top: 18),
                              padding: const EdgeInsets.only(top: 12, left: 12),
                              child: Text(AppLocalizations.of(context)
                                  .translate("select_gender"))),
                          dropdownSearchDecoration:
                              DecorationUtils.getDropDownFieldDecoration(
                                  context,
                                  labelText: AppLocalizations.of(context)
                                      .translate("gender")),
                          onChanged: (val) => personModel.gender = val,
                          selectedItem: personModel?.gender,
                          autoFocusSearchBox: true,
                          onFind: (val) async {
                            return await OptionAPIs.getOptions("GENDER");
                          },
                          itemAsString: (op) => op.label ?? "",
                          // validator: (val) {
                          //   if (val == null) {
                          //     return AppLocalizations.of(context)
                          //         .translate("select_gender");
                          //   }
                          //   return null;
                          // },
                          onSaved: (val) => personModel.gender = val,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            var selectedDate = await showDatePicker(
                                context: context,
                                initialDate: personModel?.dob ??
                                    DateTime(
                                        DateTime.now().year - 18,
                                        DateTime.now().month,
                                        DateTime.now().day),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(DateTime.now().year - 18,
                                    DateTime.now().month, DateTime.now().day));
                            if (selectedDate != null) {
                              personModel.dob = selectedDate;
                              _dobController.text =
                                  DateFormat("dd/MM/yyyy").format(selectedDate);
                            }
                          },
                          child: AbsorbPointer(
                            child: AbsorbPointer(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                        controller: _dobController,
                                        //enabled: widget.personModel == null,
                                        autofocus: false,
                                        validator: (val) {
                                          // if (val.isEmptyOrNull) {
                                          //   return AppLocalizations.of(context)
                                          //       .translate(
                                          //           "select_date_of_birth");
                                          // }
                                          // return null;
                                        },
                                        decoration: DecorationUtils
                                            .getTextFieldDecoration(
                                          context,
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .translate("date_of_birth"),
                                          suffixIcon: const Icon(
                                              LineAwesomeIcons.calendar,
                                              color: Colors.grey),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: personModel?.address?.addressLine1,
                    onSaved: (val) => personModel.address.addressLine1 = val,
                    //enabled: widget.personModel == null,
                    validator: (val) {
                      if (val.isEmptyOrNull) {
                        return AppLocalizations.of(context)
                            .translate("enter_address");
                      }
                      return null;
                    },
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      labelText:
                          AppLocalizations.of(context).translate("address"),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: personModel?.address?.city,
                          onSaved: (val) => personModel.address.city = val,
                          //enabled: widget.personModel == null,
                          validator: (val) {
                            if (val.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate("enter_city");
                            }
                            return null;
                          },
                          decoration: DecorationUtils.getTextFieldDecoration(
                            context,
                            labelText:
                                AppLocalizations.of(context).translate("city"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: DropdownSearch<StateModel>(
                          emptyBuilder: (context) {
                            return const EmptyView();
                          },
                          showSearchBox: true,
                          showSelectedItem: true,
                          //enabled: widget.personModel == null,
                          compareFn: (op1, op2) => op1?.id == op2?.id,
                          mode: Mode.BOTTOM_SHEET,
                          popupTitle: Container(
                              margin: const EdgeInsets.only(top: 18),
                              padding: const EdgeInsets.only(top: 12, left: 12),
                              child: Text(AppLocalizations.of(context)
                                  .translate("select_state"))),
                          dropdownSearchDecoration:
                              DecorationUtils.getDropDownFieldDecoration(
                                  context,
                                  labelText: AppLocalizations.of(context)
                                      .translate("state")),
                          onChanged: (val) => personModel.address.state = val,
                          selectedItem: personModel?.address?.state,
                          autoFocusSearchBox: true,
                          onFind: (val) async {
                            return await OptionAPIs.getStates();
                          },
                          itemAsString: (op) => op.name,
                          validator: (val) {
                            if (val == null) {
                              return AppLocalizations.of(context)
                                  .translate("select_state");
                            }
                            return null;
                          },
                          onSaved: (val) => personModel.address.state = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    autofocus: false,
                    //enabled: widget.personModel == null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    validator: (val) {
                      if (val.isEmptyOrNull) {
                        return AppLocalizations.of(context)
                            .translate("enter_pincode");
                      }
                      return null;
                    },
                    initialValue: personModel?.address?.pincode?.toString(),
                    onSaved: (val) =>
                        personModel.address.pincode = int.tryParse(val),
                    decoration: DecorationUtils.getTextFieldDecoration(
                      context,
                      counterText: "",
                      labelText:
                          AppLocalizations.of(context).translate("pincode"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownSearch<OptionModel>(
                    emptyBuilder: (context) {
                      return const EmptyView();
                    },
                    showSearchBox: true,
                    showSelectedItem: true,
                    // enabled: widget.personModel == null,
                    compareFn: (op1, op2) => op1?.id == op2?.id,
                    mode: Mode.BOTTOM_SHEET,
                    popupTitle: Container(
                        margin: const EdgeInsets.only(top: 18),
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Text(AppLocalizations.of(context)
                            .translate("select_id_type"))),
                    dropdownSearchDecoration:
                        DecorationUtils.getDropDownFieldDecoration(context,
                            labelText: AppLocalizations.of(context)
                                .translate("id_type")),
                    onChanged: (val) => personModel.govtIdType = val,
                    selectedItem: personModel.govtIdType,
                    autoFocusSearchBox: true,
                    onFind: (val) async {
                      return await OptionAPIs.getOptions("GOVTIDTYPE");
                    },
                    itemAsString: (op) => op.label,
                    validator: (val) {
                      if (val == null) {
                        return AppLocalizations.of(context)
                            .translate("select_id_type");
                      }
                      return null;
                    },
                    onSaved: (val) => personModel.govtIdType = val,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: personModel.govtIdNumber,
                    onSaved: (val) => personModel.govtIdNumber = val,
                    // enabled: widget.personModel == null,
                    keyboardType: personModel?.govtIdType?.value == 1
                        ? TextInputType.number
                        : null,
                    inputFormatters: personModel?.govtIdType?.value == 1
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [],
                    maxLength: personModel?.govtIdType?.value == 1 ? 12 : null,
                    validator: (val) {
                      if (val.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate("enter_id_number");
                      }
                      return null;
                    },
                    decoration: DecorationUtils.getTextFieldDecoration(context,
                        counterText: "",
                        labelText:
                            AppLocalizations.of(context).translate("id_number"),
                        suffixIcon: (personModel?.imageFile != null ||
                                !personModel.image.isEmptyOrNull)
                            ? null
                            : IconButton(
                                onPressed: () {
                                  ImageUtils.pickAndCropImage(
                                          ImageSource.camera)
                                      .then((value) {
                                    setState(() {
                                      personModel.imageFile = value;
                                    });
                                  });
                                },
                                icon: const Icon(LineAwesomeIcons.camera,
                                    color: ColorConstants.PRIMARY),
                              )),
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
                    // hint: "enter data",
                    popupTitle: Container(
                        margin: const EdgeInsets.only(top: 18),
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Text(AppLocalizations.of(context)
                            .translate("select_person_type"))),
                    dropdownSearchDecoration:
                        DecorationUtils.getDropDownFieldDecoration(context,
                            labelText: AppLocalizations.of(context)
                                .translate("person_type")),
                    onChanged: (val) => personModel.personType = val,
                    selectedItem: personModel.personType,
                    autoFocusSearchBox: true,
                    onFind: (val) async {
                      List<OptionModel> options =
                          await OptionAPIs.getOptions("PERSONTYPE");
                      options.removeWhere((element) =>
                          element.value == 1 ||
                          element.value == 6 ||
                          element.value == 8);
                      return options;
                    },
                    itemAsString: (op) => op.label,
                    validator: (val) {
                      if (val == null) {
                        return AppLocalizations.of(context)
                            .translate("select_person_type");
                      }
                      return null;
                    },
                    onSaved: (val) => personModel.personType = val,
                  ),
                  const SizedBox(height: 18),
                  (personModel?.imageFile != null ||
                          !personModel.image.isEmptyOrNull)
                      ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: !(personModel?.image?.isEmptyOrNull ??
                                      true)
                                  ? ImageUtils.loadImage(
                                      FileContainerAPIs.getFileURL(
                                          APIConstants.PERSON_IMAGE_CONTAINER,
                                          personModel?.image),
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.width / 3)
                                  : Image.file(personModel?.imageFile,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.width /
                                              3),
                            ),
                            InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  setState(() {
                                    personModel?.imageFile = null;
                                    personModel?.image = "";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Colors.grey.withOpacity(0.3),
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
                      : Container(),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        personModel.hasVehicle =
                            !(personModel.hasVehicle ?? false);
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                              value: personModel?.hasVehicle ?? false,
                              onChanged: (v) {
                                setState(() {
                                  personModel.hasVehicle = v;
                                });
                              }),
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)
                            .translate("do_you_have_a_vehicle"))
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       personModel.hasMaterial =
                  //           !(personModel.hasMaterial ?? false);
                  //     });
                  //   },
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       SizedBox(
                  //         width: 24,
                  //         height: 24,
                  //         child: Checkbox(
                  //             value: personModel?.hasMaterial ?? false,
                  //             onChanged: (v) {
                  //               setState(() {
                  //                 personModel.hasMaterial = v;
                  //               });
                  //             }),
                  //       ),
                  //       SizedBox(width: 8),
                  //       Text(AppLocalizations.of(context)
                  //           .translate("do_you_have_material?"))
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 12),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       personModel.cameForMaterialOut =
                  //           !(personModel.cameForMaterialOut ?? false);
                  //     });
                  //   },
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       SizedBox(
                  //         width: 24,
                  //         height: 24,
                  //         child: Checkbox(
                  //             value: personModel?.cameForMaterialOut ?? false,
                  //             onChanged: (v) {
                  //               setState(() {
                  //                 personModel.cameForMaterialOut = v;
                  //               });
                  //             }),
                  //       ),
                  //       SizedBox(width: 8),
                  //       Text(AppLocalizations.of(context)
                  //           .translate("have_you_came_for_material_out?"))
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Observer(builder: (_) {
        return VisibilityExtended(
          visible: !(widget.personStore?.showProgress ?? false),
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
                    logPrint.w('personModel.personType.value : ${personModel.personType.value}');
                    // TODO: DO ACTION
                    switch (personModel.personType.value) {
                      case 1:
                        {
                          // EMPLOYEE : SUBMIT DIRECTLY
                          if (personModel != null) {
                            var inResp = await widget.personStore
                                .personIn(context, personModel);
                            if (inResp != null) {
                              DialogViews.showSuccessBottomSheet(
                                context,
                                detailText: AppLocalizations.of(context)
                                    .translate("person_in_successful"),
                                successText: (personModel?.hasVehicle ?? false)
                                    ? AppLocalizations.of(context)
                                        .translate("vehicle_in")
                                    : null,
                                onSuccess: (personModel?.hasVehicle ?? false)
                                    ? () {
                                        Navigator.of(context).pushNamed(
                                            "/admin/gms/vehicle/in",
                                            arguments: {
                                              "mobileNo": personModel.mobileNo,
                                            });
                                      }
                                    : null,
                              );
                            }
                          }
                          break;
                        }
                      case 2:
                        {
                          // LABOUR
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/labour/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                      case 3:
                        {
                          // TRUCK DRIVER
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/truck_driver/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                      case 4:
                        {
                          // CUSTOMER
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/customer/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                      case 5:
                        {
                          // VISITOR
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/visitor/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                      case 6:
                        {
                          // CONTRACTED EMPLOYEE
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/contracted_employee/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                      case 7:
                        {
                          // SUPPLIER
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/supplier/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                      case 8:
                        {
                          // INTERN
                          await Navigator.of(context).pushNamed(
                              '/admin/gms/intern/detail',
                              arguments: {
                                'person': personModel,
                                'store': widget.personStore
                              });
                          break;
                        }
                    }
                  }
                },
                child: Text(AppLocalizations.of(context).translate(
                    personModel?.personType?.value == 1 ? "next" : "submit")),
              ),
            ],
          ),
        );
      }),
    );
  }
}
