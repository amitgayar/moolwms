import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/constants/APIConstants.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/MoolwmsOrgModel.dart';
import 'package:moolwms/pages/stock/apiHit/apiHit.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/utils/Utils.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/custom_form_fields.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:toast/toast.dart';

class StorageMaterialAddPage extends StatefulWidget {
  StorageMaterialModel storageMaterialModel;
  MoolwmsOrgModel moolwmsOrgModel;

  StorageMaterialAddPage(dynamic args) {
    if (args is Map) {
      storageMaterialModel = args['item'];
      moolwmsOrgModel = args['customer'];
    }
  }

  @override
  _StorageMaterialAddPageState createState() => _StorageMaterialAddPageState();
}

class _StorageMaterialAddPageState extends State<StorageMaterialAddPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StorageMaterialModel storageMaterialModel;

  @override
  void initState() {
    super.initState();
    if (widget.storageMaterialModel != null) {
      storageMaterialModel = widget.storageMaterialModel;
    } else {
      storageMaterialModel = StorageMaterialModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(AppLocalizations.of(context).translate("storage_material"))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: storageMaterialModel.grn,
                onSaved: (val) => storageMaterialModel.grn = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context).translate("enter_grn");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("grn"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: storageMaterialModel.invoiceOrStn,
                onSaved: (val) => storageMaterialModel.invoiceOrStn = val,
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_invoice_number");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("invoice_number"),
                ),
              ),
              const SizedBox(height: 24),
              // TextFormField(
              //   initialValue: storageMaterialModel.stnChallanNo,
              //   onSaved: (val) => storageMaterialModel.stnChallanNo = val,
              //   validator: (val) {
              //     if (val.isEmpty) {
              //       return AppLocalizations.of(context)
              //           .translate("enter_stn_challan_number");
              //     }
              //     return null;
              //   },
              //   decoration: DecorationUtils.getTextFieldDecoration(
              //     context,
              //     labelText: AppLocalizations.of(context)
              //         .translate("stn_challan_number"),
              //   ),
              // ),
              // SizedBox(height: 24),
              TextFormField(
                initialValue: storageMaterialModel?.totalTonnage?.toString(),
                onSaved: (val) =>
                    storageMaterialModel.totalTonnage = double.parse(val),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate("enter_total_tonnage");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText:
                      AppLocalizations.of(context).translate("total_tonnage"),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: storageMaterialModel.source,
                onSaved: (val) => storageMaterialModel.source = val,
                validator: (val) {
                  if (val.isEmpty) {
                    // return AppLocalizations.of(context)
                    //     .translate("enter_source");
                  }
                  return null;
                },
                decoration: DecorationUtils.getTextFieldDecoration(
                  context,
                  labelText: AppLocalizations.of(context).translate("source"),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: (storageMaterialModel.invoiceFile!= null ||
                            !storageMaterialModel.invoiceImage.isEmptyOrNull)
                        ? Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: !(storageMaterialModel
                                            ?.invoiceImage?.isEmptyOrNull ??
                                        true)
                                    ? ImageUtils.loadImage(
                                        FileContainerAPIs.getFileURL(
                                            APIConstants
                                                .MATERIAL_INVOICE_CONTAINER,
                                            storageMaterialModel?.invoiceImage),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4)
                                    : Image.file(
                                        storageMaterialModel?.invoiceFile,
                                        width:
                                            MediaQuery.of(context).size.width / 4,
                                        height: MediaQuery.of(context).size.width / 4),
                              ),
                              InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      storageMaterialModel?.invoiceFile = null;
                                      storageMaterialModel?.invoiceImage = "";
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
                        : InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ImageUtils.pickAndCropImage(ImageSource.camera)
                                  .then((value) {
                                setState(() {
                                  storageMaterialModel?.invoiceFile = value;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(LineAwesomeIcons.camera,
                                      color: ColorConstants.PRIMARY),
                                  const SizedBox(height: 8),
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate("upload_invoice"),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: ColorConstants.PRIMARY))
                                ],
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    child: (storageMaterialModel?.ewaybillFile != null ||
                            !storageMaterialModel.ewayBillImage.isEmptyOrNull)
                        ? Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: !(storageMaterialModel
                                            ?.ewayBillImage?.isEmptyOrNull ??
                                        true)
                                    ? ImageUtils.loadImage(
                                        FileContainerAPIs.getFileURL(
                                            APIConstants
                                                .MATERIAL_EWAYBILL_CONTAINER,
                                            storageMaterialModel
                                                ?.ewayBillImage),
                                        width: MediaQuery.of(context).size.width /
                                            4,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4)
                                    : Image.file(
                                        storageMaterialModel?.ewaybillFile,
                                        width:
                                            MediaQuery.of(context).size.width / 4,
                                        height: MediaQuery.of(context).size.width / 4),
                              ),
                              InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      storageMaterialModel?.ewaybillFile = null;
                                      storageMaterialModel?.ewayBillImage = "";
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
                        : InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ImageUtils.pickAndCropImage(ImageSource.camera)
                                  .then((value) {
                                setState(() {
                                  storageMaterialModel.ewaybillFile = value;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(LineAwesomeIcons.camera,
                                      color: ColorConstants.PRIMARY),
                                  const SizedBox(height: 8),
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate("upload_ewaybill"),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: ColorConstants.PRIMARY))
                                ],
                              ),
                            ),
                          ),
                  ),
                 
                ],
              ),
              const SizedBox(height: 24),
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
                if (!(storageMaterialModel?.invoiceFile != null ||
                    !storageMaterialModel.invoiceImage.isEmptyOrNull)) {
                  Toast.show(
                      AppLocalizations.of(context)
                          .translate("please_upload_invoice"),
                      context);
                      return;
                }
                
                // if (!(storageMaterialModel?.ewaybillFile != null ||
                //     !storageMaterialModel.ewayBillImage.isEmptyOrNull)) {
                //   Toast.show(
                //       AppLocalizations.of(context)
                //           .translate("please_upload_ewaybill"),
                //       context);
                //       return;
                // }

                Navigator.of(context).pushNamed(
                    '/admin/gms/material/storage_material/items',
                    arguments: {
                      "storageMaterial": storageMaterialModel,
                      "customer": widget.moolwmsOrgModel,
                    }).then((value) {
                  if (value is List<StorageMaterialItemModel>) {
                    storageMaterialModel.items = value;
                    Navigator.of(context).pop(storageMaterialModel);
                  }
                });
              }
            },
            child: Text(AppLocalizations.of(context).translate("next")),
          ),
        ],
      ),
    );
  }
}
