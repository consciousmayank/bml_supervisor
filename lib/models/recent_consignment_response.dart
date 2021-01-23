// To parse this JSON data, do
//
//     final recentConginmentResponse = recentConginmentResponseFromJson(jsonString);

import 'dart:convert';

RecentConginmentResponse recentConginmentResponseFromJson(String str) =>
    RecentConginmentResponse.fromJson(json.decode(str));

String recentConginmentResponseToJson(RecentConginmentResponse data) =>
    json.encode(data.toJson());

class RecentConginmentResponse {
  RecentConginmentResponse({
    this.drivenKm,
    this.vehicleId,
    this.routeId,
    this.entryDate,
    this.trips,
    this.drivenKmG,
  });

  int drivenKm;
  String vehicleId;
  int routeId;
  String entryDate;
  int trips;
  int drivenKmG;

  factory RecentConginmentResponse.fromJson(Map<String, dynamic> json) =>
      RecentConginmentResponse(
        drivenKm: json["drivenKm"],
        drivenKmG: json["drivenKmG"],
        vehicleId: json["vehicleId"],
        routeId: json["routeId"],
        entryDate: json["entryDate"],
        trips: json["trips"],
      );

  Map<String, dynamic> toJson() => {
        "drivenKm": drivenKm,
        "drivenKmG": drivenKmG,
        "vehicleId": vehicleId,
        "routeId": routeId,
        "entryDate": entryDate,
        "trips": trips,
      };
}
