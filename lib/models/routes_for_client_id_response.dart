// To parse this JSON data, do
//
//     final getRoutesResponse = getRoutesResponseFromMap(jsonString);

import 'dart:convert';

class GetRoutesResponse {
  GetRoutesResponse({
    this.id,
    this.title,
    this.hub,
    this.client,
    this.remarks,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final String title;
  final List<Hubs> hub;
  final int client;
  final String remarks;
  final bool status;
  final String creationdate;
  final String lastupdated;

  GetRoutesResponse copyWith({
    int id,
    String title,
    List<Hubs> hub,
    int client,
    String remarks,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      GetRoutesResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        hub: hub ?? this.hub,
        client: client ?? this.client,
        remarks: remarks ?? this.remarks,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory GetRoutesResponse.fromJson(String str) =>
      GetRoutesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRoutesResponse.fromMap(Map<String, dynamic> json) =>
      GetRoutesResponse(
        id: json["id"],
        title: json["title"],
        hub: List<Hubs>.from(json["hubs"].map((x) => Hubs.fromMap(x))),
        client: json["client"],
        remarks: json["remarks"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "hub": List<dynamic>.from(hub.map((x) => x.toMap())),
        "client": client,
        "remarks": remarks,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}

class Hubs {
  Hubs({
    this.id,
    this.hub,
    this.sequence,
    this.kms,
    this.tag,
  });

  final int id;
  final int hub;
  final int sequence;
  final int kms;
  final int tag;

  Hubs copyWith({
    int id,
    int hub,
    int sequence,
    int kms,
    int tag,
  }) =>
      Hubs(
        id: id ?? this.id,
        hub: hub ?? this.hub,
        sequence: sequence ?? this.sequence,
        kms: kms ?? this.kms,
        tag: tag ?? this.tag,
      );

  factory Hubs.fromJson(String str) => Hubs.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hubs.fromMap(Map<String, dynamic> json) => Hubs(
        id: json["id"],
        hub: json["hub"],
        sequence: json["sequence"],
        kms: json["kms"],
        tag: json["tag"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "hub": hub,
        "sequence": sequence,
        "kms": kms,
        "tag": tag,
      };
}
