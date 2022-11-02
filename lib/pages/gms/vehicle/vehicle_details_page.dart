import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moolwms/constants/constants.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/vehicle/model.dart';
import 'package:moolwms/widgets/my_image_cropper.dart';
import 'package:url_launcher/url_launcher.dart';

class VehicleDetailsPage extends StatefulWidget {
  final GateTransactionModel? gateTxn;
  final VehicleModel? vehicleModel;

  const VehicleDetailsPage({super.key, this.gateTxn, this.vehicleModel});

  @override
  VehicleDetailsPageState createState() => VehicleDetailsPageState();
}

class VehicleDetailsPageState extends State<VehicleDetailsPage> {
  PersonStore personStore = PersonStore();
  PersonModel? personModel;

  @override
  void initState() {
    super.initState();
    personStore.getPersonById( widget.gateTxn?.personId)
        .then((value) => personModel = value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: const Text(
                  ("vehicle_details"))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.gateTxn?.transactionType == 1
                        ? Colors.green[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child:
                          Text(widget.vehicleModel?.vehicleNumber ?? "")),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.gateTxn?.transactionType == 1
                                ?
                            ("in")
                                :
                            ("out"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                widget.gateTxn?.transactionType == 1
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("vehicle_number"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.vehicleNumber ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("owner_name"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.ownerName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("owner_type"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.ownerType?.label ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        Visibility(
                          visible: personModel != null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(

                                      ("mobile_number"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                        personModel?.mobileNo?.fullNumber ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                            fontWeight: FontWeight.w600),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("vehicle_type"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.vehicleType?.label ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("vehicle_insurance"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.vehicleInsurance?.label ??
                                      "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("insurance_expiry"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.insuranceExpiry != null
                                      ? DateFormat("dd-MM-yyyy").format(
                                      widget.vehicleModel?.insuranceExpiry)
                                      : "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(

                                ("vehicle_rc"),
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                  widget.vehicleModel?.vehicleRc ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        if(widget.vehicleModel?.vehicleRcImage != null)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(

                                      ("rc_image"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Card(
                                              margin:
                                              const EdgeInsets.only(bottom: 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8)),
                                              clipBehavior: Clip.antiAlias,
                                              child: ImageUtils.loadImage(
                                                  FileContainerAPIs.getFileURL(
                                                      APIConstants.VEHICLE_RC_IMAGE_CONTAINER,
                                                      widget.vehicleModel
                                                          ?.vehicleRcImage),
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      3,
                                                  height:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      3),
                                            ),
                                            InkWell(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                onTap: () async {
                                                  // todo: url_launcher deprecated
                                                  if (await canLaunch(
                                                      FileContainerAPIs.getFileURL(
                                                          APIConstants
                                                              .VEHICLE_RC_IMAGE_CONTAINER,
                                                          widget.vehicleModel
                                                              ?.vehicleRcImage))) {
                                                    await launch(FileContainerAPIs
                                                        .getFileURL(
                                                        APIConstants
                                                            .VEHICLE_RC_IMAGE_CONTAINER,
                                                        widget
                                                            .vehicleModel
                                                            ?.vehicleRcImage));
                                                  }
                                                },
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      4.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 1,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                              0.3),
                                                        )
                                                      ]),
                                                  child: const CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                        Icons.open_in_new,
                                                        size: 20,
                                                        color: Colors.black),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        if(widget.vehicleModel?.vehicleInsuranceImage != null)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(

                                      ("insurance_image"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Card(
                                              margin:
                                              const EdgeInsets.only(bottom: 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8)),
                                              clipBehavior: Clip.antiAlias,
                                              child: ImageUtils.loadImage(
                                                  FileContainerAPIs.getFileURL(
                                                      APIConstants
                                                          .VEHICLE_INSURANCE_IMAGE_CONTAINER,
                                                      widget.vehicleModel
                                                          ?.vehicleInsuranceImage),
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      3,
                                                  height:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      3),
                                            ),
                                            InkWell(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                onTap: () async {
                                                  if (await canLaunch(
                                                      FileContainerAPIs.getFileURL(
                                                          APIConstants
                                                              .VEHICLE_INSURANCE_IMAGE_CONTAINER,
                                                          widget.vehicleModel
                                                              ?.vehicleInsuranceImage))) {
                                                    await launch(FileContainerAPIs
                                                        .getFileURL(
                                                        APIConstants
                                                            .VEHICLE_INSURANCE_IMAGE_CONTAINER,
                                                        widget
                                                            .vehicleModel
                                                            ?.vehicleInsuranceImage));
                                                  }
                                                },
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      4.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 1,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                              0.3),
                                                        )
                                                      ]),
                                                  child: const CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(
                                                        Icons.open_in_new,
                                                        size: 20,
                                                        color: Colors.black),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
