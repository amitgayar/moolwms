import 'package:flutter/material.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/model/gate_transactional_model.dart';
import 'package:moolwms/store/GateStore.dart';
import 'package:moolwms/utils/AppLocalizations.dart';
import 'package:moolwms/widgets/pagination_view.dart';

class PersonInOutListPage extends StatefulWidget {
  int personType;
  String title;
  int customerId;

  PersonInOutListPage(dynamic args) {
    if (args != null) {
      personType = args['personType'];
      title = args['title'];
      customerId = args['customerId'];
    }
  }
  @override
  _PersonInOutListPageState createState() => _PersonInOutListPageState();
}

class _PersonInOutListPageState extends State<PersonInOutListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GateStore gateStore = GateStore();
  List<GateTransactionModel> personList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
            widget.title ??
                AppLocalizations.of(context).translate("person_in_out"),
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: ColorConstants.PRIMARY, fontWeight: FontWeight.w800)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.cloud_download, color: ColorConstants.PRIMARY),
              onPressed: () {
                gateStore.generateReport(context, 'person');
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
                    Center(
                        child: Text(
                            AppLocalizations.of(context).translate("status"),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white))),
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 6,
                        child: Text(
                            AppLocalizations.of(context).translate("person"),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white))),
                    Expanded(
                        flex: 2,
                        child: Text(
                            AppLocalizations.of(context).translate("type"),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white))),
                    const SizedBox(width: 12),
                    Center(
                        child: Text(
                            AppLocalizations.of(context).translate("datetime"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white))),
                  ],
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorConstants.PERSON_DARK,
                        ColorConstants.PERSON_LIGHT
                      ]),
                ),
              ),
              Expanded(
                child: Pagination<GateTransactionModel>(
                  pageBuilder: (currentListSize) => gateStore.getPersonList(
                      customerId: widget.customerId ?? null,
                      personType: widget.personType,
                      limit: 100,
                      offset: currentListSize),
                  itemBuilder: (pos, gateTxn) {
                    return gateTxn.getPersonListItemWidget(context);
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
