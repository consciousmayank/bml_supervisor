// To parse this JSON data, do
//
//     final saveExpenseRequest = saveExpenseRequestFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

class SaveExpenseRequest {
  final String vehicleId;
  final String entryDate;
  final String expenseType;
  final double fuelLtr;
  final int fuelMeterReading;
  final double ratePerLtr;
  final double expenseAmount;
  final String expenseDesc;
  final int clientId;
  SaveExpenseRequest({
    @required this.vehicleId,
    @required this.entryDate,
    @required this.expenseType,
    @required this.fuelLtr,
    @required this.fuelMeterReading,
    @required this.ratePerLtr,
    @required this.expenseAmount,
    @required this.expenseDesc,
    @required this.clientId,
  });

  SaveExpenseRequest copyWith({
    String vehicleId,
    String entryDate,
    String expenseType,
    double fuelLtr,
    int fuelMeterReading,
    double ratePerLtr,
    double expenseAmount,
    String expenseDesc,
    int clientId,
  }) {
    return SaveExpenseRequest(
      vehicleId: vehicleId ?? this.vehicleId,
      entryDate: entryDate ?? this.entryDate,
      expenseType: expenseType ?? this.expenseType,
      fuelLtr: fuelLtr ?? this.fuelLtr,
      fuelMeterReading: fuelMeterReading ?? this.fuelMeterReading,
      ratePerLtr: ratePerLtr ?? this.ratePerLtr,
      expenseAmount: expenseAmount ?? this.expenseAmount,
      expenseDesc: expenseDesc ?? this.expenseDesc,
      clientId: clientId ?? this.clientId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'entryDate': entryDate,
      'expenseType': expenseType,
      'fuelLtr': fuelLtr,
      'fuelMeterReading': fuelMeterReading,
      'ratePerLtr': ratePerLtr,
      'expenseAmount': expenseAmount,
      'expenseDesc': expenseDesc,
      'clientId': clientId,
    };
  }

  factory SaveExpenseRequest.fromMap(Map<String, dynamic> map) {
    return SaveExpenseRequest(
      vehicleId: map['vehicleId'],
      entryDate: map['entryDate'],
      expenseType: map['expenseType'],
      fuelLtr: map['fuelLtr'],
      fuelMeterReading: map['fuelMeterReading'],
      ratePerLtr: map['ratePerLtr'],
      expenseAmount: map['expenseAmount'],
      expenseDesc: map['expenseDesc'],
      clientId: map['clientId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveExpenseRequest.fromJson(String source) =>
      SaveExpenseRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SaveExpenseRequest(vehicleId: $vehicleId, entryDate: $entryDate, expenseType: $expenseType, fuelLtr: $fuelLtr, fuelMeterReading: $fuelMeterReading, ratePerLtr: $ratePerLtr, expenseAmount: $expenseAmount, expenseDesc: $expenseDesc, clientId: $clientId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SaveExpenseRequest &&
        other.vehicleId == vehicleId &&
        other.entryDate == entryDate &&
        other.expenseType == expenseType &&
        other.fuelLtr == fuelLtr &&
        other.fuelMeterReading == fuelMeterReading &&
        other.ratePerLtr == ratePerLtr &&
        other.expenseAmount == expenseAmount &&
        other.expenseDesc == expenseDesc &&
        other.clientId == clientId;
  }

  @override
  int get hashCode {
    return vehicleId.hashCode ^
        entryDate.hashCode ^
        expenseType.hashCode ^
        fuelLtr.hashCode ^
        fuelMeterReading.hashCode ^
        ratePerLtr.hashCode ^
        expenseAmount.hashCode ^
        expenseDesc.hashCode ^
        clientId.hashCode;
  }
}
