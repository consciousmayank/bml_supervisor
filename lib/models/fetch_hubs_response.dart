// To parse this JSON data, do
//
//     final fetchHubsResponse = fetchHubsResponseFromMap(jsonString);

import 'dart:convert';

class FetchHubsResponse {
  FetchHubsResponse({
    this.geoLongitude,
    this.sequence,
    this.geoLatitude,
    this.city,
    this.kilometer,
    this.mobile,
    this.contactPerson,
    this.tag,
    this.title,
  });

  final double geoLongitude;
  final int sequence;
  final double geoLatitude;
  final String city;
  final double kilometer;
  final String mobile;
  final String contactPerson;
  final int tag;
  final String title;

  FetchHubsResponse copyWith({
    double geoLongitude,
    int sequence,
    double geoLatitude,
    String city,
    int kilometer,
    String mobile,
    String contactPerson,
    int tag,
    String title,
  }) =>
      FetchHubsResponse(
        geoLongitude: geoLongitude ?? this.geoLongitude,
        sequence: sequence ?? this.sequence,
        geoLatitude: geoLatitude ?? this.geoLatitude,
        city: city ?? this.city,
        kilometer: kilometer ?? this.kilometer,
        mobile: mobile ?? this.mobile,
        contactPerson: contactPerson ?? this.contactPerson,
        tag: tag ?? this.tag,
        title: title ?? this.title,
      );

  factory FetchHubsResponse.fromJson(String str) =>
      FetchHubsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FetchHubsResponse.fromMap(Map<String, dynamic> json) =>
      FetchHubsResponse(
        geoLongitude: json["geoLongitude"].toDouble(),
        sequence: json["sequence"],
        geoLatitude: json["geoLatitude"].toDouble(),
        city: json["city"],
        kilometer: json["kilometer"],
        mobile: json["mobile"],
        contactPerson: json["contactPerson"],
        tag: json["tag"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "geoLongitude": geoLongitude,
        "sequence": sequence,
        "geoLatitude": geoLatitude,
        "city": city,
        "kilometer": kilometer,
        "mobile": mobile,
        "contactPerson": contactPerson,
        "tag": tag,
        "title": title,
      };
}
