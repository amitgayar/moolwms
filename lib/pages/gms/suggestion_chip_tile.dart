import 'package:flutter/material.dart';
import 'package:moolwms/pages/gms/model/gate_transactional_model.dart';

Widget chipTile({required String child}) {
  return Container(
    width: 80,
    // height: 100,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        color: Colors.blue[100]),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(child: Text(child)),
        // Text(child.vehicle.vehicleNumber??''),
      ],
    ),


  );
}

Widget chipTileBox({GateTransactionModel? data, Function(List<String>)? callback, showMobile = true, showVehicle = true}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 150,
      // height: 100,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          color: Colors.blue[100]!.withOpacity(0.5)),
      child: InkWell(
        splashColor: Colors.blue,
        onTap: (){
          callback!([data?.person?.mobileNo?.number??'', data?.vehicle?.vehicleNumber??'']);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(child: Text(data?.person?.fullName??'')),
            if(showMobile)FittedBox(child: Text(data?.person?.mobileNo?.number??'')),
            // if(showVehicle)
              FittedBox(child: Text(data?.vehicle?.vehicleNumber??'')),
            // FittedBox(child: Text(data?.transactionType.toString())),
            // Text(child.vehicle.vehicleNumber??''),
          ],
        ),
      ),


    ),
  );
}
