// To parse this JSON data, do
//
//     final consignmentsForSelectedDateAndClientResponse = consignmentsForSelectedDateAndClientResponseFromMap(jsonString);

import 'dart:convert';

List<ConsignmentsForSelectedDateAndClientResponse>
consignmentsForSelectedDateAndClientResponseFromMap(String str) =>
    List<ConsignmentsForSelectedDateAndClientResponse>.from(json
        .decode(str)
        .map((x) =>
        ConsignmentsForSelectedDateAndClientResponse.fromMap(x)));

String consignmentsForSelectedDateAndClientResponseToMap(
    List<ConsignmentsForSelectedDateAndClientResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ConsignmentsForSelectedDateAndClientResponse {
  ConsignmentsForSelectedDateAndClientResponse(
      {this.routeTitle,
        this.consigmentId,
        this.routeId,
        this.vehicleId,
        this.payment,
        this.collect,
        this.dropOff});

  String routeTitle;
  int consigmentId;
  int routeId;
  int dropOff;
  int collect;
  double payment;
  String vehicleId;

  factory ConsignmentsForSelectedDateAndClientResponse.fromMap(
      Map<String, dynamic> json) =>
      ConsignmentsForSelectedDateAndClientResponse(
        routeTitle: json["routeTitle"],
        consigmentId: json["consigmentId"],
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        collect: json["collect"],
        dropOff: json["dropOff"],
        payment: json["payment"],
      );

  Map<String, dynamic> toMap() => {
    "routeTitle": routeTitle,
    "consigmentId": consigmentId,
    "routeId": routeId,
    "vehicleId": vehicleId,
    "collect": collect,
    "dropOff": dropOff,
    "payment": payment,
  };
}
