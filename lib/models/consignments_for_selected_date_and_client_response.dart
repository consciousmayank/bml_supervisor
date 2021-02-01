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
  ConsignmentsForSelectedDateAndClientResponse({
    this.routeTitle,
    this.consigmentId,
    this.routeId,
    this.vehicleId,
  });

  String routeTitle;
  int consigmentId;
  int routeId;
  String vehicleId;

  factory ConsignmentsForSelectedDateAndClientResponse.fromMap(
          Map<String, dynamic> json) =>
      ConsignmentsForSelectedDateAndClientResponse(
        routeTitle: json["routeTitle"],
        consigmentId: json["consigmentId"],
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
      );

  Map<String, dynamic> toMap() => {
        "routeTitle": routeTitle,
        "consigmentId": consigmentId,
        "routeId": routeId,
        "vehicleId": vehicleId,
      };
}
