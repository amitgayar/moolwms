import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/constants/design_constants/my_decoration.dart';
import 'package:moolwms/pages/indent/apis/indent_apis.dart';
import 'package:moolwms/pages/indent/model/indent_list_model.dart';
import 'package:moolwms/utils/extensions.dart';
import 'package:moolwms/widgets/my_toast.dart';
import 'package:moolwms/utils/extensions.dart' show DateTimeTZExtensions;
import 'package:moolwms/utils/dev_utils.dart';
import 'package:moolwms/widgets/circular_indicator.dart';
import 'package:moolwms/widgets/my_image_cropper.dart';
import 'package:shimmer/shimmer.dart';

class IndentAddPage extends StatefulWidget {
  const IndentAddPage(this.indentListItem, {Key? key}) : super(key: key);
  final IndentListModelDataIndentList? indentListItem;

  @override
  IndentAddPageState createState() => IndentAddPageState();
}

class IndentAddPageState extends State<IndentAddPage> {
  /// file variables
  String eWayPath = "";
  String invoicePath = "";
  String otherDocPath = "";
  late CroppedFile getEWayBill;
  late CroppedFile getInvoiceBill;
  late CroppedFile getOtherDocBill;
  String? eWayURLPath = "";
  String? invoiceURLPath = "";
  String? otherURLDocPath = "";

  final TextEditingController driverName = TextEditingController();
  final TextEditingController driverMobileNumber = TextEditingController();
  final TextEditingController vehicleNumber = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController dopController = TextEditingController();

  String? serviceSlot = "";
  String? otherDocUrl = "";
  String? invoiceDocUrl = "";
  String? eWayDocUrl = "";

  var timeSlotList = const [
    "12:00 AM - 01:00 AM",
    "01:00 AM - 02:00 AM",
    "02:00 AM - 03:00 AM",
    "03:00 AM - 04:00 AM",
    "04:00 AM - 05:00 AM",
    "05:00 AM - 06:00 AM",
    "06:00 AM - 07:00 AM",
    "08:00 AM - 09:00 AM",
    "09:00 AM - 10:00 AM",
    "11:00 AM - 12:00 AM",
    "12:00 AM - 01:00 PM",
    "01:00 PM - 02:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM",
    "04:00 PM - 05:00 PM",
    "05:00 PM - 06:00 PM",
    "06:00 PM - 07:00 PM",
    "08:00 PM - 09:00 PM",
    "09:00 PM - 10:00 PM",
    "11:00 PM - 12:00 AM",
  ];

  @override
  void initState() {
    super.initState();
    driverName.text = widget.indentListItem?.driverName ?? "";
    driverMobileNumber.text = widget.indentListItem?.driverMobileNumber ?? "";
    vehicleNumber.text = widget.indentListItem?.vehicleNumber ?? "";
    remarks.text = widget.indentListItem?.remarks ?? "";
    var temp = widget.indentListItem?.serviceDate??"";
    dopController.text = temp.length > 10? temp.substring(0,10):temp;
    invoiceURLPath = widget.indentListItem?.invoiceDocUrl;
    eWayURLPath = widget.indentListItem?.ewayDocUrl;
    otherURLDocPath = widget.indentListItem?.otherDocUrl;
  }

  @override
  void dispose() {
    driverName.dispose();
    driverMobileNumber.dispose();
    vehicleNumber.dispose();
    remarks.dispose();
    dopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    logPrint.w("date: ${widget.indentListItem?.serviceDate}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indent Request'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop(widget.indentListItem);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// indent type
                DropdownSearch<String>(
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration:
                          DecorationUtils.getDropDownFieldDecoration(
                    labelText: 'Indent Type * ',
                  )),
                  popupProps: const PopupProps.dialog(),
                  // showSelectedItem: true,
                  // mode: Mode.menu,
                  items: const ["Inward", "Outward"],
                  // popupTitle: Padding(
                  //     padding: EdgeInsets.only(top: 12, left: 12),
                  //     child: Text('Indent Request')),
                  // dropdownSearchDecoration: DecorationUtils.getDropDownFieldDecoration(context,
                  //         labelText: 'Indent Request *'),
                  onChanged: (val) {
                    widget.indentListItem?.requestType = val;
                  },
                  selectedItem: widget.indentListItem?.requestType,
                  // autoFocusSearchBox: true,
                  validator: (val) {
                    if (val != null) {
                      return ("select_relation");
                    }
                    return null;
                  },

                  // onSaved: (val) => relation = val,
                ),
                const SizedBox(height: 36),

                /// indent date
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2099));
                          if (selectedDate != null) {
                            final String formatted =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                            widget.indentListItem?.serviceDate = selectedDate.convertMyDateTZ;
                            dopController.text = formatted;
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                              controller: dopController,
                              autofocus: false,
                              validator: (val) {
                                if ((val ?? "").isEmpty) {
                                  return ("select_production_date");
                                }
                                return null;
                              },
                              decoration:
                                  DecorationUtils.getTextFieldDecoration(
                                labelText: 'Indent Service Date *',
                                suffixIcon: const Icon(
                                    LineAwesomeIcons.calendar,
                                    color: Colors.grey),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                /// vehicle no
                TextFormField(
                  controller: vehicleNumber,
                  maxLength: 15,
                  // initialValue: storageMaterialModel.source,
                  // onSaved: (val) => storageMaterialModel.source = val,
                  validator: (val) {
                    if ((val ?? "").isEmpty) {}
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText: 'Vehicle Number',
                  ),
                ),
                const SizedBox(height: 16),

                /// mobile no
                TextFormField(
                  controller: driverMobileNumber,
                  maxLength: 10,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (val) {
                    if ((val ?? "").isEmpty) {}
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText: 'Mobile Number',
                  ),
                ),
                const SizedBox(height: 16),

                /// time slot
                DropdownSearch<String>(
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration:
                          DecorationUtils.getDropDownFieldDecoration(
                    labelText: 'Time Slot * ',
                  )),
                  popupProps: const PopupProps.dialog(),
                  // showSelectedItem: true,
                  // mode: Mode.menu,

                  items: timeSlotList,
                  onChanged: (val) {
                    serviceSlot = val;
                    widget.indentListItem?.serviceSlot = val;
                  },
                  selectedItem: widget.indentListItem?.serviceSlot,
                  validator: (val) {
                    if (val == null) {
                      return ("select_relation");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 44),

                /// remarks
                TextFormField(
                  controller: remarks,
                  // initialValue: storageMaterialModel.source,
                  // onSaved: (val) => storageMaterialModel.source = val,
                  validator: (val) {
                    if ((val ?? '').isEmpty) {}
                    return null;
                  },
                  decoration: DecorationUtils.getTextFieldDecoration(
                    labelText: 'Remarks',
                  ),
                ),
                const SizedBox(height: 36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// Eway bill
                    SizedBox(
                      width: 110,
                      child: (widget.indentListItem?.ewayDocUrl ?? "")
                              .isNotEmpty
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: (widget.indentListItem?.ewayDocUrl ?? "")
                                      .isNotEmpty
                                      ?
                                      // ImageUtils.loadImage(
                                      //     FileContainerAPIs.getFileURL(
                                      //         APIConstants
                                      //             .MATERIAL_EWAYBILL_CONTAINER,
                                      //         widget.indentListItem.ewayDocUrl
                                      //     ),
                                      //     width: size.width /
                                      //         4,
                                      //     height:
                                      //     size.width /
                                      //         4)

                                      CachedNetworkImage(
                                          imageUrl: widget
                                                  .indentListItem?.ewayDocUrl ??
                                              '',
                                          width: size.width / 4,
                                          height: size.width / 4,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey.shade200,
                                            highlightColor:
                                                ColorConstants.offWhite,
                                            period: const Duration(
                                                milliseconds: 1000),
                                            child: Container(
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                  color:
                                                      ColorConstants.offWhite),
                                            ),
                                          ),
                                        )
                                      : Image.file(File(getEWayBill.path),
                                          width: size.width / 4,
                                          height: size.width / 4),
                                ),
                                InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        eWayPath = "";
                                        eWayURLPath = "";
                                        widget.indentListItem?.ewayDocUrl = "";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                    .then((value) async {
                                  logPrint.w("file value:- $value");
                                    getEWayBill = value!;
                                    eWayPath = value.path.toString();
                                  uploadImage(context, value, 1);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(LineAwesomeIcons.camera,
                                        color: ColorConstants.primary),
                                    const SizedBox(height: 8),
                                    Text("Upload eWayBill",
                                        //
                                        //     ("upload_ewaybill"),
                                        textAlign: TextAlign.center,
                                        style: textTheme.bodyText2!.copyWith(
                                            color: ColorConstants.primary))
                                  ],
                                ),
                              ),
                            ),
                    ),

                    ///invoice
                    SizedBox(
                      width: 110,
                      child:
                      (widget.indentListItem?.invoiceDocUrl ?? "")
                          .isNotEmpty

                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child:
                                  //  (widget.indentListItem?.invoiceDocUrl ?? "")
                                  //                           .isNotEmpty
                                  //     ?
                                      // ImageUtils.loadImage(
                                      //     FileContainerAPIs.getFileURL(
                                      //         APIConstants
                                      //             .MATERIAL_EWAYBILL_CONTAINER,
                                      //         widget.indentListItem.invoiceDocUrl
                                      //     ),
                                      //     width: size.width /4,
                                      //     height:
                                      //     size.width /4)

                                      CachedNetworkImage(
                                          imageUrl: (widget.indentListItem
                                                  ?.invoiceDocUrl ??
                                              ""),
                                          width: size.width / 4,
                                          height: size.width / 4,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey.shade200,
                                            highlightColor:
                                                ColorConstants.offWhite,
                                            period: const Duration(
                                                milliseconds: 1000),
                                            child: Container(
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                  color:
                                                      ColorConstants.offWhite),
                                            ),
                                          ),
                                        )
                                      // : Image.file(getInvoiceBill,
                                      //     width: size.width / 4,
                                      //     height: size.width / 4),
                                ),
                                InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        invoicePath = "";
                                        invoiceURLPath = "";
                                        widget.indentListItem?.invoiceDocUrl =
                                            "";
                                        // storageMaterialModel?.ewaybillFile = null;
                                        // storageMaterialModel?.ewayBillImage = "";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                    .then((value) async {
                                    logPrint.w("file value:- $value");
                                  if (value != null) {
                                      getInvoiceBill = value;
                                      invoicePath = value.path.toString();
                                    uploadImage(context,  invoicePath, 2);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(LineAwesomeIcons.camera,
                                        color: ColorConstants.primary),
                                    const SizedBox(height: 8),
                                    Text('Upload Invoice /STN *',
                                        textAlign: TextAlign.center,
                                        style: textTheme.bodyText2!.copyWith(
                                            color: ColorConstants.primary))
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ///other doc
                    SizedBox(
                      width: 110,
                      child: ((widget.indentListItem?.otherDocUrl ?? "")
                              .isNotEmpty)
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child:
                                  // ((widget.indentListItem?.otherDocUrl ??
                                  //             "")
                                  //         .isNotEmpty)
                                  //     ?
                                      // ImageUtils.loadImage(
                                      //     FileContainerAPIs.getFileURL(
                                      //         APIConstants
                                      //             .MATERIAL_EWAYBILL_CONTAINER,
                                      //         widget.indentListItem.otherDocUrl
                                      //     ),
                                      //     width: size.width /
                                      //         4,
                                      //     height:
                                      //     size.width /
                                      //         4)

                                      CachedNetworkImage(
                                          imageUrl: widget.indentListItem
                                                  ?.otherDocUrl ?? "",
                                          width: size.width / 4,
                                          height: size.width / 4,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey.shade200,
                                            highlightColor:
                                                ColorConstants.offWhite,
                                            period: const Duration(
                                                milliseconds: 1000),
                                            child: Container(
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                  color:
                                                      ColorConstants.offWhite),
                                            ),
                                          ),
                                        )
                                      // : Image.file(getInvoiceBill,
                                      //     width: size.width / 4,
                                      //     height: size.width / 4),
                                ),
                                InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      setState(() {
                                        otherDocPath = "";
                                        otherDocUrl = "";
                                        widget.indentListItem?.otherDocUrl = "";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                    .then((value) async {
                                  logPrint.w("file value:- $value");
                                    getOtherDocBill = value!;
                                    otherDocPath = value.path.toString();
                                  uploadImage(context, value, 3);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(LineAwesomeIcons.camera,
                                        color: ColorConstants.primary),
                                    const SizedBox(height: 8),
                                    Text('Upload Other Doc.',
                                        textAlign: TextAlign.center,
                                        style: textTheme.bodyText2!.copyWith(
                                            color: ColorConstants.primary))
                                  ],
                                ),
                              ),
                            ),
                    ),

                    ///excel upload
                    const SizedBox(
                      width: 110,
                      // child: ((widget.indentListItem?.otherDocUrl ?? "")
                      //         .isNotEmpty)
                      //     ? Stack(
                      //         alignment: Alignment.bottomCenter,
                      //         children: [
                      //           Card(
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(8)),
                      //             clipBehavior: Clip.antiAlias,
                      //             margin: const EdgeInsets.only(bottom: 20),
                      //             child: ((widget.indentListItem?.otherDocUrl ??
                      //                         "")
                      //                     .isNotEmpty)
                      //                 ? CachedNetworkImage(
                      //                     imageUrl: widget.indentListItem
                      //                             ?.otherDocUrl ??
                      //                         "",
                      //                     width: size.width / 4,
                      //                     height: size.width / 4,
                      //                     placeholder: (context, url) =>
                      //                         Shimmer.fromColors(
                      //                       baseColor: Colors.grey.shade200,
                      //                       highlightColor:
                      //                           ColorConstants.offWhite,
                      //                       period: const Duration(
                      //                           milliseconds: 1000),
                      //                       child: Container(
                      //                         height: double.infinity,
                      //                         decoration: const BoxDecoration(
                      //                             color:
                      //                                 ColorConstants.offWhite),
                      //                       ),
                      //                     ),
                      //                   )
                      //                 : Image.file(File(getInvoiceBill.path),
                      //                     width: size.width / 4,
                      //                     height: size.width / 4),
                      //           ),
                      //           InkWell(
                      //               borderRadius: BorderRadius.circular(20),
                      //               onTap: () {
                      //                 //todo: remove excel
                      //               },
                      //               child: Container(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 decoration: BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     boxShadow: [
                      //                       BoxShadow(
                      //                         blurRadius: 1,
                      //                         color:
                      //                             Colors.grey.withOpacity(0.3),
                      //                       )
                      //                     ]),
                      //                 child: const CircleAvatar(
                      //                   radius: 18,
                      //                   backgroundColor: Colors.white,
                      //                   child: Icon(Icons.close,
                      //                       size: 20, color: Colors.black),
                      //                 ),
                      //               )),
                      //         ],
                      //       )
                      //     : InkWell(
                      //         borderRadius: BorderRadius.circular(20),
                      //         onTap: () {
                      //           //todo: upload excel
                      //         },
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: const [
                      //             Icon(Icons.upload_rounded,
                      //                 color: ColorConstants.primary),
                      //             SizedBox(height: 8),
                      //             Text('Upload Excel',
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(
                      //                     color: ColorConstants.primary))
                      //           ],
                      //         ),
                      //       ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 68,
        child: InkWell(
          onTap: () async{
            FocusManager.instance.primaryFocus?.unfocus();
            Map<String, dynamic> data;
            if ((widget.indentListItem?.requestType ?? '').isEmpty) {
              myToast("Please select indent request type");
            }
            else if ((widget.indentListItem?.serviceDate ?? "").isEmpty) {
              myToast("Please select indent service date");
            }
            else if ((widget.indentListItem?.serviceSlot ?? "").isEmpty) {
              myToast("Please select service slot");
            }
            else if ((widget.indentListItem?.invoiceDocUrl ?? "").isEmpty) {
              myToast("Please upload invoice");
            }
            else {
              if (widget.indentListItem?.createdDate == null) {
                data = {
                  'requestType': widget.indentListItem?.requestType,
                  'fkDockId': 1,
                  'driverMobileNumber': driverMobileNumber.text.toString(),
                  'vehicleNumber': vehicleNumber.text.toString(),
                  // "serviceDate": "12/05/2022",
                  'serviceDate':
                  widget.indentListItem?.serviceDate,
                  'serviceSlot': widget.indentListItem?.serviceSlot,
                  'otherDocUrl': widget.indentListItem?.otherDocUrl ?? "",
                  'invoiceDocUrl': widget.indentListItem?.invoiceDocUrl ?? "",
                  'ewayDocUrl': widget.indentListItem?.ewayDocUrl ?? "",
                  'remarks': remarks.text.toString(),
                  "locationId": 1
                  // await PrefData.getPref(PrefData.locationId),
                };
                addIndent(data);
              } else {
                data = {
                  "requestType": widget.indentListItem?.requestType,
                  'fkDockId': 1,
                  'driverMobileNumber': driverMobileNumber.text.toString(),
                  'vehicleNumber': vehicleNumber.text.toString(),
                  'serviceDate': widget.indentListItem?.serviceDate,
                  'serviceSlot': widget.indentListItem?.serviceSlot,
                  'otherDocUrl': widget.indentListItem?.otherDocUrl ?? "",
                  'invoiceDocUrl': widget.indentListItem?.invoiceDocUrl ?? "",
                  'ewayDocUrl': widget.indentListItem?.ewayDocUrl ?? "",
                  'remarks': remarks.text.toString(),
                  'id': widget.indentListItem?.id,
                  "locationId": 1
                  // await PrefData.getPref(PrefData.locationId),
                };
                updateIndent(data);
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: ColorConstants.enableButtonColor,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8.0)),
            constraints: const BoxConstraints(
                maxWidth: double.infinity, minHeight: 52.0),
            alignment: Alignment.center,
            child: (widget.indentListItem?.createdDate == null)
                ? const Text(
                    "Save and Complete",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                : const Text(
                    "Update and Complete",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
          ),
        ),
      ),
    );
  }

  Future addIndent(Map<String, dynamic> data) async {
    String message = '';
    try {
      // var response = await http.post(
      //     Uri.parse("${APIConstants.baseUrlIndent}Indents/addIndent"),
      //     body: data,
      //     headers: {
      //       //todo: must do
      //       "Authorization": "token",
      //       "Content-Type": "application/json",
      //     });
      var response = await IndentDataRepository.addIndent(data);

      logPrint.w("addIndent with data : $data ");
      logPrint.w("server response : $response");

      // final parsedJson = json.decode(response.toString());
      final meta = response['meta'];
      message = meta['message'];
      final code = meta['code'];
      if (code == 200) {
        Future.delayed(const Duration(milliseconds: 1), () => Navigator.of(context).pop(widget.indentListItem));
      }
      myToast(message);
    } catch (e) {
      myToast("Error occurred !!");
      logPrint.e(e.toString());
    }
  }

  Future updateIndent(Map<String, dynamic> data) async {
    try {
      var response = await IndentDataRepository.updateIndent({"updatedIndentData":data});
      final meta = response['meta'];
      final message = meta['message'];
      if (meta['code'] == 200) {
        Future.delayed(const Duration(milliseconds: 1)).then((value) => Navigator.of(context).pop(widget.indentListItem));
      }
      myToast(message);
    } catch (e) {
      myToast("Error occurred !!");
      logPrint.w(e.toString());
    }
  }

  uploadImage(BuildContext context, filename, imageName) async {
    FocusManager.instance.primaryFocus?.unfocus();
    MyLoader.dialog(context);
    var location =
        // "https://indicold-uploads.s3.ap-south-1.amazonaws.com/moolwms/uploads/others/1665897717065_image_cropper_1665897714062.jpg";
    await IndentDataRepository.uploadImage(filename);
    logPrint.w('location: $location');

    if (imageName == 1) {
      eWayURLPath = location;
      widget.indentListItem?.ewayDocUrl = location;
    } else if (imageName == 2) {
      invoiceURLPath = location;
      widget.indentListItem?.invoiceDocUrl = location;
    } else if (imageName == 3) {
      otherURLDocPath = location;
      widget.indentListItem?.otherDocUrl = location;
    }
    await Future.delayed(const Duration(milliseconds: 1), () => Navigator.pop(context));
    setState(() {});
  }
}
