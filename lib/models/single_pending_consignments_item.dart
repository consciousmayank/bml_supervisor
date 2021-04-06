// To parse this JSON data, do
//
//     final singlePendingConsignmentListItem = singlePendingConsignmentListItemFromMap(jsonString);

import 'dart:convert';

class SinglePendingConsignmentListItem {
  SinglePendingConsignmentListItem({
    this.consigmentId,
    this.routeId,
    this.entryDate,
    this.dropOff,
    this.routeTitle,
    this.payment,
    this.vehicleId,
    this.collect,
  });

  final int consigmentId;
  final int routeId;
  final String entryDate;
  final int dropOff;
  final String routeTitle;
  final double payment;
  final String vehicleId;
  final int collect;

  SinglePendingConsignmentListItem copyWith({
    int consigmentId,
    int routeId,
    String entryDate,
    int dropOff,
    String routeTitle,
    double payment,
    String vehicleId,
    int collect,
  }) =>
      SinglePendingConsignmentListItem(
        consigmentId: consigmentId ?? this.consigmentId,
        routeId: routeId ?? this.routeId,
        entryDate: entryDate ?? this.entryDate,
        dropOff: dropOff ?? this.dropOff,
        routeTitle: routeTitle ?? this.routeTitle,
        payment: payment ?? this.payment,
        vehicleId: vehicleId ?? this.vehicleId,
        collect: collect ?? this.collect,
      );

  factory SinglePendingConsignmentListItem.fromJson(String str) =>
      SinglePendingConsignmentListItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SinglePendingConsignmentListItem.fromMap(Map<String, dynamic> json) =>
      SinglePendingConsignmentListItem(
        consigmentId: json["consigmentId"],
        routeId: json["routeId"],
        entryDate: json["entryDate"],
        dropOff: json["dropOff"],
        routeTitle: json["routeTitle"],
        payment: json["payment"],
        vehicleId: json["vehicleId"],
        collect: json["collect"],
      );

  Map<String, dynamic> toMap() => {
        "consigmentId": consigmentId,
        "routeId": routeId,
        "entryDate": entryDate,
        "dropOff": dropOff,
        "routeTitle": routeTitle,
        "payment": payment,
        "vehicleId": vehicleId,
        "collect": collect,
      };
}
