// To parse this JSON data, do
//
//     final vehicleInfo = vehicleInfoFromMap(jsonString);

import 'dart:convert';

class VehicleInfo {
  VehicleInfo({
    this.id,
    this.registrationNumber,
    this.registrationDate,
    this.registrationUpto,
    this.chassisNumber,
    this.engineNumber,
    this.ownerName,
    this.ownerLevel,
    this.lastOwner,
    this.vehicleClass,
    this.fuelType,
    this.make,
    this.model,
    this.emission,
    this.rto,
    this.color,
    this.initReading,
    this.loadCapacity,
    this.seatingCapacity,
    this.length,
    this.width,
    this.height,
    this.fastTagId,
    this.fastTagUpiId,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
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
  final int length;
  final int width;
  final int height;
  final String fastTagId;
  final String fastTagUpiId;
  final bool status;
  final String creationdate;
  final String lastupdated;

  VehicleInfo copyWith({
    int id,
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
    int seatingCapacity,
    int length,
    int width,
    int height,
    String fastTagId,
    String fastTagUpiId,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      VehicleInfo(
        id: id ?? this.id,
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
        length: length ?? this.length,
        width: width ?? this.width,
        height: height ?? this.height,
        fastTagId: fastTagId ?? this.fastTagId,
        fastTagUpiId: fastTagUpiId ?? this.fastTagUpiId,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory VehicleInfo.fromJson(String str) =>
      VehicleInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VehicleInfo.fromMap(Map<String, dynamic> json) => VehicleInfo(
        id: json["id"],
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
        length: json["length"],
        width: json["width"],
        height: json["height"],
        fastTagId: json["fastTagId"],
        fastTagUpiId: json["fastTagUpiId"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
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
        "loadCapacity": loadCapacity,
        "seatingCapacity": seatingCapacity,
        "length": length,
        "width": width,
        "height": height,
        "fastTagId": fastTagId,
        "fastTagUpiId": fastTagUpiId,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
