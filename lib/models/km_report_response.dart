// To parse this JSON data, do
//
//     final kilometerReportResponse = kilometerReportFromJson(jsonString);

import 'dart:convert';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

KilometerReportResponse kilometerReportResponseFromJson(String str) =>
    KilometerReportResponse.fromJson(json.decode(str));

String kilometerReportResponseToJson(KilometerReportResponse data) =>
    json.encode(data.toJson());

class KilometerReportResponse {
  KilometerReportResponse({
    this.entryDate,
    this.drivenKm,
    // this.barColor = charts.Color.black,
    // this.barColor = charts.ColorUtil.fromDartColor(Colors.white)
  });

  String entryDate;
  int drivenKm;
  charts.Color barColor = charts.ColorUtil.fromDartColor(AppColors.primaryColorShade5);

  factory KilometerReportResponse.fromJson(Map<String, dynamic> json) =>
      KilometerReportResponse(
        entryDate: json["entryDate"],
        drivenKm: json["drivenKm"],
      );

  Map<String, dynamic> toJson() => {
        "entryDate": entryDate,
        "drivenKm": drivenKm,
      };
}
