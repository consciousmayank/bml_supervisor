import 'dart:convert';

class CreateRouteRequest {
  CreateRouteRequest({
    this.title,
    this.srcLocation,
    this.dstLocation,
    this.hubs,
    this.clientId,
    this.remarks,
  });

  final String title;
  final int srcLocation;
  final int dstLocation;
  final List<Hub> hubs;
  final String clientId;
  final String remarks;

  CreateRouteRequest copyWith({
    String title,
    int srcLocation,
    int dstLocation,
    List<Hub> hubs,
    String clientId,
    String remarks,
  }) =>
      CreateRouteRequest(
        title: title ?? this.title,
        srcLocation: srcLocation ?? this.srcLocation,
        dstLocation: dstLocation ?? this.dstLocation,
        hubs: hubs ?? this.hubs,
        clientId: clientId ?? this.clientId,
        remarks: remarks ?? this.remarks,
      );

  factory CreateRouteRequest.fromJson(String str) =>
      CreateRouteRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateRouteRequest.fromMap(Map<String, dynamic> json) =>
      CreateRouteRequest(
        title: json["title"],
        srcLocation: json["srcLocation"],
        dstLocation: json["dstLocation"],
        hubs: List<Hub>.from(json["hubs"].map((x) => Hub.fromMap(x))),
        clientId: json["clientId"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toMap() => {
    "title": title,
    "srcLocation": srcLocation,
    "dstLocation": dstLocation,
    "hubs": List<dynamic>.from(hubs.map((x) => x.toMap())),
    "clientId": clientId,
    "remarks": remarks,
  };
}

class Hub {
  Hub({
    this.hub,
    this.sequence,
    this.kms,
    this.flag,
  });

  final int hub;
  final int sequence;
  final double kms;
  final String flag;

  Hub copyWith({
    int hub,
    int sequence,
    double kms,
    String flag,
  }) =>
      Hub(
        hub: hub ?? this.hub,
        sequence: sequence ?? this.sequence,
        kms: kms ?? this.kms,
        flag: flag ?? this.flag,
      );

  factory Hub.fromJson(String str) => Hub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hub.fromMap(Map<String, dynamic> json) => Hub(
    hub: json["hub"],
    sequence: json["sequence"],
    kms: json["kms"].toDouble(),
    flag: json["flag"],
  );

  Map<String, dynamic> toMap() => {
    "hub": hub,
    "sequence": sequence,
    "kms": kms,
    "flag": flag,
  };
}