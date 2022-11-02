// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moolwms/Providers/FirebaseProvider.dart';
import 'package:moolwms/api/CommonAPIs.dart';
import 'package:moolwms/api/DioClient.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/gate_transactional_model.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/model/OptionModel.dart';
import 'package:moolwms/store/MaterialStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/ProgressContainerView.dart';
import 'package:moolwms/widgets/VisibilityExtended.dart';

import '../../../locator.dart';

class MaterialTypeListPage extends StatefulWidget {
  MaterialModel materialModel;
  MaterialTypeListPage(dynamic args) {
    materialModel = args['material'];
  }
  @override
  _MaterialTypeListPageState createState() => _MaterialTypeListPageState();
}

class _MaterialTypeListPageState extends State<MaterialTypeListPage> {
  List<OptionModel> materialTypes = <OptionModel>[];
  MaterialStore materialStore;
  final FirebaseProvider _firebaseProvider = locator<FirebaseProvider>();
  @override
  void initState() {
    super.initState();
    materialStore = MaterialStore();
    OptionAPIs.getOptions("MATERIALTYPE").then((value) {
      setState(() {
        materialTypes = value;
        if (widget.materialModel.directionOfMovement == "outward") {
          materialTypes.removeWhere(
              (element) => element.label.toLowerCase() == "diesel");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("add_material"))),
      body: Observer(builder: (_) {
        return ProgressContainerView(
          isProgressRunning:
              (materialTypes.isEmpty) || (materialStore?.showProgress ?? false),
          child: Container(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  VisibilityExtended(
                    visible: widget.materialModel?.customer != null,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/storagematerial.svg",
                                width: 20,
                                height: 20),
                            const SizedBox(width: 8),
                            Text(
                                AppLocalizations.of(context)
                                    .translate("storage_materials"),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                  "${widget.materialModel?.storageMaterials?.length ?? 0}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: Colors.white)),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: [
                                        ColorConstants.PRIMARY,
                                        ColorConstants.PRIMARY_DARK
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    '/admin/gms/material/storage_material/list',
                                    arguments: {
                                      'material': widget.materialModel
                                    }).then((value) {
                                  if (value is List<StorageMaterialModel>) {
                                    setState(() {
                                      widget.materialModel.storageMaterials =
                                          value;
                                    });
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/personalitems.svg",
                              width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(
                              AppLocalizations.of(context)
                                  .translate("personal_items"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                "${widget.materialModel?.personalMaterials?.length ?? 0}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white)),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      ColorConstants.PRIMARY,
                                      ColorConstants.PRIMARY_DARK
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  '/admin/gms/material/personal_item/items',
                                  arguments: {
                                    'material': widget.materialModel
                                  }).then((value) {
                                if (value is List<PersonalMaterialItemModel>) {
                                  setState(() {
                                    widget.materialModel.personalMaterials =
                                        value;
                                  });
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/documents.svg",
                              width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(
                              AppLocalizations.of(context)
                                  .translate("documents"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                "${widget.materialModel?.documents?.length ?? 0}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white)),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      ColorConstants.PRIMARY,
                                      ColorConstants.PRIMARY_DARK
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  '/admin/gms/material/documents/items',
                                  arguments: {
                                    'material': widget.materialModel
                                  }).then((value) {
                                if (value is List<DocumentsItemModel>) {
                                  setState(() {
                                    widget.materialModel.documents = value;
                                  });
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/assets.svg",
                              width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context).translate("assets"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                "${widget.materialModel?.assets?.length ?? 0}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white)),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      ColorConstants.PRIMARY,
                                      ColorConstants.PRIMARY_DARK
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  '/admin/gms/material/assets/items',
                                  arguments: {
                                    'material': widget.materialModel
                                  }).then((value) {
                                if (value is List<AssetsItemModel>) {
                                  setState(() {
                                    widget.materialModel.assets = value;
                                  });
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/spareparts.svg",
                              width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(
                              AppLocalizations.of(context)
                                  .translate("spare_parts"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                "${widget.materialModel?.spareParts?.length ?? 0}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white)),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      ColorConstants.PRIMARY,
                                      ColorConstants.PRIMARY_DARK
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  '/admin/gms/material/spare_parts/items',
                                  arguments: {
                                    'material': widget.materialModel
                                  }).then((value) {
                                if (value is List<SparePartsItemModel>) {
                                  setState(() {
                                    widget.materialModel.spareParts = value;
                                  });
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  VisibilityExtended(
                    visible: !(widget.materialModel?.directionOfMovement
                            ?.toLowerCase()
                            ?.contains("outward") ??
                        false),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/diesel.svg",
                                width: 20, height: 20),
                            const SizedBox(width: 8),
                            Text(
                                AppLocalizations.of(context)
                                    .translate("diesel"),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                  "${widget.materialModel?.diesels?.length ?? 0}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: Colors.white)),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: [
                                        ColorConstants.PRIMARY,
                                        ColorConstants.PRIMARY_DARK
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    '/admin/gms/material/diesel/items',
                                    arguments: {
                                      'material': widget.materialModel
                                    }).then((value) {
                                  if (value is List<DieselItemModel>) {
                                    setState(() {
                                      widget.materialModel.diesels = value;
                                    });
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Observer(builder: (_) {
        return VisibilityExtended(
          visible: !((materialTypes.isEmpty) ||
              (materialStore?.showProgress ?? false)),
          child: BottomButtonsContainer(
            children: [
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('back')),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              GradientButton(
                onPressed: () async {
                  if ((widget.materialModel?.storageMaterials?.isNotEmpty ??
                          false) ||
                      (widget.materialModel?.personalMaterials?.isNotEmpty ??
                          false) ||
                      (widget.materialModel?.documents?.isNotEmpty ?? false) ||
                      (widget.materialModel?.assets?.isNotEmpty ?? false) ||
                      (widget.materialModel?.spareParts?.isNotEmpty ?? false) ||
                      (widget.materialModel?.diesels?.isNotEmpty ?? false)) {
                    GateTransactionModel txnResp;
                    if (widget.materialModel.directionOfMovement == "inward") {
                      txnResp = await materialStore.materialIn(
                          context, widget.materialModel);
                    } else {
                      txnResp = await materialStore.materialOut(
                          context, widget.materialModel);
                    }
                    if (txnResp != null) {
                      _firebaseProvider.analytics
                          .logEvent(name: "MaterialInSuccess", parameters: {
                        "mobileNumber": widget.materialModel.mobileNo.fullNumber
                      });
                      DialogViews.showSuccessBottomSheet(
                        context,
                        detailText: AppLocalizations.of(context).translate(
                            widget.materialModel.directionOfMovement == "inward"
                                ? "material_in_successful"
                                : "material_out_successful"),
                      );
                    }
                  } else {
                    showErrorDialog(
                        context,
                        AppLocalizations.of(context)
                            .translate("please_add_material"));
                  }
                },
                child: Text(AppLocalizations.of(context).translate("submit")),
              ),
            ],
          ),
        );
      }),
    );
  }
}
