// To parse this JSON data, do
//
//     final viewExpensesResponse = viewExpensesResponseFromMap(jsonString);

import 'dart:convert';

class ViewExpensesResponse {
  ViewExpensesResponse({
    this.eType,
    this.eAmount,
    this.vehicleId,
    this.eDate,
  });

  final String eType;
  final double eAmount;
  final String vehicleId;
  final String eDate;

  ViewExpensesResponse copyWith({
    String eType,
    double eAmount,
    String vehicleId,
    String eDate,
  }) =>
      ViewExpensesResponse(
        eType: eType ?? this.eType,
        eAmount: eAmount ?? this.eAmount,
        vehicleId: vehicleId ?? this.vehicleId,
        eDate: eDate ?? this.eDate,
      );

  factory ViewExpensesResponse.fromJson(String str) =>
      ViewExpensesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewExpensesResponse.fromMap(Map<String, dynamic> json) =>
      ViewExpensesResponse(
        eType: json["eType"],
        eAmount: json["eAmount"],
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
