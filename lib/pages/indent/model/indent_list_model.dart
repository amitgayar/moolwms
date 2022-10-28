class IndentListModelDataIndentList {
/*
{
  "id": 101,
  "indent_number": "#IND2208300099",
  "request_type": "INWARD",
  "service_date": "2022-05-12T00:00:00.000Z",
  "fk_dock_id": 1,
  "driver_name": null,
  "driver_mobile_number": "+919899543112",
  "vehicle_number": "CD GK ki h",
  "status": "PENDING",
  "created_by_id": 38,
  "location_id": 53,
  "assigned_to_id": null,
  "assigned_by_id": null,
  "remarks": "testing by dev",
  "service_slot": "03:00 AM - 04:00 AM",
  "is_deleted": 0,
  "fk_id_org": 1,
  "other_doc_url": "",
  "eway_doc_url": "",
  "invoice_doc_url": "",
  "is_active": 0,
  "created_date": "2022-08-30T13:37:06.000Z",
  "last_modified_date": "0000-00-00 00:00:00"
}
*/

  int? id;
  String? indentNumber;
  String? requestType;
  String? serviceDate;
  int? fkDockId;
  String? driverName;
  String? driverMobileNumber;
  String? vehicleNumber;
  String? status;
  int? createdById;
  int? locationId;
  String? assignedToId;
  String? assignedById;
  String? remarks;
  String? serviceSlot;
  int? isDeleted;
  int? fkIdOrg;
  String? otherDocUrl;
  String? ewayDocUrl;
  String? invoiceDocUrl;
  int? isActive;
  String? createdDate;
  String? lastModifiedDate;

  IndentListModelDataIndentList({
    this.id,
    this.indentNumber,
    this.requestType,
    this.serviceDate,
    this.fkDockId,
    this.driverName,
    this.driverMobileNumber,
    this.vehicleNumber,
    this.status,
    this.createdById,
    this.locationId,
    this.assignedToId,
    this.assignedById,
    this.remarks,
    this.serviceSlot,
    this.isDeleted,
    this.fkIdOrg,
    this.otherDocUrl,
    this.ewayDocUrl,
    this.invoiceDocUrl,
    this.isActive,
    this.createdDate,
    this.lastModifiedDate,
  });
  IndentListModelDataIndentList.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    indentNumber = json['indent_number']?.toString();
    requestType = json['request_type']?.toString();
    serviceDate = json['service_date']?.toString();
    fkDockId = json['fk_dock_id']?.toInt();
    driverName = json['driver_name']?.toString();
    driverMobileNumber = json['driver_mobile_number']?.toString();
    vehicleNumber = json['vehicle_number']?.toString();
    status = json['status']?.toString();
    createdById = json['created_by_id']?.toInt();
    locationId = json['location_id']?.toInt();
    assignedToId = json['assigned_to_id']?.toString();
    assignedById = json['assigned_by_id']?.toString();
    remarks = json['remarks']?.toString();
    serviceSlot = json['service_slot']?.toString();
    isDeleted = json['is_deleted']?.toInt();
    fkIdOrg = json['fk_id_org']?.toInt();
    otherDocUrl = json['other_doc_url']?.toString();
    ewayDocUrl = json['eway_doc_url']?.toString();
    invoiceDocUrl = json['invoice_doc_url']?.toString();
    isActive = json['is_active']?.toInt();
    createdDate = json['created_date']?.toString();
    lastModifiedDate = json['last_modified_date']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['indent_number'] = indentNumber;
    data['request_type'] = requestType;
    data['service_date'] = serviceDate;
    data['fk_dock_id'] = fkDockId;
    data['driver_name'] = driverName;
    data['driver_mobile_number'] = driverMobileNumber;
    data['vehicle_number'] = vehicleNumber;
    data['status'] = status;
    data['created_by_id'] = createdById;
    data['location_id'] = locationId;
    data['assigned_to_id'] = assignedToId;
    data['assigned_by_id'] = assignedById;
    data['remarks'] = remarks;
    data['service_slot'] = serviceSlot;
    data['is_deleted'] = isDeleted;
    data['fk_id_org'] = fkIdOrg;
    data['other_doc_url'] = otherDocUrl;
    data['eway_doc_url'] = ewayDocUrl;
    data['invoice_doc_url'] = invoiceDocUrl;
    data['is_active'] = isActive;
    data['created_date'] = createdDate;
    data['last_modified_date'] = lastModifiedDate;
    return data;
  }
}

class IndentListModelData {
/*
{
  "total": 101,
  "pageSize": 4,
  "offset": 0,
  "to": 4,
  "last_page": 26,
  "pageNumber": 1,
  "from": 0,
  "indentList": [
    {
      "id": 101,
      "indent_number": "#IND2208300099",
      "request_type": "INWARD",
      "service_date": "2022-05-12T00:00:00.000Z",
      "fk_dock_id": 1,
      "driver_name": null,
      "driver_mobile_number": "+919899543112",
      "vehicle_number": "CD GK ki h",
      "status": "PENDING",
      "created_by_id": 38,
      "location_id": 53,
      "assigned_to_id": null,
      "assigned_by_id": null,
      "remarks": "testing by dev",
      "service_slot": "03:00 AM - 04:00 AM",
      "is_deleted": 0,
      "fk_id_org": 1,
      "other_doc_url": "",
      "eway_doc_url": "",
      "invoice_doc_url": "",
      "is_active": 0,
      "created_date": "2022-08-30T13:37:06.000Z",
      "last_modified_date": "0000-00-00 00:00:00"
    }
  ]
}
*/

  int? total;
  int? pageSize;
  int? offset;
  int? to;
  int? lastPage;
  int? pageNumber;
  int? from;
  List<IndentListModelDataIndentList?>? indentList;

  IndentListModelData({
    this.total,
    this.pageSize,
    this.offset,
    this.to,
    this.lastPage,
    this.pageNumber,
    this.from,
    this.indentList,
  });
  IndentListModelData.fromJson(Map<String, dynamic> json) {
    total = json['total']?.toInt();
    pageSize = json['pageSize']?.toInt();
    offset = json['offset']?.toInt();
    to = json['to']?.toInt();
    lastPage = json['last_page']?.toInt();
    pageNumber = json['pageNumber']?.toInt();
    from = json['from']?.toInt();
    if (json['indentList'] != null) {
      final v = json['indentList'];
      final arr0 = <IndentListModelDataIndentList>[];
      v.forEach((v) {
        arr0.add(IndentListModelDataIndentList.fromJson(v));
      });
      indentList = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['pageSize'] = pageSize;
    data['offset'] = offset;
    data['to'] = to;
    data['last_page'] = lastPage;
    data['pageNumber'] = pageNumber;
    data['from'] = from;
    if (indentList != null) {
      final v = indentList;
      final arr0 = [];
      v?.forEach((v) {
        arr0.add(v?.toJson());
      });
      data['indentList'] = arr0;
    }
    return data;
  }
}

class IndentListModelMeta {
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

  IndentListModelMeta({
    this.status,
    this.message,
    this.code,
  });
  IndentListModelMeta.fromJson(Map<String, dynamic> json) {
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

class IndentListModel {
/*
{
  "meta": {
    "status": true,
    "message": "List fetched successfully!",
    "code": 200
  },
  "data": {
    "total": 101,
    "pageSize": 4,
    "offset": 0,
    "to": 4,
    "last_page": 26,
    "pageNumber": 1,
    "from": 0,
    "indentList": [
      {
        "id": 101,
        "indent_number": "#IND2208300099",
        "request_type": "INWARD",
        "service_date": "2022-05-12T00:00:00.000Z",
        "fk_dock_id": 1,
        "driver_name": null,
        "driver_mobile_number": "+919899543112",
        "vehicle_number": "CD GK ki h",
        "status": "PENDING",
        "created_by_id": 38,
        "location_id": 53,
        "assigned_to_id": null,
        "assigned_by_id": null,
        "remarks": "testing by dev",
        "service_slot": "03:00 AM - 04:00 AM",
        "is_deleted": 0,
        "fk_id_org": 1,
        "other_doc_url": "",
        "eway_doc_url": "",
        "invoice_doc_url": "",
        "is_active": 0,
        "created_date": "2022-08-30T13:37:06.000Z",
        "last_modified_date": "0000-00-00 00:00:00"
      }
    ]
  },
  "token": "RYRohWEBw6T89ol0JrYd6GB87ELNdseizsAGmDO9qxmKKqGum08AyyDaMs3ojlqX"
}
*/

  IndentListModelMeta? meta;
  IndentListModelData? data;
  String? token;

  IndentListModel({
    this.meta,
    this.data,
    this.token,
  });
  IndentListModel.fromJson(Map<String, dynamic> json) {
    meta = (json['meta'] != null) ? IndentListModelMeta.fromJson(json['meta']) : null;
    data = (json['data'] != null) ? IndentListModelData.fromJson(json['data']) : null;
    token = json['token']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta?.toJson();
    }
    data['data'] = this.data?.toJson();
    data['token'] = token;
    return data;
  }
}
