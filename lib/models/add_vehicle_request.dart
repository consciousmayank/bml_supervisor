// To parse this JSON data, do
//
//     final addVehicleRequest = addVehicleRequestFromMap(jsonString);

import 'dart:convert';

class AddVehicleRequest {
  AddVehicleRequest({
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
    this.registrationNumberError,
    this.registrationDateError,
    this.registrationUptoError,
    this.chassisNumberError,
    this.engineNumberError,
    this.ownerNameError,
    this.ownerLevelError,
    this.lastOwnerError,
    this.vehicleClassError,
    this.fuelTypeError,
    this.makeError,
    this.modelError,
    this.emissionError,
    this.rtoError,
    this.colorError,
    this.initReadingError,
    this.loadCapacityError,
    this.seatingCapacityError,
    this.lengthError,
    this.widthError,
    this.heightError,
  });

  final String registrationNumber;
  String registrationNumberError;

  final String registrationDate;
  String registrationDateError;

  final String registrationUpto;
  String registrationUptoError;

  final String chassisNumber;
  String chassisNumberError;

  final String engineNumber;
  String engineNumberError;

  final String ownerName;
  String ownerNameError;

  final int ownerLevel;
  String ownerLevelError;

  final String lastOwner;
  String lastOwnerError;

  final String vehicleClass;
  String vehicleClassError;

  final String fuelType;
  String fuelTypeError;

  final String make;
  String makeError;

  final String model;
  String modelError;

  final String emission;
  String emissionError;

  final String rto;
  String rtoError;

  final String color;
  String colorError;

  final int initReading;
  String initReadingError;

  final String loadCapacity;
  String loadCapacityError;

  final int seatingCapacity;
  String seatingCapacityError;

  final int length;
  String lengthError;

  final int width;
  String widthError;

  final int height;
  String heightError;

  AddVehicleRequest copyWith({
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
    String heightError,
    String registrationNumberError,
    String registrationDateError,
    String registrationUptoError,
    String chassisNumberError,
    String engineNumberError,
    String ownerNameError,
    String ownerLevelError,
    String lastOwnerError,
    String vehicleClassError,
    String fuelTypeError,
    String makeError,
    String modelError,
    String emissionError,
    String rtoError,
    String colorError,
    String initReadingError,
    String loadCapacityError,
    String seatingCapacityError,
    String lengthError,
    String widthError,
  }) =>
      AddVehicleRequest(
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
        heightError: heightError ?? this.heightError,
        registrationNumberError:
            registrationNumberError ?? this.registrationNumberError,
        registrationDateError:
            registrationDateError ?? this.registrationDateError,
        registrationUptoError:
            registrationUptoError ?? this.registrationUptoError,
        chassisNumberError: chassisNumberError ?? this.chassisNumberError,
        engineNumberError: engineNumberError ?? this.engineNumberError,
        ownerNameError: ownerNameError ?? this.ownerNameError,
        ownerLevelError: ownerLevelError ?? this.ownerLevelError,
        lastOwnerError: lastOwnerError ?? this.lastOwnerError,
        vehicleClassError: vehicleClassError ?? this.vehicleClassError,
        fuelTypeError: fuelTypeError ?? this.fuelTypeError,
        makeError: makeError ?? this.makeError,
        modelError: modelError ?? this.modelError,
        emissionError: emissionError ?? this.emissionError,
        rtoError: rtoError ?? this.rtoError,
        colorError: colorError ?? this.colorError,
        initReadingError: initReadingError ?? this.initReadingError,
        loadCapacityError: loadCapacityError ?? this.loadCapacityError,
        seatingCapacityError: seatingCapacityError ?? this.seatingCapacityError,
        lengthError: lengthError ?? this.lengthError,
        widthError: widthError ?? this.widthError,
      );

  factory AddVehicleRequest.fromJson(String str) =>
      AddVehicleRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddVehicleRequest.fromMap(Map<String, dynamic> json) =>
      AddVehicleRequest(
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
      );

  Map<String, dynamic> toMap() => {
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
      };
}
