// To parse this JSON data, do
//
//     final routesDrivenKmPercentage = routesDrivenKmPercentageFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

RoutesDrivenKmPercentage routesDrivenKmPercentageFromJson(String str) =>
    RoutesDrivenKmPercentage.fromJson(json.decode(str));

String routesDrivenKmPercentageToJson(RoutesDrivenKmPercentage data) =>
    json.encode(data.toJson());

class RoutesDrivenKmPercentage {
  RoutesDrivenKmPercentage({
    this.drivenKm,
    this.routeId,
    this.drivenKmG,
    this.entryDate,
    this.trips,
    this.color = const Color(0xff68cfc6),
    this.routeTitle,
    this.eYear,
    this.eMonth,
  });

  int drivenKm;
  int routeId;
  int drivenKmG;
  String entryDate;
  String routeTitle;
  int trips;
  int eMonth;
  int eYear;
  final Color color;

  factory RoutesDrivenKmPercentage.fromJson(Map<String, dynamic> json) =>
      RoutesDrivenKmPercentage(
        drivenKm: json["drivenKm"],
        routeId: json["routeId"],
        drivenKmG: json["drivenKmG"],
        entryDate: json["entryDate"],
        trips: json["trips"],
        routeTitle: json["routeTitle"],
        eYear: json["eYear"],
        eMonth: json["eMonth"],
      );

  RoutesDrivenKmPercentage copyWith({
    int routeId,
    int drivenKmG,
    String entryDate,
    int drivenKm,
    int trips,
    Color color,
    String routeTitle,
    int eMonth,
    int eYear,
  }) =>
      RoutesDrivenKmPercentage(
        routeId: routeId ?? this.routeId,
        drivenKm: drivenKm ?? this.drivenKm,
        entryDate: entryDate ?? this.entryDate,
        drivenKmG: drivenKmG ?? this.drivenKmG,
        trips: trips ?? this.trips,
        color: color ?? this.color,
        routeTitle: routeTitle ?? this.routeTitle,
        eMonth: eMonth ?? this.eMonth,
        eYear: eYear ?? this.eYear,
      );

  Map<String, dynamic> toJson() => {
        "drivenKm": drivenKm,
        "routeId": routeId,
        "drivenKmG": drivenKmG,
        "entryDate": entryDate,
        "trips": trips,
        "routeTitle": routeTitle,
        "eMonth": eMonth,
        "eYear": eYear,
      };
}
