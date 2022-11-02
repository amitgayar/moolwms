import 'package:flutter/material.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/MaterialModel.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/BottomButtonsContainer.dart';
import 'package:moolwms/widgets/gradient_button.dart';

class AssetsItemsListPage extends StatefulWidget {
  MaterialModel materialModel;

  AssetsItemsListPage(dynamic args) {
    if (args is Map) {
      materialModel = args['material'];
    }
  }

  @override
  _AssetsItemsListPageState createState() => _AssetsItemsListPageState();
}

class _AssetsItemsListPageState extends State<AssetsItemsListPage> {
  List<AssetsItemModel> itemsList = <AssetsItemModel>[];

  @override
  void initState() {
    super.initState();
    if (widget.materialModel != null) {
      if (widget.materialModel?.assets?.isNotEmpty ?? false) {
        itemsList = widget.materialModel.assets;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context).translate("assets"))),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: itemsList.map<Widget>((e) {
              return e.getListItemWidget(context, editCallback: () async {
                await Navigator.of(context).pushNamed(
                    '/admin/gms/material/assets/items/add',
                    arguments: {"item": e}).then((value) {
                  if (value != null && value is AssetsItemModel) {
                    setState(() {
                      e = value;
                    });
                  }
                });
              }, deleteCallback: () {
                setState(() {
                  itemsList.remove(e);
                });
              });
            }).toList()
              ..add(Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: InkWell(
                  onTap: () async {
                    await Navigator.of(context)
                        .pushNamed('/admin/gms/material/assets/items/add')
                        .then((value) {
                      if (value != null && value is AssetsItemModel) {
                        setState(() {
                          itemsList.add(value);
                        });
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: ColorConstants.PRIMARY, width: 1),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: ColorConstants.PRIMARY),
                            const SizedBox(width: 8),
                            Text(
                                AppLocalizations.of(context)
                                    .translate("add_item"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: ColorConstants.PRIMARY)),
                          ])),
                ),
              )),
          )),
      bottomNavigationBar: BottomButtonsContainer(
        children: [
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('back')),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          GradientButton(
            onPressed: () async {
              Navigator.of(context).pop(itemsList);
              // if (itemsList.isNotEmpty) {
              //   widget.materialModel.assets = itemsList;
              //   GateTransactionModel txnResp;
              //   if (widget.materialModel.directionOfMovement == "inward") {
              //     txnResp = await materialStore.materialIn(
              //         context, widget.materialModel);
              //   } else {
              //     txnResp = await materialStore.materialOut(
              //         context, widget.materialModel);
              //   }
              //   if (txnResp != null) {
              //     DialogViews.showSuccessBottomSheet(
              //       context,
              //       detailText: AppLocalizations.of(context).translate(
              //           widget.materialModel.directionOfMovement == "inward"
              //               ? "material_in_successful"
              //               : "material_out_successful"),
              //     );
              //   }
              // }
            },
            child: Text(AppLocalizations.of(context).translate("save")),
          ),
        ],
      ),
    );
  }
}
