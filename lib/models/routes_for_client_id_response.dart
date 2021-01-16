// To parse this JSON data, do
//
//     final getRoutesResponse = getRoutesResponseFromMap(jsonString);

import 'dart:convert';

class GetRoutesResponse {
  GetRoutesResponse({
    this.srcLocation,
    this.id,
    this.title,
    this.dstLocation,
  });

  final String srcLocation;
  final int id;
  final String title;
  final String dstLocation;

  GetRoutesResponse copyWith({
    String srcLocation,
    int id,
    String title,
    String dstLocation,
  }) =>
      GetRoutesResponse(
        srcLocation: srcLocation ?? this.srcLocation,
        id: id ?? this.id,
        title: title ?? this.title,
        dstLocation: dstLocation ?? this.dstLocation,
      );

  factory GetRoutesResponse.fromJson(String str) =>
      GetRoutesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetRoutesResponse.fromMap(Map<String, dynamic> json) =>
      GetRoutesResponse(
        srcLocation: json["srcLocation"],
        id: json["id"],
        title: json["title"],
        dstLocation: json["dstLocation"],
      );

  Map<String, dynamic> toMap() => {
        "srcLocation": srcLocation,
        "id": id,
        "title": title,
        "dstLocation": dstLocation,
      };
}
