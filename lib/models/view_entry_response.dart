// Added by Vikas Rana
// Module is subject to change

import 'package:meta/meta.dart';
import 'dart:convert';

class ViewEntryResponse {
  ViewEntryResponse({
    this.failed,
    this.id,
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
    @required this.status,
    @required this.startReadingGround,
    @required this.drivenKmGround,
  });

  final int id;
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
  final bool status;
  final String failed;

  ViewEntryResponse copyWith({
    int id,
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
    dynamic status,
    int startReadingHidden,
    int drivenKmHidden,
    String failed,
  }) =>
      ViewEntryResponse(
        id: id ?? this.id,
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
        status: status ?? this.status,
        failed: failed ?? this.failed,
        startReadingGround: startReadingHidden ?? this.startReadingGround,
        drivenKmGround: drivenKmHidden ?? this.drivenKmGround,
      );

  factory ViewEntryResponse.fromJson(String str) =>
      ViewEntryResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewEntryResponse.fromMap(Map<String, dynamic> json) =>
      ViewEntryResponse(
        id: json["id"],
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
        status: json["status"],
        startReadingGround: json["startReadingG"],
        drivenKmGround: json["drivenKmG"],
        failed: json["Failed"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
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
        "status": status,
        "Failed": failed,
        "startReadingG": startReadingGround,
        "drivenKmG": drivenKmGround
      };
}
