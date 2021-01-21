// To parse this JSON data, do
//
//     final routesDrivenKm = routesDrivenKmFromJson(jsonString);

import 'dart:convert';

RoutesDrivenKm routesDrivenKmFromJson(String str) =>
    RoutesDrivenKm.fromJson(json.decode(str));

String routesDrivenKmToJson(RoutesDrivenKm data) => json.encode(data.toJson());

class RoutesDrivenKm {
  RoutesDrivenKm({
    this.drivenKm,
    this.routeId,
    this.vehicleId,
    this.drivenKmG,
    this.title,
    this.entryDate,
  });

  int drivenKm;
  int routeId;
  String vehicleId;
  int drivenKmG;
  String title;
  String entryDate;

  factory RoutesDrivenKm.fromJson(Map<String, dynamic> json) => RoutesDrivenKm(
        drivenKm: json["drivenKm"],
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        drivenKmG: json["drivenKmG"],
        title: json["title"],
        entryDate: json["entryDate"],
      );

  Map<String, dynamic> toJson() => {
        "drivenKm": drivenKm,
        "routeId": routeId,
        "vehicleId": vehicleId,
        "drivenKmG": drivenKmG,
        "title": title,
        "entryDate": entryDate,
      };

  void getParticularRouteDateWithDrivenKm() {}
}
