// To parse this JSON data, do
//
//     final createConsignmentRequest = createConsignmentRequestFromMap(jsonString);

import 'dart:convert';

class CreateConsignmentRequest {
  CreateConsignmentRequest({
    this.clientId,
    this.routeId,
    this.vehicleId,
    this.entryDate,
    this.title,
    this.items,
  });

  final int clientId;
  final int routeId;
  final dynamic vehicleId;
  final String entryDate;
  final String title;
  final List<Item> items;

  CreateConsignmentRequest copyWith({
    int id,
    int clientId,
    int routeId,
    dynamic vehicleId,
    String entryDate,
    String title,
    List<Item> items,
  }) =>
      CreateConsignmentRequest(
        clientId: clientId ?? this.clientId,
        routeId: routeId ?? this.routeId,
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        title: title ?? this.title,
        items: items ?? this.items,
      );

  double findGrandTotal() {
    double grandTotal = 0;
    this.items.forEach((element) {
      print("grand total before :: ${grandTotal}");
      grandTotal = grandTotal + element.payment;
      print("grand total after  :: ${grandTotal}");
    });
    print("grand total after everything  :: ${grandTotal}");
  }

  factory CreateConsignmentRequest.fromJson(String str) =>
      CreateConsignmentRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateConsignmentRequest.fromMap(Map<String, dynamic> json) =>
      CreateConsignmentRequest(
        clientId: json["clientId"],
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        title: json["title"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "clientId": clientId,
        "routeId": routeId,
        "vehicleId": vehicleId,
        "entryDate": entryDate,
        "title": title,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

class Item {
  Item({
    this.id,
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
  });

  final int id;
  final int hubId;
  final int sequence;
  final dynamic title;
  final int dropOff;
  final int collect;
  final double payment;
  final int dropOffG;
  final int collectG;
  final double paymentG;
  final int paymentMode;
  final String paymentId;
  final String remarks;
  final String flag;

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
  }) =>
      Item(
        id: id ?? this.id,
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
        flag: flag ?? this.flag,
      );

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
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
      );

  Map<String, dynamic> toMap() => {
        "id": id,
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
      };
}
