// To parse this JSON data, do
//
//     final entryLog = entryLogFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

class EntryLog {
  EntryLog({
    @required this.consignmentId,
    @required this.vehicleId,
    @required this.entryDate,
    @required this.startReading,
    @required this.endReading,
    @required this.drivenKm,
    @required this.fuelLtr,
    @required this.fuelMeterReading,
    @required this.ratePerLtr,
    @required this.amountPaid,
    @required this.trips,
    @required this.loginTime,
    @required this.logoutTime,
    @required this.remarks,
    @required this.startReadingGround,
    @required this.drivenKmGround,
    @required this.clientId,
    @required this.routeId,
  });

  final int consignmentId;
  final int routeId;
  final String vehicleId;
  final String entryDate;
  final int startReading;
  final int startReadingGround;
  final int endReading;
  final int drivenKm;
  final int drivenKmGround;
  final double fuelLtr;
  final int fuelMeterReading;
  final double ratePerLtr;
  final double amountPaid;
  final int trips;
  final String loginTime;
  final String logoutTime;
  final String remarks;
  final String clientId;

  EntryLog copyWith({
    int routeId,
    String vehicleId,
    String entryDate,
    double startReading,
    double endReading,
    double drivenKm,
    double fuelLtr,
    double fuelMeterReading,
    double ratePerLtr,
    double amountPaid,
    int trips,
    String loginTime,
    String logoutTime,
    String remarks,
    int startReadingHidden,
    int drivenKmHidden,
    String clientId,
    int consignmentId,
  }) =>
      EntryLog(
        routeId: routeId ?? this.routeId,
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        startReading: startReading ?? this.startReading,
        endReading: endReading ?? this.endReading,
        drivenKm: drivenKm ?? this.drivenKm,
        fuelLtr: fuelLtr ?? this.fuelLtr,
        fuelMeterReading: fuelMeterReading ?? this.fuelMeterReading,
        ratePerLtr: ratePerLtr ?? this.ratePerLtr,
        amountPaid: amountPaid ?? this.amountPaid,
        trips: trips ?? this.trips,
        loginTime: loginTime ?? this.loginTime,
        logoutTime: logoutTime ?? this.logoutTime,
        remarks: remarks ?? this.remarks,
        startReadingGround: startReadingHidden ?? this.startReadingGround,
        drivenKmGround: drivenKmHidden ?? this.drivenKmGround,
        clientId: clientId ?? this.clientId,
        consignmentId: consignmentId ?? this.consignmentId,
      );

  factory EntryLog.fromJson(String str) => EntryLog.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EntryLog.fromMap(Map<String, dynamic> json) => EntryLog(
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        startReading: json["startReading"],
        endReading: json["endReading"],
        drivenKm: json["drivenKm"],
        fuelLtr: json["fuelLtr"],
        fuelMeterReading: json["fuelMeterReading"],
        ratePerLtr: json["ratePerLtr"],
        amountPaid: json["amountPaid"],
        trips: json["trips"],
        loginTime: json["loginTime"],
        logoutTime: json["logoutTime"],
        remarks: json["remarks"],
        startReadingGround: json["startReadingG"],
        drivenKmGround: json["drivenKmG"],
        clientId: json["clientId"],
        consignmentId: json["consignmentId"],
      );

  Map<String, dynamic> toMap() => {
        "routeId": routeId,
        "vehicleId": vehicleId,
        "entryDate": entryDate,
        "startReading": startReading,
        "endReading": endReading,
        "drivenKm": drivenKm,
        "fuelLtr": fuelLtr,
        "fuelMeterReading": fuelMeterReading,
        "ratePerLtr": ratePerLtr,
        "amountPaid": amountPaid,
        "trips": trips,
        "loginTime": loginTime,
        "logoutTime": logoutTime,
        "remarks": remarks,
        "startReadingG": startReadingGround,
        "drivenKmG": drivenKmGround,
        "clientId": clientId,
        "consignmentId": consignmentId,
      };
}
