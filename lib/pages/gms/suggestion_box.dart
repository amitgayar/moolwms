import 'package:flutter/material.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';
import 'package:moolwms/pages/gms/suggestion_chip_tile.dart';
import 'package:moolwms/utils/dev_utils.dart';


class SuggestionBox extends StatefulWidget {
  const SuggestionBox ({Key? key, this.isMobileNoVerified, this.onClick, required this.transactionType}): super(key: key);
  final Function(dynamic)? onClick;
  final bool? isMobileNoVerified;
  final int? transactionType;

  @override
  SuggestionBoxState createState() => SuggestionBoxState();
}

class SuggestionBoxState extends State<SuggestionBox> {
  GateStore gateStore = GateStore();
  bool isMobileNoVerified = false;

  @override
  void initState() {
    super.initState();
    isMobileNoVerified = widget.isMobileNoVerified!;
    getVehicleProductList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // todo: CHECK - transaction type??? -- transactionType == 1 ? "IN" : "OUT",
    int transactionType = widget.transactionType!;
    var pvList = (gateStore.vehicleProductList??[]).where((e) => e.transactionType == transactionType && e.person !=null).toList();
    // var pvList = (gateStore.vehicleProductList??[]);

    return gateStore.vehicleProductList != null
        && gateStore.vehicleProductList.isNotEmpty
        ?
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Wrap(
                children: List<Widget>.generate(pvList.length, (index) {
                  var data = pvList[index];
                  return chipTileBox(
                    callback: (val){
                      widget.onClick!(val);
                      logPrint.w('val : $val');
                    },
                    data: data,
                    //todo : CHECK NEW
                    showVehicle: widget.isMobileNoVerified,
                    // showVehicle: true,
                  );
                }).toList(),
              ),
            ),
          ),
        )

        :const Center(child: CircularProgressIndicator(),);
  }


  getVehicleProductList() async{
    var list = await gateStore.getVehicleProductList(limit: 100, transactionType:widget.transactionType! );
    setState(() {});
    return list;
  }

  ///old apis
  getAllVehicles() async{
    // return [];
    var vehicleList = await gateStore.getVehicleList(limit: 100);
    return vehicleList;

  }
  getAllPersons() async{
    var personList = await gateStore.getPersonList(limit: 100);
    return personList;
  }

}


