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
    this.totalKm,
    this.routeCount,
    this.dueKm,
    this.dueExpense,
    this.totalExpense,
  });

  int hubCount;
  int totalKm;
  int routeCount;
  int dueKm;
  double totalExpense;
  double dueExpense;

  factory DashboardTilesStatsResponse.fromJson(Map<String, dynamic> json) =>
      DashboardTilesStatsResponse(
        hubCount: json["hubCount"],
        totalKm: json["totalKm"],
        routeCount: json["routeCount"],
        dueKm: json["dueKm"],
        totalExpense: json["totalExpense"],
        dueExpense: json["dueExpense"],
      );

  Map<String, dynamic> toJson() => {
        "hubCount": hubCount,
        "totalKm": totalKm,
        "routeCount": routeCount,
        "dueKm": dueKm,
        "totalExpense": totalExpense,
        "dueExpense": dueExpense,
      };
}
