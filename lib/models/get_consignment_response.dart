// To parse this JSON data, do
//
//     final getConsignmentResponse = getConsignmentResponseFromMap(jsonString);

import 'dart:convert';

class GetConsignmentResponse {
  GetConsignmentResponse({
    this.id,
    this.routeId,
    this.hubId,
    this.entryDate,
    this.title,
    this.dropOff,
    this.collect,
    this.payment,
    this.tag,
    this.creationdate,
    this.lastupdated,
    this.status,
    this.message,
  });

  final int id;
  final int routeId;
  final int hubId;
  final String entryDate;
  final String title;
  final int dropOff;
  final int collect;
  final double payment;
  final int tag;
  final String creationdate;
  final String lastupdated;
  final String status;
  final String message;

  GetConsignmentResponse copyWith({
    int id,
    int routeId,
    int hubId,
    String entryDate,
    String title,
    int dropOff,
    int collect,
    int payment,
    int tag,
    String creationdate,
    String lastupdated,
    String status,
    String message,
  }) =>
      GetConsignmentResponse(
        id: id ?? this.id,
        routeId: routeId ?? this.routeId,
        hubId: hubId ?? this.hubId,
        entryDate: entryDate ?? this.entryDate,
        title: title ?? this.title,
        dropOff: dropOff ?? this.dropOff,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        tag: tag ?? this.tag,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory GetConsignmentResponse.fromJson(String str) =>
      GetConsignmentResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetConsignmentResponse.fromMap(Map<String, dynamic> json) =>
      GetConsignmentResponse(
        id: json["id"],
        routeId: json["routeId"],
        hubId: json["hubId"],
        entryDate: json["entryDate"],
        title: json["title"],
        dropOff: json["dropOff"],
        collect: json["collect"],
        payment: json["payment"],
        tag: json["tag"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "routeId": routeId,
        "hubId": hubId,
        "entryDate": entryDate,
        "title": title,
        "dropOff": dropOff,
        "collect": collect,
        "payment": payment,
        "tag": tag,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
        "status": status,
        "message": message,
      };
}
