// To parse this JSON data, do
//
//     final viewEntryRequest = viewEntryResponseFromJson(jsonString);

import 'dart:convert';

ViewEntryRequest viewEntryRequestFromJson(String str) =>
    ViewEntryRequest.fromJson(json.decode(str));

String viewEntryRequestToJson(ViewEntryRequest data) =>
    json.encode(data.toJson());

class ViewEntryRequest {
  ViewEntryRequest({
    this.vehicleId,
    this.clientId,
    this.period,
  });

  String vehicleId;
  String clientId;
  String period;

  factory ViewEntryRequest.fromJson(String str) =>
      ViewEntryRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewEntryRequest.fromMap(Map<String, dynamic> json) =>
      ViewEntryRequest(
        vehicleId: json["vehicleId"],
        clientId: json["clientId"],
        period: json["period"],
      );

  Map<String, dynamic> toMap() => {
        "vehicleId": vehicleId,
        "clientId": clientId,
        "period": period,
      };
}
