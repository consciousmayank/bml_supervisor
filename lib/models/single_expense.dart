import 'dart:convert';

import 'package:flutter/material.dart';

/*{
        "id": 51,
        "vehicleId": "UK07CB7591",
        "entryDate": "30-01-2021",
        "expenseType": "TOLL",
        "fuelLtr": 0.0,
        "fuelMeterReading": 0,
        "ratePerLtr": 0.0,
        "expenseAmount": 130.0,
        "expenseDesc": "NA",
        "status": true,
        "creationdate": "30-01-2021",
        "lastupdated": "22-05-2021 13:29:12 PM"
  }*/

class ExpenseListResponse {
  ExpenseListResponse({
    @required this.id,
    @required this.vehicleId,
    @required this.entryDate,
    @required this.expenseType,
    @required this.fuelLtr,
    @required this.fuelMeterReading,
    @required this.ratePerLtr,
    @required this.expenseAmount,
    @required this.expenseDesc,
  });

  factory ExpenseListResponse.fromJson(String source) =>
      ExpenseListResponse.fromMap(json.decode(source));

  factory ExpenseListResponse.fromMap(Map<String, dynamic> map) {
    return ExpenseListResponse(
      id: map['id'],
      vehicleId: map['vehicleId'],
      entryDate: map['entryDate'],
      expenseType: map['expenseType'],
      fuelLtr: map['fuelLtr'],
      fuelMeterReading: map['fuelMeterReading'],
      ratePerLtr: map['ratePerLtr'],
      expenseAmount: map['expenseAmount'],
      expenseDesc: map['expenseDesc'],
    );
  }

  final String entryDate;
  final double expenseAmount;
  final String expenseDesc;
  final String expenseType;
  final double fuelLtr;
  final int fuelMeterReading;
  final int id;
  final double ratePerLtr;
  final String vehicleId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseListResponse &&
        other.id == id &&
        other.vehicleId == vehicleId &&
        other.entryDate == entryDate &&
        other.expenseType == expenseType &&
        other.fuelLtr == fuelLtr &&
        other.fuelMeterReading == fuelMeterReading &&
        other.ratePerLtr == ratePerLtr &&
        other.expenseAmount == expenseAmount &&
        other.expenseDesc == expenseDesc;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        vehicleId.hashCode ^
        entryDate.hashCode ^
        expenseType.hashCode ^
        fuelLtr.hashCode ^
        fuelMeterReading.hashCode ^
        ratePerLtr.hashCode ^
        expenseAmount.hashCode ^
        expenseDesc.hashCode;
  }

  @override
  String toString() {
    return 'ExpenseListResponse(id: $id, vehicleId: $vehicleId, entryDate: $entryDate, expenseType: $expenseType, fuelLtr: $fuelLtr, fuelMeterReading: $fuelMeterReading, ratePerLtr: $ratePerLtr, expenseAmount: $expenseAmount, expenseDesc: $expenseDesc)';
  }

  ExpenseListResponse copyWith({
    int id,
    String vehicleId,
    String entryDate,
    String expenseType,
    double fuelLtr,
    double fuelMeterReading,
    double ratePerLtr,
    double expenseAmount,
    String expenseDesc,
  }) {
    return ExpenseListResponse(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      entryDate: entryDate ?? this.entryDate,
      expenseType: expenseType ?? this.expenseType,
      fuelLtr: fuelLtr ?? this.fuelLtr,
      fuelMeterReading: fuelMeterReading ?? this.fuelMeterReading,
      ratePerLtr: ratePerLtr ?? this.ratePerLtr,
      expenseAmount: expenseAmount ?? this.expenseAmount,
      expenseDesc: expenseDesc ?? this.expenseDesc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'entryDate': entryDate,
      'expenseType': expenseType,
      'fuelLtr': fuelLtr,
      'fuelMeterReading': fuelMeterReading,
      'ratePerLtr': ratePerLtr,
      'expenseAmount': expenseAmount,
      'expenseDesc': expenseDesc,
    };
  }

  String toJson() => json.encode(toMap());
}
