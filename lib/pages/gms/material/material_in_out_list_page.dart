import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/widgets/pagination_view.dart';

class MaterialInOutListPage extends StatefulWidget {
  final int? materialType;
  final int? direction;
  final int? customerId;

  const MaterialInOutListPage({super.key,  this.materialType,  this.direction,  this.customerId});


  @override
  MaterialInOutListPageState createState() => MaterialInOutListPageState();
}

class MaterialInOutListPageState extends State<MaterialInOutListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GateStore gateStore = GateStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
                ("material_in_out"),
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: ColorConstants.primary, fontWeight: FontWeight.w800)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.cloud_download, color: ColorConstants.primary),
              onPressed: () {
                gateStore.generateReport('material');
              })
        ],
      ),
      backgroundColor: ColorConstants.background,
      body: Container(
        color: Colors.white,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(0),
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration:  const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorConstants.MATERIAL_DARK,
                        ColorConstants.MATERIAL_LIGHT
                      ]),
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(

                                    ("status"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: Colors.white)))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(

                                    ("vehicle_no"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: Colors.white)))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(

                                    ("customer"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: Colors.white)))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(

                                    ("datetime"),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: Colors.white)))),
                  ],
                ),
              ),
              Expanded(
                child: Pagination<GateTransactionModel>(
                  pageBuilder: (currentListSize) => gateStore.getMaterialList(
                      customerId: widget.customerId,
                      materialType: widget.materialType!,
                      direction: widget.direction!,
                      limit: 100,
                      offset: currentListSize),
                  itemBuilder: (pos, gateTxn) {
                    return gateTxn.getMaterialListItemWidget(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: null,
      //   child: Icon(AntDesign.filter),
      // ),
    );
  }
}
