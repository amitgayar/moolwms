import 'package:flutter/material.dart';
import 'package:moolwms/model/gate_transactional_model.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/model/PersonDetailModel.dart';
import 'package:moolwms/store/MaterialStore.dart';
import 'package:moolwms/store/PersonStore.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moolwms/utils/Extensions.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';

class MaterialDetailsPage extends StatefulWidget {
  GateTransactionModel gateTxn;
  MaterialDetailsPage(dynamic arg) {
    gateTxn = arg['gateTxn'];
  }

  @override
  _MaterialDetailsPageState createState() => _MaterialDetailsPageState();
}

class _MaterialDetailsPageState extends State<MaterialDetailsPage> {
  MaterialStore materialStore = MaterialStore();
  PersonStore personStore = PersonStore();
  MaterialModel materialModel;
  PersonModel personModel;

  @override
  void initState() {
    super.initState();
    materialStore
        .getMaterialById(context, widget.gateTxn?.materialId)
        .then((value) => materialModel = value);
    personStore
        .getPersonById(context, widget.gateTxn?.personId)
        .then((value) => personModel = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                AppLocalizations.of(context).translate("material_details"))),
        body: Observer(builder: (_) {
          return ProgressContainerView(
            isProgressRunning: (materialStore?.showProgress ?? false) ||
                (personStore.showProgress ?? false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(widget.gateTxn?.transactionType == 1
                                ? AppLocalizations.of(context)
                                    .translate("inward")
                                : AppLocalizations.of(context)
                                    .translate("outward"))),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text(
                                widget.gateTxn?.transactionType == 1
                                    ? AppLocalizations.of(context)
                                        .translate("in")
                                    : AppLocalizations.of(context)
                                        .translate("out"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            widget.gateTxn?.transactionType == 1
                                                ? Colors.green
                                                : Colors.red),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: widget.gateTxn?.transactionType == 1
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
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
                                  AppLocalizations.of(context)
                                      .translate("vehicle_number"),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                widget.gateTxn?.vehicle?.vehicleNumber ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const Divider(),
                          VisibilityExtended(
                            visible: !(materialModel
                                    ?.customer?.name?.isEmptyOrNull ??
                                true),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate("customer"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(
                                      materialModel?.customer?.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ))
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("name"),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                personModel?.fullName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("driver_phone_no"),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                personModel?.mobileNo?.fullNumber ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("date_of_movement"),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                materialModel?.createdDate?.ddMMMyyyy ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("direction_of_movement"),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                widget.gateTxn?.transactionType == 1
                                    ? AppLocalizations.of(context)
                                        .translate("inward")
                                    : AppLocalizations.of(context)
                                        .translate("outward"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  VisibilityExtended(
                    visible:
                        materialModel?.storageMaterials?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                            AppLocalizations.of(context)
                                .translate("storage_materials"),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              materialModel?.storageMaterials?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, pos) {
                            return materialModel?.storageMaterials[pos]
                                    ?.getListItemWidget(context) ??
                                Container();
                          },
                        )
                      ],
                    ),
                  ),
                  VisibilityExtended(
                    visible: materialModel?.assets?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(AppLocalizations.of(context).translate("assets"),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: materialModel?.assets?.length ?? 0,
                          itemBuilder: (context, pos) {
                            return materialModel?.assets[pos]
                                    ?.getListItemWidget(context) ??
                                Container();
                          },
                        )
                      ],
                    ),
                  ),
                  VisibilityExtended(
                    visible: materialModel?.diesels?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(AppLocalizations.of(context).translate("diesel"),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: materialModel?.diesels?.length ?? 0,
                          itemBuilder: (context, pos) {
                            return materialModel?.diesels[pos]
                                    ?.getListItemWidget(context) ??
                                Container();
                          },
                        )
                      ],
                    ),
                  ),
                  VisibilityExtended(
                    visible: materialModel?.documents?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                            AppLocalizations.of(context).translate("documents"),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: materialModel?.documents?.length ?? 0,
                          itemBuilder: (context, pos) {
                            return materialModel?.documents[pos]
                                    ?.getListItemWidget(context) ??
                                Container();
                          },
                        )
                      ],
                    ),
                  ),
                  VisibilityExtended(
                    visible:
                        materialModel?.personalMaterials?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                            AppLocalizations.of(context)
                                .translate("personal_items"),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              materialModel?.personalMaterials?.length ?? 0,
                          itemBuilder: (context, pos) {
                            return materialModel?.personalMaterials[pos]
                                    ?.getListItemWidget(context) ??
                                Container();
                          },
                        )
                      ],
                    ),
                  ),
                  VisibilityExtended(
                    visible: materialModel?.spareParts?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                            AppLocalizations.of(context)
                                .translate("spare_parts"),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: materialModel?.spareParts?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, pos) {
                            return materialModel?.spareParts[pos]
                                    ?.getListItemWidget(context) ??
                                Container();
                          },
                        )
                      ],
                    ),
                  ),
                  // VisibilityExtended(
                  //   visible: materialModel?.storageMaterials?.isNotEmpty ?? false,
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(height: 24),
                  //       Text(
                  //           AppLocalizations.of(context)
                  //               .translate("storage_materials"),
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .subtitle1
                  //               .copyWith(fontWeight: FontWeight.bold)),
                  //       SizedBox(height: 8),
                  //       Card(
                  //         elevation: 4,
                  //         margin: EdgeInsets.all(0),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(12.0),
                  //           child: Column(
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("grn"),
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodyText1,
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 8),
                  //                   Expanded(
                  //                       child: Text(
                  //                     materialModel?.storageMaterial?.grn ?? "",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyText1
                  //                         .copyWith(
                  //                             fontWeight: FontWeight.w600),
                  //                   ))
                  //                 ],
                  //               ),
                  //               Divider(),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("invoice_number"),
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodyText1,
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 8),
                  //                   Expanded(
                  //                       child: Text(
                  //                     materialModel
                  //                             ?.storageMaterial?.invoiceNo ??
                  //                         "",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyText1
                  //                         .copyWith(
                  //                             fontWeight: FontWeight.w600),
                  //                   ))
                  //                 ],
                  //               ),
                  //               Divider(),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("stn_challan_number"),
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodyText1,
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 8),
                  //                   Expanded(
                  //                       child: Text(
                  //                     materialModel
                  //                             ?.storageMaterial?.stnChallanNo ??
                  //                         "",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyText1
                  //                         .copyWith(
                  //                             fontWeight: FontWeight.w600),
                  //                   ))
                  //                 ],
                  //               ),
                  //               Divider(),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("total_tonnage"),
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodyText1,
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 8),
                  //                   Expanded(
                  //                       child: Text(
                  //                     materialModel
                  //                             ?.storageMaterial?.totalTonnage
                  //                             ?.toString() ??
                  //                         "",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyText1
                  //                         .copyWith(
                  //                             fontWeight: FontWeight.w600),
                  //                   ))
                  //                 ],
                  //               ),
                  //               Divider(),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("source"),
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodyText1,
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 8),
                  //                   Expanded(
                  //                       child: Text(
                  //                     materialModel?.storageMaterial?.source ??
                  //                         "",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyText1
                  //                         .copyWith(
                  //                             fontWeight: FontWeight.w600),
                  //                   ))
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(height: 12),
                  //       VisibilityExtended(
                  //         visible: materialModel
                  //                 ?.storageMaterial?.items?.isNotEmpty ??
                  //             false,
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Text(
                  //                 AppLocalizations.of(context)
                  //                     .translate("items"),
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .subtitle1
                  //                     .copyWith(fontWeight: FontWeight.bold)),
                  //             SizedBox(height: 8),
                  //             ListView.builder(
                  //               shrinkWrap: true,
                  //               itemCount: materialModel
                  //                       ?.storageMaterial?.items?.length ??
                  //                   0,
                  //               itemBuilder: (context, pos) {
                  //                 return materialModel
                  //                         ?.storageMaterial?.items[pos]
                  //                         ?.getListItemWidget(context) ??
                  //                     Container();
                  //               },
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }));
  }
}
