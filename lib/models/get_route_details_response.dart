// To parse this JSON data, do
//
//     final getRouteDetailsResponse = getRouteDetailsResponseFromMap(jsonString);

import 'dart:convert';

class GetRouteDetailsResponse {
  GetRouteDetailsResponse({
    this.id,
    this.clientId,
    this.title,
    this.srcLocation,
    this.dstLocation,
    this.hubs,
    this.remarks,
  });

  int id;
  int clientId;
  String title;
  int srcLocation;
  int dstLocation;
  List<Hub> hubs;
  String remarks;

  GetRouteDetailsResponse copyWith({
    int id,
    int clientId,
    String title,
    int srcLocation,
    int dstLocation,
    List<Hub> hubs,
    String remarks,
  }) =>
      GetRouteDetailsResponse(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        title: title ?? this.title,
        srcLocation: srcLocation ?? this.srcLocation,
        dstLocation: dstLocation ?? this.dstLocation,
        hubs: hubs ?? this.hubs,
        remarks: remarks ?? this.remarks,
      );

  factory GetRouteDetailsResponse.fromJson(String str) =>
      GetRouteDetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRouteDetailsResponse.fromMap(Map<String, dynamic> json) =>
      GetRouteDetailsResponse(
        id: json["id"],
        clientId: json["clientId"],
        title: json["title"],
        srcLocation: json["srcLocation"],
        dstLocation: json["dstLocation"],
        hubs: List<Hub>.from(json["hubs"].map((x) => Hub.fromMap(x))),
        remarks: json["remarks"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "clientId": clientId,
        "title": title,
        "srcLocation": srcLocation,
        "dstLocation": dstLocation,
        "hubs": List<dynamic>.from(hubs.map((x) => x.toMap())),
        "remarks": remarks,
      };
}

class Hub {
  Hub({
    this.id,
    this.routeId,
    this.hub,
    this.sequence,
    this.kms,
    this.flag,
    this.status,
  });

  int id;
  int routeId;
  int hub;
  int sequence;
  double kms;
  String flag;
  bool status;

  Hub copyWith({
    int id,
    int routeId,
    int hub,
    int sequence,
    double kms,
    String flag,
    bool status,
  }) =>
      Hub(
        id: id ?? this.id,
        routeId: routeId ?? this.routeId,
        hub: hub ?? this.hub,
        sequence: sequence ?? this.sequence,
        kms: kms ?? this.kms,
        flag: flag ?? this.flag,
        status: status ?? this.status,
      );

  factory Hub.fromMap(Map<String, dynamic> json) => Hub(
        id: json["id"],
        routeId: json["routeId"],
        hub: json["hub"],
        sequence: json["sequence"],
        kms: json["kms"],
        flag: json["flag"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "routeId": routeId,
        "hub": hub,
        "sequence": sequence,
        "kms": kms,
        "flag": flag,
        "status": status,
      };
}
