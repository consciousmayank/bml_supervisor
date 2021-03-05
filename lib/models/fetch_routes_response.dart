// To parse this JSON data, do
//
//     final fetchRoutesResponse = fetchRoutesResponseFromMap(jsonString);

import 'dart:convert';

class FetchRoutesResponse {
  FetchRoutesResponse(
      {this.srcLocation,
      this.routeId,
      this.routeTitle,
      this.dstLocation,
      this.kilometers});

  final String srcLocation;
  final int routeId;
  final String routeTitle;
  final String dstLocation;
  final double kilometers;

  FetchRoutesResponse copyWith({
    String srcLocation,
    int routeId,
    String routeTitle,
    String dstLocation,
    double kilometers,
  }) =>
      FetchRoutesResponse(
        srcLocation: srcLocation ?? this.srcLocation,
        routeId: routeId ?? this.routeId,
        routeTitle: routeTitle ?? this.routeTitle,
        dstLocation: dstLocation ?? this.dstLocation,
        kilometers: kilometers ?? this.kilometers,
      );

  factory FetchRoutesResponse.fromJson(String str) =>
      FetchRoutesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FetchRoutesResponse.fromMap(Map<String, dynamic> json) =>
      FetchRoutesResponse(
        srcLocation: json["srcLocation"],
        routeId: json["routeId"],
        routeTitle: json["routeTitle"],
        dstLocation: json["dstLocation"],
        kilometers: json["kilometers"],
      );

  Map<String, dynamic> toMap() => {
        "srcLocation": srcLocation,
        "routeId": routeId,
        "routeTitle": routeTitle,
        "dstLocation": dstLocation,
        "kilometers": kilometers,
      };
}
