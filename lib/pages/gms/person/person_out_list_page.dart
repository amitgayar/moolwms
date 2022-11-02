import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/model/model.dart';
import 'package:moolwms/widgets/pagination_view.dart';

class PersonInOutListPage extends StatefulWidget {
  final int personType;
  final int customerId;

  const PersonInOutListPage({super.key, required this.personType, required this.customerId});
  @override
  PersonInOutListPageState createState() => PersonInOutListPageState();
}

class PersonInOutListPageState extends State<PersonInOutListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GateStore gateStore = GateStore();
  List<GateTransactionModel>? personList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
                ("person_in_out"),
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: ColorConstants.primary, fontWeight: FontWeight.w800)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.cloud_download, color: ColorConstants.primary),
              onPressed: () {
                gateStore.generateReport( 'person');
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
                        ColorConstants.PERSON_DARK,
                        ColorConstants.PERSON_LIGHT
                      ]),
                ),
                child: Row(
                  children: [
                    Center(
                        child: Text(
                            ("status"),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                !.copyWith(color: Colors.white))),
                    const SizedBox(width: 12),
                    Expanded(
                        flex: 6,
                        child: Text(
                            ("person"),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                !.copyWith(color: Colors.white))),
                    Expanded(
                        flex: 2,
                        child: Text(
                            ("type"),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                !.copyWith(color: Colors.white))),
                    const SizedBox(width: 12),
                    Center(
                        child: Text(
                            ("datetime"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .button
                                !.copyWith(color: Colors.white))),
                  ],
                ),
              ),
              Expanded(
                child: Pagination<GateTransactionModel>(
                  pageBuilder: (currentListSize) => gateStore.getPersonList(
                      customerId: widget.customerId ,
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
