
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/widgets/bottom_button_container.dart';
import 'package:moolwms/widgets/dialog_views.dart';
import 'package:moolwms/widgets/gradient_button.dart';
import 'package:moolwms/widgets/visibility_extended.dart';

class MaterialTypeListPage extends StatefulWidget {
  final MaterialModel? materialModel;

  const MaterialTypeListPage({super.key, this.materialModel});
  @override
  MaterialTypeListPageState createState() => MaterialTypeListPageState();
}

class MaterialTypeListPageState extends State<MaterialTypeListPage> {
  List<OptionModel> materialTypes = <OptionModel>[];
  MaterialStore? materialStore;
  @override
  void initState() {
    super.initState();
    materialStore = MaterialStore();
    OptionAPIs.getOptions("MATERIALTYPE").then((value) {
      setState(() {
        materialTypes = value;
        if (widget.materialModel!.directionOfMovement == "outward") {
          materialTypes.removeWhere(
              (element) => element.label!.toLowerCase() == "diesel");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(("add_material"))),
      body: SingleChildScrollView(
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
                          "assets/images/storage_material.svg",
                          width: 20,
                          height: 20),
                      const SizedBox(width: 8),
                      Text(

                          ("storage_materials"),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  ColorConstants.primary,
                                  ColorConstants.primaryDark
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        child: Text(
                            "${widget.materialModel?.storageMaterials?.length ?? 0}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white)),
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
                                widget.materialModel!.storageMaterials =
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
                    SvgPicture.asset("assets/images/personal_items.svg",
                        width: 20, height: 20),
                    const SizedBox(width: 8),
                    Text(

                        ("personal_items"),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                ColorConstants.primary,
                                ColorConstants.primaryDark
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(
                          "${widget.materialModel?.personalMaterials?.length ?? 0}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white)),
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
                              widget.materialModel!.personalMaterials =
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

                        ("documents"),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                ColorConstants.primary,
                                ColorConstants.primaryDark
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(
                          "${widget.materialModel?.documents?.length ?? 0}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white)),
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
                              widget.materialModel!.documents = value;
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
                    Text(("assets"),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                ColorConstants.primary,
                                ColorConstants.primaryDark
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(
                          "${widget.materialModel?.assets?.length ?? 0}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white)),
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
                              widget.materialModel!.assets = value;
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
                    SvgPicture.asset("assets/images/spare_parts.svg",
                        width: 20, height: 20),
                    const SizedBox(width: 8),
                    Text(
                        ("spare_parts"),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                ColorConstants.primary,
                                ColorConstants.primaryDark
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(
                          "${widget.materialModel?.spareParts?.length ?? 0}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white)),
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
                              widget.materialModel!.spareParts = value;
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

                          ("diesel"),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  ColorConstants.primary,
                                  ColorConstants.primaryDark
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        child: Text(
                            "${widget.materialModel?.diesels?.length ?? 0}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white)),
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
                                widget.materialModel!.diesels = value;
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
      bottomNavigationBar: VisibilityExtended(
        visible: !((materialTypes.isEmpty) ||
            (materialStore?.showProgress ?? false)),
        child: BottomButtonsContainer(
          children: [
            TextButton(
              child: const Text(('back')),
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
                  GateTransactionModel? txnResp;
                  if (widget.materialModel!.directionOfMovement == "inward") {
                    txnResp = await materialStore!.materialIn(
                        widget.materialModel);
                  } else {
                    txnResp = await materialStore!.materialOut(widget.materialModel);
                  }
                  if (txnResp != null) {
                    DialogViews.showSuccessBottomSheet(
                      context,
                      detailText: (
                          widget.materialModel!.directionOfMovement == "inward"
                              ? "material_in_successful"
                              : "material_out_successful"),
                    );
                  }
                } else {
                  DialogViews.showErrorDialog(
                      context,

                      ("please_add_material"));
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

class SparePartsItemModel {
}

class AssetsItemModel {
}

class DocumentsItemModel {
}

class PersonalMaterialItemModel {
}

class StorageMaterialModel {
}




