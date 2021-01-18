// To parse this JSON data, do
//
//     final kilometerReportResponse = kilometerReportFromJson(jsonString);

import 'dart:convert';
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
  String drivenKm;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Color(0xff04BFAE));

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
