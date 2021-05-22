// To parse this JSON data, do
//
//     final createConsignmentRequest = createConsignmentRequestFromMap(jsonString);

import 'dart:convert';

class CreateConsignmentRequest {
  CreateConsignmentRequest({
    this.itemUnit,
    this.dropOff,
    this.collect,
    this.payment = 0.00,
    this.clientId,
    this.routeId,
    this.vehicleId,
    this.entryDate,
    this.dispatchDateTime,
    this.title,
    this.routeTitle,
    this.items,
    this.weight,
  });

  final int clientId;
  final int routeId;
  final dynamic vehicleId;
  final String entryDate;
  final String dispatchDateTime;
  final String title;
  final String routeTitle;
  final int dropOff;
  final int collect;
  double payment;
  final List<Item> items;
  final String itemUnit;
  final double weight;

  CreateConsignmentRequest copyWith({
    int id,
    int clientId,
    int routeId,
    dynamic vehicleId,
    String entryDate,
    String dispatchDateTime,
    String title,
    String routeTitle,
    List<Item> items,
    final int dropOff,
    final int collect,
    final double payment,
    final String itemUnit,
    final double weight,
  }) =>
      CreateConsignmentRequest(
        clientId: clientId ?? this.clientId,
        routeId: routeId ?? this.routeId,
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        dispatchDateTime: dispatchDateTime ?? this.dispatchDateTime,
        title: title ?? this.title,
        routeTitle: routeTitle ?? this.routeTitle,
        items: items ?? this.items,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        dropOff: dropOff ?? this.dropOff,
        itemUnit: itemUnit ?? this.itemUnit,
        weight: weight ?? this.weight,
      );

  factory CreateConsignmentRequest.fromJson(String str) =>
      CreateConsignmentRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateConsignmentRequest.fromMap(Map<String, dynamic> json) =>
      CreateConsignmentRequest(
        clientId: json["clientId"],
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        dispatchDateTime: json["dispatchDateTime"],
        title: json["title"],
        routeTitle: json["routeTitle"],
        dropOff: json['dropOff'],
        collect: json['collect'],
        payment: json['payment'],
        itemUnit: json['itemUnit'],
        weight: json['weight'],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "clientId": clientId,
        "routeId": routeId,
        "vehicleId": vehicleId,
        "entryDate": entryDate,
        "dispatchDateTime": dispatchDateTime,
        "payment": payment,
        "collect": collect,
        "dropOff": dropOff,
        "title": title,
        "routeTitle": routeTitle,
        "itemUnit": itemUnit,
        "weight": weight,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };

  getTotalPayment() {
    double totalPayment = 0;
    if (this.items == null || this.items.length == 0) {
      return totalPayment;
    } else {
      this.items.forEach((element) {
        if (element.payment == null) {
          totalPayment = totalPayment + 0;
        } else {
          totalPayment = totalPayment + element.payment ?? 0;
        }
      });
    }
    return totalPayment;
  }
}

class Item {
  Item({
    this.hubTitle,
    this.hubCity,
    this.hubContactPerson,
    this.hubGeoLatitude,
    this.hubGeoLongitude,
    // this.id,
    this.hubId,
    this.sequence,
    this.title,
    this.dropOff,
    this.collect,
    this.payment,
    this.dropOffG,
    this.collectG,
    this.paymentG,
    this.paymentMode,
    this.paymentId,
    this.remarks,
    this.flag,
    this.collectError = false,
    this.dropOffError = false,
    this.paymentError = false,
    this.titleError = false,
  });

  // final int id;
  final int hubId;
  final int sequence;
  String title;
  int dropOff;
  int collect;
  double payment;
  final int dropOffG;
  final int collectG;
  final double paymentG;
  final int paymentMode;
  final String paymentId;
  String remarks;
  final String flag;
  final String hubTitle;
  final String hubCity;
  final String hubContactPerson;
  final double hubGeoLatitude;
  final double hubGeoLongitude;
  bool titleError, dropOffError, collectError, paymentError;
  Item copyWith({
    int id,
    int hubId,
    int sequence,
    dynamic title,
    int dropOff,
    int collect,
    double payment,
    int dropOffG,
    int collectG,
    double paymentG,
    int paymentMode,
    String paymentId,
    String remarks,
    String flag,
    String hubTitle,
    String hubCity,
    String hubContactPerson,
    double hubGeoLatitude,
    double hubGeoLongitude,
  }) =>
      Item(
        // id: id ?? this.id,
        hubId: hubId ?? this.hubId,
        sequence: sequence ?? this.sequence,
        title: title ?? this.title,
        dropOff: dropOff ?? this.dropOff,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        dropOffG: dropOffG ?? this.dropOffG,
        collectG: collectG ?? this.collectG,
        paymentG: paymentG ?? this.paymentG,
        paymentMode: paymentMode ?? this.paymentMode,
        paymentId: paymentId ?? this.paymentId,
        remarks: remarks ?? this.remarks,
        hubTitle: hubTitle ?? this.hubTitle,
        hubCity: hubCity ?? this.hubCity,
        hubContactPerson: hubContactPerson ?? this.hubContactPerson,
        hubGeoLatitude: hubGeoLatitude ?? this.hubGeoLatitude,
        hubGeoLongitude: hubGeoLongitude ?? this.hubGeoLongitude,
      );

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        // id: json["id"],
        hubId: json["hubId"],
        sequence: json["sequence"],
        title: json["title"],
        dropOff: json["dropOff"],
        collect: json["collect"],
        payment: json["payment"],
        dropOffG: json["dropOffG"],
        collectG: json["collectG"],
        paymentG: json["paymentG"],
        paymentMode: json["paymentMode"],
        paymentId: json["paymentId"],
        remarks: json["remarks"],
        flag: json["flag"],
        hubTitle: json["hubTitle"],
        hubCity: json["hubCity"],
        hubContactPerson: json["hubContactPerson"],
        hubGeoLatitude: json["hubGeoLatitude"],
        hubGeoLongitude: json["hubGeoLongitude"],
      );

  Map<String, dynamic> toMap() => {
        // "id": id,
        "hubId": hubId,
        "sequence": sequence,
        "title": title,
        "dropOff": dropOff,
        "collect": collect,
        "payment": payment,
        "dropOffG": dropOffG,
        "collectG": collectG,
        "paymentG": paymentG,
        "paymentMode": paymentMode,
        "paymentId": paymentId,
        "remarks": remarks,
        "flag": flag,
        "hubTitle": hubTitle,
        "hubCity": hubCity,
        "hubContactPerson": hubContactPerson,
        "hubGeoLatitude": hubGeoLatitude,
        "hubGeoLongitude": hubGeoLongitude,
      };
}
