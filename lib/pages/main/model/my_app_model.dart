import 'package:moolwms/utils/dev_utils.dart';

class MyAppModelData {

  int? orderId;
  int? assetId;
  int? assetItemCount;
  String? assetName;
  String? orderStatus;
  int? clientId;
  String? clientName;
  String? driverName;
  String? driverNumber;
  String? vehicleNumber;
  int? clientLocationId;
  String? clientLocationName;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  String? receivedByWhom;
  String? updatedBy;
  String? colorCode;
  String? orderTripId;

  MyAppModelData(
      {this.orderId,
      this.assetId,
      this.assetItemCount,
      this.assetName,
      this.orderStatus,
      this.clientId,
      this.clientName,
      this.driverName,
      this.driverNumber,
      this.vehicleNumber,
      this.clientLocationId,
      this.clientLocationName,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.receivedByWhom,
      this.colorCode,
      this.orderTripId});

  MyAppModelData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id']?.toInt();
    assetId = json['asset_id']?.toInt();
    assetItemCount = json['item_count']?.toInt();
    assetName = json['asset_name']?.toString();
    orderStatus = json['order_status']?.toString();
    clientId = json['client_id']?.toInt();
    clientName = json['client_name']?.toString();
    driverName = json['driver_name']?.toString();
    driverNumber = json['driver_number']?.toString();
    vehicleNumber = json['vehicle_number']?.toString();
    clientLocationId = json['client_location_id']?.toInt();
    clientLocationName = json['client_location_name']?.toString();
    isDeleted = json['is_deleted']?.toInt();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    createdBy = json['created_by']?.toInt();
    updatedBy = json['updated_by']?.toString();
    receivedByWhom = json['received_by_whom']?.toString();
    colorCode = json['colour_code']?.toString();
    orderTripId = json['order_trip_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['asset_id'] = assetId;
    data['item_count'] = assetItemCount;
    data['asset_name'] = assetName;
    data['order_status'] = orderStatus;
    data['client_id'] = clientId;
    data['client_name'] = clientName;
    data['driver_name'] = driverName;
    data['driver_number'] = driverNumber;
    data['vehicle_number'] = vehicleNumber;
    data['client_location_id'] = clientLocationId;
    data['client_location_name'] = clientLocationName;
    data['is_deleted'] = isDeleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['received_by_whom'] = receivedByWhom;
    data['colour_code'] = colorCode;
    data['order_trip_id'] = orderTripId;

    return data;
  }
}

class MyAppModelMeta {
/*
{
  "status": true,
  "message": "List fetched successfully!",
  "code": 200
}
*/

  bool? status;
  String? message;
  int? code;

  MyAppModelMeta({
    this.status,
    this.message,
    this.code,
  });

  MyAppModelMeta.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    code = json['code']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['code'] = code;
    return data;
  }
}

class MyAppModel {
/*
{
  "meta": {
    "status": true,
    "message": "List fetched successfully!",
    "code": 200
  },
  "data": [
    {
      "order_id": 1,
      "asset_id": 1,
      "asset_item_count": 14,
      "asset_name": "Coolbox 1",
      "order_status": "Assignment Pending",
      "client_id": 1,
      "client_name": "Client 1",
      "driver_name": "S",
      "driver_number": "8262980000",
      "vehicle_number": "HP22D3867",
      "client_location_id": 1,
      "client_location_name": "Hamirpur",
      "is_deleted": 0,
      "created_at": "2022-06-22T05:30:14.000Z",
      "updated_at": null,
      "created_by": 1,
      "updated_by": null
    }
  ],
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7InVzZXJJZCI6MSwidXNlck5hbWUiOiJTaHViaGFtIiwidXNlckVtYWlsIjoic2h1YmhhbUBtb29sY29kZS5jb20iLCJ1c2VyUm9sZSI6IkNsaWVudCIsInVzZXJTdGF0dXMiOiJBY3RpdmUiLCJkZXZpY2VUeXBlIjpudWxsLCJkZXZpY2VWZXJzaW9uIjpudWxsfSwiaWF0IjoxNjU1OTAwNzU2fQ.MFko0Yxy74ggDKqW_OqA-NTwOwhUSSkyvZJyHpiOYg8"
}
*/

  MyAppModelMeta? meta;
  List<MyAppModelData?>? data;
  String? token;

  MyAppModel({
    this.meta,
    this.data,
    this.token,
  });

  MyAppModel.fromJson(Map<String, dynamic> json) {
    meta = (json['meta'] != null)
        ? MyAppModelMeta.fromJson(json['meta'])
        : null;
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <MyAppModelData>[];
      if (
          // v.runtimeType == List &&
          json['meta']['code'] == 200) {
        for (var temp in v) {
          arr0.add(MyAppModelData.fromJson(temp));
        }
      } else {
        logPrint.e("listCheck json[data] runtimeType failed: ${v.runtimeType}");
      }
      data = arr0;
    }
    token = json['token']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['data'] = arr0;
    }
    data['token'] = token;
    return data;
  }
}


