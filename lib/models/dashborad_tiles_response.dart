// To parse this JSON data, do
//
//     final dashboardTilesStatsResponse = dashboardTilesStatsResponseFromJson(jsonString);

import 'dart:convert';

DashboardTilesStatsResponse dashboardTilesStatsResponseFromJson(String str) =>
    DashboardTilesStatsResponse.fromJson(json.decode(str));

String dashboardTilesStatsResponseToJson(DashboardTilesStatsResponse data) =>
    json.encode(data.toJson());

class DashboardTilesStatsResponse {
  DashboardTilesStatsResponse({
    this.hubCount,
    this.kmCount,
    this.routeCount,
    this.dueCount,
  });

  int hubCount;
  int kmCount;
  int routeCount;
  int dueCount;

  factory DashboardTilesStatsResponse.fromJson(Map<String, dynamic> json) =>
      DashboardTilesStatsResponse(
        hubCount: json["hubCount"],
        kmCount: json["kmCount"],
        routeCount: json["routeCount"],
        dueCount: json["dueCount"],
      );

  Map<String, dynamic> toJson() => {
        "hubCount": hubCount,
        "kmCount": kmCount,
        "routeCount": routeCount,
        "dueCount": dueCount,
      };
}
