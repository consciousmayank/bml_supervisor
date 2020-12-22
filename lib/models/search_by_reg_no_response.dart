// To parse this JSON data, do
//
//     final searchByRegNoResponse = searchByRegNoResponseFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class SearchByRegNoResponse {
  SearchByRegNoResponse({
    @required this.vehicleId,
    @required this.registrationNumber,
    @required this.registrationDate,
    @required this.registrationUpto,
    @required this.chassisNumber,
    @required this.engineNumber,
    @required this.ownerName,
    @required this.ownerLevel,
    @required this.lastOwner,
    @required this.vehicleClass,
    @required this.fuelType,
    @required this.make,
    @required this.model,
    @required this.emission,
    @required this.rto,
    @required this.color,
    @required this.initReading,
    @required this.loadCapacity,
    @required this.seatingCapacity,
    @required this.status,
  });

  final int vehicleId;
  final String registrationNumber;
  final String registrationDate;
  final String registrationUpto;
  final String chassisNumber;
  final String engineNumber;
  final String ownerName;
  final int ownerLevel;
  final String lastOwner;
  final String vehicleClass;
  final String fuelType;
  final String make;
  final String model;
  final String emission;
  final String rto;
  final String color;
  final int initReading;
  final String loadCapacity;
  final int seatingCapacity;
  final bool status;

  SearchByRegNoResponse copyWith({
    int vehicleId,
    String registrationNumber,
    String registrationDate,
    String registrationUpto,
    String chassisNumber,
    String engineNumber,
    String ownerName,
    int ownerLevel,
    String lastOwner,
    String vehicleClass,
    String fuelType,
    String make,
    String model,
    String emission,
    String rto,
    String color,
    int initReading,
    String loadCapacity,
    String seatingCapacity,
    bool status,
  }) =>
      SearchByRegNoResponse(
        vehicleId: vehicleId ?? this.vehicleId,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        registrationDate: registrationDate ?? this.registrationDate,
        registrationUpto: registrationUpto ?? this.registrationUpto,
        chassisNumber: chassisNumber ?? this.chassisNumber,
        engineNumber: engineNumber ?? this.engineNumber,
        ownerName: ownerName ?? this.ownerName,
        ownerLevel: ownerLevel ?? this.ownerLevel,
        lastOwner: lastOwner ?? this.lastOwner,
        vehicleClass: vehicleClass ?? this.vehicleClass,
        fuelType: fuelType ?? this.fuelType,
        make: make ?? this.make,
        model: model ?? this.model,
        emission: emission ?? this.emission,
        rto: rto ?? this.rto,
        color: color ?? this.color,
        initReading: initReading ?? this.initReading,
        loadCapacity: loadCapacity ?? this.loadCapacity,
        seatingCapacity: seatingCapacity ?? this.seatingCapacity,
        status: status ?? this.status,
      );

  factory SearchByRegNoResponse.fromJson(String str) =>
      SearchByRegNoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchByRegNoResponse.fromMap(Map<String, dynamic> json) =>
      SearchByRegNoResponse(
        vehicleId: json["vehicleId"],
        registrationNumber: json["registrationNumber"],
        registrationDate: json["registrationDate"],
        registrationUpto: json["registrationUpto"],
        chassisNumber: json["chassisNumber"],
        engineNumber: json["engineNumber"],
        ownerName: json["ownerName"],
        ownerLevel: json["ownerLevel"],
        lastOwner: json["lastOwner"],
        vehicleClass: json["vehicleClass"],
        fuelType: json["fuelType"],
        make: json["make"],
        model: json["model"],
        emission: json["emission"],
        rto: json["rto"],
        color: json["color"],
        initReading: json["initReading"],
        loadCapacity: json["loadCapacity"],
        seatingCapacity: json["seatingCapacity"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "vehicleId": vehicleId,
        "registrationNumber": registrationNumber,
        "registrationDate": registrationDate,
        "registrationUpto": registrationUpto,
        "chassisNumber": chassisNumber,
        "engineNumber": engineNumber,
        "ownerName": ownerName,
        "ownerLevel": ownerLevel,
        "lastOwner": lastOwner,
        "vehicleClass": vehicleClass,
        "fuelType": fuelType,
        "make": make,
        "model": model,
        "emission": emission,
        "rto": rto,
        "color": color,
        "initReading": initReading,
        "load_capacity": loadCapacity,
        "seatingCapacity": seatingCapacity,
        "status": status,
      };
}
