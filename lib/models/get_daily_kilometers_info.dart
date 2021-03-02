// To parse this JSON data, do
//
//     final getDailyKilometerInfo = getDailyKilometerInfoFromMap(jsonString);

import 'dart:convert';

class GetDailyKilometerInfo {
  GetDailyKilometerInfo({
    this.routeTitle,
    this.vehicleId,
    this.clientId,
    this.routeId,
  });

  final String routeTitle;
  final String vehicleId;
  final String clientId;
  final int routeId;

  GetDailyKilometerInfo copyWith({
    String routeTitle,
    String vehicleId,
    String clientId,
    int routeId,
  }) =>
      GetDailyKilometerInfo(
        routeTitle: routeTitle ?? this.routeTitle,
        vehicleId: vehicleId ?? this.vehicleId,
        clientId: clientId ?? this.clientId,
        routeId: routeId ?? this.routeId,
      );

  factory GetDailyKilometerInfo.fromJson(String str) =>
      GetDailyKilometerInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDailyKilometerInfo.fromMap(Map<String, dynamic> json) =>
      GetDailyKilometerInfo(
        routeTitle: json["routeTitle"],
        vehicleId: json["vehicleId"],
        clientId: json["clientId"],
        routeId: json["routeId"],
      );

  Map<String, dynamic> toMap() => {
        "routeTitle": routeTitle,
        "vehicleId": vehicleId,
        "clientId": clientId,
        "routeId": routeId,
      };
}
