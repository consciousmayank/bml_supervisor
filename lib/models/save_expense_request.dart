// To parse this JSON data, do
//
//     final saveExpenseRequest = saveExpenseRequestFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class SaveExpenseRequest {
  SaveExpenseRequest({
    @required this.vehicleId,
    @required this.entryDate,
    @required this.expenseType,
    @required this.expenseAmount,
    @required this.expenseDesc,
    @required this.status,
  });

  final String vehicleId;
  final String entryDate;
  final String expenseType;
  final double expenseAmount;
  final String expenseDesc;
  final bool status;

  SaveExpenseRequest copyWith({
    String vehicleId,
    String entryDate,
    String expenseType,
    int expenseAmount,
    String expenseDesc,
    bool status,
  }) =>
      SaveExpenseRequest(
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        expenseType: expenseType ?? this.expenseType,
        expenseAmount: expenseAmount ?? this.expenseAmount,
        expenseDesc: expenseDesc ?? this.expenseDesc,
        status: status ?? this.status,
      );

  factory SaveExpenseRequest.fromJson(String str) =>
      SaveExpenseRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaveExpenseRequest.fromMap(Map<String, dynamic> json) =>
      SaveExpenseRequest(
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        expenseType: json["expenseType"],
        expenseAmount: json["expenseAmount"],
        expenseDesc: json["expenseDesc"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "vehicleId": vehicleId,
        "entryDate": entryDate,
        "expenseType": expenseType,
        "expenseAmount": expenseAmount,
        "expenseDesc": expenseDesc,
        "status": status,
      };
}
