// To parse this JSON data, do
//
//     final consignmentTrackingStatusResponse = consignmentTrackingStatusResponseFromMap(jsonString);

import 'dart:convert';

class ConsignmentTrackingStatusResponse {
  ConsignmentTrackingStatusResponse(
      {this.dstLocation,
      this.consignmentDate,
      this.itemUnit,
      this.consignmentId,
      this.routeTitle,
      this.srcLocation,
      this.itemDrop,
      this.dispatchDateTime,
      this.routeId,
      this.itemCollect,
      this.consignmentTitle,
      this.payment,
      this.vehicleId,
      this.itemWeight,
      this.statusCode,
      this.isSelected = false});

  final int dstLocation;
  final String consignmentDate;
  final String itemUnit;
  final int consignmentId;
  final String routeTitle;
  final int srcLocation;
  final int itemDrop;
  final String dispatchDateTime;
  final int routeId;
  final int itemCollect;
  final String consignmentTitle;
  final double payment;
  final String vehicleId;
  final double itemWeight;
  final int statusCode;
  bool isSelected;

  ConsignmentTrackingStatusResponse copyWith({
    int dstLocation,
    String consignmentDate,
    String itemUnit,
    int consignmentId,
    String routeTitle,
    int srcLocation,
    int itemDrop,
    String dispatchDateTime,
    int routeId,
    int itemCollect,
    String consignmentTitle,
    double payment,
    String vehicleId,
    double itemWeight,
    int statusCode,
  }) =>
      ConsignmentTrackingStatusResponse(
        dstLocation: dstLocation ?? this.dstLocation,
        consignmentDate: consignmentDate ?? this.consignmentDate,
        itemUnit: itemUnit ?? this.itemUnit,
        consignmentId: consignmentId ?? this.consignmentId,
        routeTitle: routeTitle ?? this.routeTitle,
        srcLocation: srcLocation ?? this.srcLocation,
        itemDrop: itemDrop ?? this.itemDrop,
        dispatchDateTime: dispatchDateTime ?? this.dispatchDateTime,
        routeId: routeId ?? this.routeId,
        itemCollect: itemCollect ?? this.itemCollect,
        consignmentTitle: consignmentTitle ?? this.consignmentTitle,
        payment: payment ?? this.payment,
        vehicleId: vehicleId ?? this.vehicleId,
        itemWeight: itemWeight ?? this.itemWeight,
        statusCode: statusCode ?? this.statusCode,
      );

  factory ConsignmentTrackingStatusResponse.fromJson(String str) =>
      ConsignmentTrackingStatusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsignmentTrackingStatusResponse.fromMap(
          Map<String, dynamic> json) =>
      ConsignmentTrackingStatusResponse(
        dstLocation: json["dstLocation"],
        consignmentDate: json["consignmentDate"],
        itemUnit: json["itemUnit"],
        consignmentId: json["consignmentId"],
        routeTitle: json["routeTitle"],
        srcLocation: json["srcLocation"],
        itemDrop: json["itemDrop"],
        dispatchDateTime: json["dispatchDateTime"],
        routeId: json["routeId"],
        itemCollect: json["itemCollect"],
        consignmentTitle: json["consignmentTitle"],
        payment: json["payment"],
        vehicleId: json["vehicleId"],
        itemWeight: json["itemWeight"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toMap() => {
        "dstLocation": dstLocation,
        "consignmentDate": consignmentDate,
        "itemUnit": itemUnit,
        "consignmentId": consignmentId,
        "routeTitle": routeTitle,
        "srcLocation": srcLocation,
        "itemDrop": itemDrop,
        "dispatchDateTime": dispatchDateTime,
        "routeId": routeId,
        "itemCollect": itemCollect,
        "consignmentTitle": consignmentTitle,
        "payment": payment,
        "vehicleId": vehicleId,
        "itemWeight": itemWeight,
        "statusCode": statusCode,
      };
}
