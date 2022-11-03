// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:moolwms/constants/Constants.dart';
// import 'package:moolwms/model/MaterialModel.dart';
// import 'package:moolwms/model/MoolwmsOrgModel.dart';
// import 'package:moolwms/store/MaterialStore.dart';
// import 'package:moolwms/utils/AppLocalizations.dart';
// import 'package:moolwms/widgets/bottom_button_container.dart';
// import 'package:moolwms/widgets/gradient_button.dart';
// import 'package:moolwms/widgets/ProgressContainerView.dart';
// import 'package:moolwms/widgets/VisibilityExtended.dart';
// import 'package:toast/toast.dart';
//
// class StorageMaterialItemsListPage extends StatefulWidget {
//   StorageMaterialModel storageMaterialModel;
//   MoolwmsOrgModel moolwmsOrgModel;
//   bool isEditable;
//
//   StorageMaterialItemsListPage(dynamic args) {
//     if (args is Map) {
//       storageMaterialModel = args['storageMaterial'];
//       moolwmsOrgModel = args['customer'];
//       isEditable = args['isEditable'] ?? true;
//     }
//   }
//
//   @override
//   _StorageMaterialItemsListPageState createState() =>
//       _StorageMaterialItemsListPageState();
// }
//
// class _StorageMaterialItemsListPageState
//     extends State<StorageMaterialItemsListPage> {
//   List<StorageMaterialItemModel> itemsList = <StorageMaterialItemModel>[];
//   MaterialStore materialStore = MaterialStore();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.storageMaterialModel != null) {
//       if (widget.storageMaterialModel?.items?.isNotEmpty ?? false) {
//         itemsList = widget.storageMaterialModel.items;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(AppLocalizations.of(context)
//               .translate("storage_material_items"))),
//       body: Observer(builder: (_) {
//         return ProgressContainerView(
//           isProgressRunning: materialStore?.showProgress ?? false,
//           child: SingleChildScrollView(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: itemsList.map<Widget>((e) {
//                   return e.getListItemWidget(context,
//                       editCallback: widget.isEditable
//                           ? () async {
//                               await Navigator.of(context).pushNamed(
//                                   '/admin/gms/material/storage_material/items/add',
//                                   arguments: {
//                                     "item": e,
//                                     "customer": widget.moolwmsOrgModel
//                                   }).then((value) {
//                                 if (value != null &&
//                                     value is StorageMaterialItemModel) {
//                                   setState(() {
//                                     e = value;
//                                   });
//                                 }
//                               });
//                             }
//                           : null,
//                       deleteCallback: widget.isEditable
//                           ? () {
//                               setState(() {
//                                 itemsList.remove(e);
//                               });
//                             }
//                           : null);
//                 }).toList()
//                   ..add(widget.isEditable
//                       ? Padding(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 8.0,
//                           ),
//                           child: InkWell(
//                             onTap: () async {
//                               await Navigator.of(context).pushNamed(
//                                   '/admin/gms/material/storage_material/items/add',
//                                   arguments: {
//                                     "customer": widget.moolwmsOrgModel
//                                   }).then((value) {
//                                 if (value != null &&
//                                     value is StorageMaterialItemModel) {
//                                   setState(() {
//                                     itemsList.add(value);
//                                   });
//                                 }
//                               });
//                             },
//                             borderRadius: BorderRadius.circular(8),
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                       color: ColorConstants.PRIMARY, width: 1),
//                                 ),
//                                 padding: const EdgeInsets.all(8),
//                                 child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.add,
//                                           color: ColorConstants.PRIMARY),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                           AppLocalizations.of(context)
//                                               .translate("add_item"),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .button
//                                               .copyWith(
//                                                   color:
//                                                       ColorConstants.PRIMARY)),
//                                     ])),
//                           ),
//                         )
//                       : Container()),
//               )),
//         );
//       }),
//       bottomNavigationBar: Observer(builder: (_) {
//         return VisibilityExtended(
//           visible: !(materialStore?.showProgress ?? false) && widget.isEditable,
//           child: BottomButtonsContainer(
//             children: [
//               FlatButton(
//                 child: Text(AppLocalizations.of(context).translate('back')),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               const SizedBox(width: 8),
//               GradientButton(
//                 onPressed: () async {
//                   if (itemsList.isNotEmpty) {
//                     Navigator.of(context).pop(itemsList);
//                   } else {
//                     Toast.show(
//                         AppLocalizations.of(context)
//                             .translate("add_atleast_one_storage_material"),
//                         context);
//                   }
//                   //   widget.materialModel.storageMaterials.last.items = itemsList;
//                   //   GateTransactionModel txnResp;
//                   //   if (widget.materialModel.directionOfMovement ==
//                   //       "inward") {
//                   //     txnResp = await materialStore.materialIn(
//                   //         context, widget.materialModel);
//                   //   } else {
//                   //     txnResp = await materialStore.materialOut(
//                   //         context, widget.materialModel);
//                   //   }
//                   //   if (txnResp != null) {
//                   //     DialogViews.showSuccessBottomSheet(
//                   //       context,
//                   //       detailText: AppLocalizations.of(context).translate(
//                   //           widget.materialModel.directionOfMovement ==
//                   //                   "inward"
//                   //               ? "material_in_successful"
//                   //               : "material_out_successful"),
//                   //     );
//                   //   }
//                   // }
//                 },
//                 child: Text(AppLocalizations.of(context).translate("save")),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
