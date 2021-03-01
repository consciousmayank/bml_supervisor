// To parse this JSON data, do
//
//     final consignmentDetailResponseNew = consignmentDetailResponseNewFromJson(jsonString);

import 'dart:convert';

ConsignmentDetailResponseNew consignmentDetailResponseNewFromJson(String str) =>
    ConsignmentDetailResponseNew.fromJson(json.decode(str));

String consignmentDetailResponseNewToJson(ConsignmentDetailResponseNew data) =>
    json.encode(data.toJson());

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
    this.dropOff,
    this.collect,
    this.payment,
    this.routeTitle,
  });

  int id;
  String clientId;
  String createBy;
  String assessBy;
  int routeId;
  String vehicleId;
  String entryDate;
  String title;
  String routeTitle;
  List<Item> items;
  List<Item> reviewedItems;
  final int dropOff;
  final int collect;

  final double payment;

  ConsignmentDetailResponseNew copyWith(
          {int id,
          String clientId,
          String createBy,
          String assessBy,
          int routeId,
          String vehicleId,
          String entryDate,
          String title,
          String routeTitle,
          List<Item> items,
          List<Item> reviewedItems,
          final int dropOff,
          final int collect,
          final double payment,
          final double hubGeoLatitude,
          final double hubGeoLongitude}) =>
      ConsignmentDetailResponseNew(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        createBy: createBy ?? this.createBy,
        assessBy: assessBy ?? this.assessBy,
        routeId: routeId ?? this.routeId,
        routeTitle: routeTitle ?? this.routeTitle,
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        title: title ?? this.title,
        items: items ?? this.items,
        reviewedItems: reviewedItems ?? this.reviewedItems,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        dropOff: dropOff ?? this.dropOff,
      );

  factory ConsignmentDetailResponseNew.fromJson(Map<String, dynamic> json) =>
      ConsignmentDetailResponseNew(
        id: json["id"],
        clientId: json["clientId"],
        createBy: json["createBy"],
        assessBy: json["assessBy"],
        routeId: json["routeId"],
        routeTitle: json["routeTitle"],
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        title: json["title"],
        dropOff: json['dropOff'],
        collect: json['collect'],
        payment: json['payment'],
        items: List<Item>.from(
          json["items"].map(
            (x) => Item.fromJson(x),
          ),
        ),
        reviewedItems: List<Item>.from(
          json["reviewedItems"].map(
            (x) => Item.fromJson(x),
          ),
        ),
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
        "reviewedItems":
            List<dynamic>.from(reviewedItems.map((x) => x.toJson())),
      };
}

class Item {
  Item(
      {this.consignmentId,
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
      this.hubCity,
      this.hubTitle,
      this.hubGeoLatitude,
      this.hubGeoLongitude,
      this.hubContactPerson});

  int consignmentId;
  String hubTitle;
  String hubCity;
  String hubContactPerson;
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
  final double hubGeoLatitude;
  final double hubGeoLongitude;

  Item copyWith(
          {int consignmentId,
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
          String hubCity,
          String hubTitle,
          String hubContactPerson,
          String lastupdated,
          double hubGeoLatitude,
          double hubGeoLongitude}) =>
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
        hubTitle: hubTitle ?? this.hubTitle,
        hubCity: hubCity ?? this.hubCity,
        hubGeoLongitude: hubGeoLongitude ?? this.hubGeoLongitude,
        hubGeoLatitude: hubGeoLatitude ?? this.hubGeoLatitude,
        hubContactPerson: hubContactPerson ?? this.hubContactPerson,
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
        hubTitle: json["hubTitle"],
        hubCity: json["hubCity"],
        hubGeoLongitude: json["hubGeoLongitude"],
        hubGeoLatitude: json["hubGeoLatitude"],
        hubContactPerson: json["hubContactPerson"],
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
        "hubTitle": hubTitle,
        "hubCity": hubCity,
        "hubContactPerson": hubContactPerson,
        "hubGeoLatitude": hubGeoLatitude,
        "hubGeoLongitude": hubGeoLongitude,
      };
}
