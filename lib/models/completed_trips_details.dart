// To parse this JSON data, do
//
//     final completedTripsDetailsResponse = completedTripsDetailsResponseFromMap(jsonString);

import 'dart:convert';

class CompletedTripsDetailsResponse {
  CompletedTripsDetailsResponse({
    this.id,
    this.driverId,
    this.consignmentId,
    this.startReading,
    this.endReading,
    this.startReadingImage,
    this.endReadingImage,
    this.startTime,
    this.endTime,
    this.entryDate,
    this.srcGeoLatitude,
    this.srcGeoLongitude,
    this.dstGeoLatitude,
    this.dstGeoLongitude,
    this.remarks,
    this.status,
    this.statusCode,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final int driverId;
  final int consignmentId;
  final int startReading;
  final int endReading;
  final String startReadingImage;
  final String endReadingImage;
  final String startTime;
  final String endTime;
  final String entryDate;
  final double srcGeoLatitude;
  final double srcGeoLongitude;
  final double dstGeoLatitude;
  final double dstGeoLongitude;
  final dynamic remarks;
  final bool status;
  final int statusCode;
  final String creationdate;
  final String lastupdated;

  CompletedTripsDetailsResponse copyWith({
    int id,
    int driverId,
    int consignmentId,
    int startReading,
    int endReading,
    String startReadingImage,
    String endReadingImage,
    String startTime,
    String endTime,
    String entryDate,
    double srcGeoLatitude,
    double srcGeoLongitude,
    double dstGeoLatitude,
    double dstGeoLongitude,
    dynamic remarks,
    bool status,
    int statusCode,
    String creationdate,
    String lastupdated,
  }) =>
      CompletedTripsDetailsResponse(
        id: id ?? this.id,
        driverId: driverId ?? this.driverId,
        consignmentId: consignmentId ?? this.consignmentId,
        startReading: startReading ?? this.startReading,
        endReading: endReading ?? this.endReading,
        startReadingImage: startReadingImage ?? this.startReadingImage,
        endReadingImage: endReadingImage ?? this.endReadingImage,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        entryDate: entryDate ?? this.entryDate,
        srcGeoLatitude: srcGeoLatitude ?? this.srcGeoLatitude,
        srcGeoLongitude: srcGeoLongitude ?? this.srcGeoLongitude,
        dstGeoLatitude: dstGeoLatitude ?? this.dstGeoLatitude,
        dstGeoLongitude: dstGeoLongitude ?? this.dstGeoLongitude,
        remarks: remarks ?? this.remarks,
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory CompletedTripsDetailsResponse.fromJson(String str) =>
      CompletedTripsDetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompletedTripsDetailsResponse.fromMap(Map<String, dynamic> json) =>
      CompletedTripsDetailsResponse(
        id: json["id"],
        driverId: json["driverId"],
        consignmentId: json["consignmentId"],
        startReading: json["startReading"],
        endReading: json["endReading"],
        startReadingImage: json["startReadingImage"],
        endReadingImage: json["endReadingImage"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        entryDate: json["entryDate"],
        srcGeoLatitude: json["srcGeoLatitude"],
        srcGeoLongitude: json["srcGeoLongitude"],
        dstGeoLatitude: json["dstGeoLatitude"],
        dstGeoLongitude: json["dstGeoLongitude"],
        remarks: json["remarks"],
        status: json["status"],
        statusCode: json["statusCode"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "driverId": driverId,
        "consignmentId": consignmentId,
        "startReading": startReading,
        "endReading": endReading,
        "startReadingImage": startReadingImage,
        "endReadingImage": endReadingImage,
        "startTime": startTime,
        "endTime": endTime,
        "entryDate": entryDate,
        "srcGeoLatitude": srcGeoLatitude,
        "srcGeoLongitude": srcGeoLongitude,
        "dstGeoLatitude": dstGeoLatitude,
        "dstGeoLongitude": dstGeoLongitude,
        "remarks": remarks,
        "status": status,
        "statusCode": statusCode,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
