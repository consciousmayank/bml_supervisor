// To parse this JSON data, do
//
//     final fetchRoutesResponse = fetchRoutesResponseFromMap(jsonString);

import 'dart:convert';

class FetchRoutesResponse {
  FetchRoutesResponse({
    this.srcLocation,
    this.id,
    this.title,
    this.dstLocation,
    this.kilometers
  });

  final String srcLocation;
  final int id;
  final String title;
  final String dstLocation;
  final double kilometers;

  FetchRoutesResponse copyWith({
    String srcLocation,
    int id,
    String title,
    String dstLocation,
    double kilometers,
  }) =>
      FetchRoutesResponse(
        srcLocation: srcLocation ?? this.srcLocation,
        id: id ?? this.id,
        title: title ?? this.title,
        dstLocation: dstLocation ?? this.dstLocation,
        kilometers: kilometers??this.kilometers,
      );

  factory FetchRoutesResponse.fromJson(String str) =>
      FetchRoutesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FetchRoutesResponse.fromMap(Map<String, dynamic> json) =>
      FetchRoutesResponse(
        srcLocation: json["srcLocation"],
        id: json["id"],
        title: json["title"],
        dstLocation: json["dstLocation"],
        kilometers: json["kilometers"],
      );

  Map<String, dynamic> toMap() => {
        "srcLocation": srcLocation,
        "id": id,
        "title": title,
        "dstLocation": dstLocation,
        "kilometers": kilometers,
      };
}
