// To parse this JSON data, do
//
//     final consignmentDetailResponseNew = consignmentDetailResponseNewFromJson(jsonString);

import 'dart:convert';

ConsignmentDetailResponseNew consignmentDetailResponseNewFromJson(String str) => ConsignmentDetailResponseNew.fromJson(json.decode(str));

String consignmentDetailResponseNewToJson(ConsignmentDetailResponseNew data) => json.encode(data.toJson());

class ConsignmentDetailResponseNew {
  ConsignmentDetailResponseNew({
    this.id,
    this.clientId,
    this.createBy,
    this.assessBy,
    this.routeId,
    this.vehicleId,
    this.entryDate,
    this.title,
    this.items,
    this.reviewedItems,
  });

  int id;
  int clientId;
  String createBy;
  String assessBy;
  int routeId;
  String vehicleId;
  String entryDate;
  String title;
  List<Item> items;
  List<Item> reviewedItems;

  ConsignmentDetailResponseNew copyWith({
    int id,
    int clientId,
    String createBy,
    String assessBy,
    int routeId,
    String vehicleId,
    String entryDate,
    String title,
    List<Item> items,
    List<Item> reviewedItems,
  }) =>
      ConsignmentDetailResponseNew(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        createBy: createBy ?? this.createBy,
        assessBy: assessBy ?? this.assessBy,
        routeId: routeId ?? this.routeId,
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        title: title ?? this.title,
        items: items ?? this.items,
        reviewedItems: reviewedItems ?? this.reviewedItems,
      );

  factory ConsignmentDetailResponseNew.fromJson(Map<String, dynamic> json) => ConsignmentDetailResponseNew(
    id: json["id"],
    clientId: json["clientId"],
    createBy: json["createBy"],
    assessBy: json["assessBy"],
    routeId: json["routeId"],
    vehicleId: json["vehicleId"],
    entryDate: json["entryDate"],
    title: json["title"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    reviewedItems: List<Item>.from(json["reviewedItems"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clientId": clientId,
    "createBy": createBy,
    "assessBy": assessBy,
    "routeId": routeId,
    "vehicleId": vehicleId,
    "entryDate": entryDate,
    "title": title,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "reviewedItems": List<dynamic>.from(reviewedItems.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    this.consignmentId,
    this.hubId,
    this.sequence,
    this.title,
    this.dropOff,
    this.collect,
    this.payment,
    this.paymentMode,
    this.paymentId,
    this.remarks,
    this.flag,
    this.lastupdated,
  });

  int consignmentId;
  int hubId;
  int sequence;
  String title;
  int dropOff;
  int collect;
  double payment;
  int paymentMode;
  String paymentId;
  String remarks;
  String flag;
  String lastupdated;

  Item copyWith({
    int consignmentId,
    int hubId,
    int sequence,
    String title,
    int dropOff,
    int collect,
    double payment,
    int paymentMode,
    String paymentId,
    String remarks,
    String flag,
    String lastupdated,
  }) =>
      Item(
        consignmentId: consignmentId ?? this.consignmentId,
        hubId: hubId ?? this.hubId,
        sequence: sequence ?? this.sequence,
        title: title ?? this.title,
        dropOff: dropOff ?? this.dropOff,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        paymentMode: paymentMode ?? this.paymentMode,
        paymentId: paymentId ?? this.paymentId,
        remarks: remarks ?? this.remarks,
        flag: flag ?? this.flag,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    consignmentId: json["consignmentId"],
    hubId: json["hubId"],
    sequence: json["sequence"],
    title: json["title"],
    dropOff: json["dropOff"],
    collect: json["collect"],
    payment: json["payment"],
    paymentMode: json["paymentMode"],
    paymentId: json["paymentId"],
    remarks: json["remarks"],
    flag: json["flag"],
    lastupdated: json["lastupdated"],
  );

  Map<String, dynamic> toJson() => {
    "consignmentId": consignmentId,
    "hubId": hubId,
    "sequence": sequence,
    "title": title,
    "dropOff": dropOff,
    "collect": collect,
    "payment": payment,
    "paymentMode": paymentMode,
    "paymentId": paymentId,
    "remarks": remarks,
    "flag": flag,
    "lastupdated": lastupdated,
  };
}
