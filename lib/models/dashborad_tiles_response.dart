// To parse this JSON data, do
//
//     final dashboardTilesStatsResponse = dashboardTilesStatsResponseFromJson(jsonString);

import 'dart:convert';

DashboardTilesStatsResponse dashboardTilesStatsResponseFromJson(String str) => DashboardTilesStatsResponse.fromJson(json.decode(str));

String dashboardTilesStatsResponseToJson(DashboardTilesStatsResponse data) => json.encode(data.toJson());

class DashboardTilesStatsResponse {
  DashboardTilesStatsResponse({
    this.totalKmVariance,
    this.totalExpenseVariance,
    this.hubCount,
    this.totalKm,
    this.routeCount,
    this.dueKm,
    this.totalExpense,
    this.dueExpense,
  });

  double totalKmVariance;
  double totalExpenseVariance;
  int hubCount;
  int totalKm;
  int routeCount;
  int dueKm;
  double totalExpense;
  double dueExpense;

  DashboardTilesStatsResponse copyWith({
    double totalKmVariance,
    double totalExpenseVariance,
    int hubCount,
    int totalKm,
    int routeCount,
    int dueKm,
    double totalExpense,
    double dueExpense,
  }) =>
      DashboardTilesStatsResponse(
        totalKmVariance: totalKmVariance ?? this.totalKmVariance,
        totalExpenseVariance: totalExpenseVariance ?? this.totalExpenseVariance,
        hubCount: hubCount ?? this.hubCount,
        totalKm: totalKm ?? this.totalKm,
        routeCount: routeCount ?? this.routeCount,
        dueKm: dueKm ?? this.dueKm,
        totalExpense: totalExpense ?? this.totalExpense,
        dueExpense: dueExpense ?? this.dueExpense,
      );

  factory DashboardTilesStatsResponse.fromJson(Map<String, dynamic> json) => DashboardTilesStatsResponse(
    totalKmVariance: json["totalKmVariance"].toDouble(),
    totalExpenseVariance: json["totalExpenseVariance"].toDouble(),
    hubCount: json["hubCount"],
    totalKm: json["totalKm"],
    routeCount: json["routeCount"],
    dueKm: json["dueKm"],
    totalExpense: json["totalExpense"].toDouble(),
    dueExpense: json["dueExpense"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "totalKmVariance": totalKmVariance,
    "totalExpenseVariance": totalExpenseVariance,
    "hubCount": hubCount,
    "totalKm": totalKm,
    "routeCount": routeCount,
    "dueKm": dueKm,
    "totalExpense": totalExpense,
    "dueExpense": dueExpense,
  };
}
