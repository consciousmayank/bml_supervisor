// To parse this JSON data, do
//
//     final expensePieChartResponse = expensePieChartResponseFromMap(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';

List<ExpensePieChartResponse> expensePieChartResponseFromMap(String str) =>
    List<ExpensePieChartResponse>.from(
        json.decode(str).map((x) => ExpensePieChartResponse.fromMap(x)));

String expensePieChartResponseToMap(List<ExpensePieChartResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ExpensePieChartResponse {
  ExpensePieChartResponse({
    this.eType,
    this.eAmount,
    this.vehicleId,
    this.eDate,
    this.color = const Color(0xff68cfc6),
  });

  String eType;
  double eAmount;
  String vehicleId;
  String eDate;
  final Color color;

  ExpensePieChartResponse copyWith({
    String eType,
    double eAmount,
    String vehicleId,
    String eDate,
    Color color,
  }) =>
      ExpensePieChartResponse(
        eType: eType ?? this.eType,
        eAmount: eAmount ?? this.eAmount,
        vehicleId: vehicleId ?? this.vehicleId,
        eDate: eDate ?? this.eDate,
        color: color ?? this.color,
      );

  factory ExpensePieChartResponse.fromMap(Map<String, dynamic> json) =>
      ExpensePieChartResponse(
        eType: json["eType"],
        eAmount: json["eAmount"].toDouble(),
        vehicleId: json["vehicleId"],
        eDate: json["eDate"],
      );

  Map<String, dynamic> toMap() => {
        "eType": eType,
        "eAmount": eAmount,
        "vehicleId": vehicleId,
        "eDate": eDate,
      };
}
