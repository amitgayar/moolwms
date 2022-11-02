import 'package:flutter/material.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/gate_transactional_model.dart';
import 'package:moolwms/store/GateStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/PaginationView.dart';

class MaterialInOutListPage extends StatefulWidget {
  int materialType;
  int direction;
  String title;
  int customerId;

  MaterialInOutListPage(dynamic args) {
    if (args != null) {
      materialType = args['materialType'];
      direction = args['direction'];
      title = args['title'];
      customerId = args['customerId'];
    }
  }
  @override
  _MaterialInOutListPageState createState() => _MaterialInOutListPageState();
}

class _MaterialInOutListPageState extends State<MaterialInOutListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GateStore gateStore = GateStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
            widget.title ??
                AppLocalizations.of(context).translate("material_in_out"),
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: ColorConstants.PRIMARY, fontWeight: FontWeight.w800)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.cloud_download, color: ColorConstants.PRIMARY),
              onPressed: () {
                gateStore.generateReport(context, 'material');
              })
        ],
      ),
      backgroundColor: ColorConstants.BACKGROUND,
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
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("status"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white)))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("vehicle_no"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white)))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("customer"),
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white)))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("datetime"),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white)))),
                  ],
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorConstants.MATERIAL_DARK,
                        ColorConstants.MATERIAL_LIGHT
                      ]),
                ),
              ),
              Expanded(
                child: Pagination<GateTransactionModel>(
                  pageBuilder: (currentListSize) => gateStore.getMaterialList(
                      customerId: widget.customerId ?? null,
                      materialType: widget.materialType,
                      direction: widget.direction,
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
