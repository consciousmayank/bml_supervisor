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
  });

  final String srcLocation;
  final int id;
  final String title;
  final String dstLocation;

  FetchRoutesResponse copyWith({
    String srcLocation,
    int id,
    String title,
    String dstLocation,
  }) =>
      FetchRoutesResponse(
        srcLocation: srcLocation ?? this.srcLocation,
        id: id ?? this.id,
        title: title ?? this.title,
        dstLocation: dstLocation ?? this.dstLocation,
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
      );

  Map<String, dynamic> toMap() => {
        "srcLocation": srcLocation,
        "id": id,
        "title": title,
        "dstLocation": dstLocation,
      };
}
