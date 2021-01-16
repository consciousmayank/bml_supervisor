// To parse this JSON data, do
//
//     final fetchHubsResponse = fetchHubsResponseFromMap(jsonString);

import 'dart:convert';

class FetchHubsResponse {
  FetchHubsResponse({
    this.isSubmitted,
    this.geoLongitude,
    this.sequence,
    this.geoLatitude,
    this.flag,
    this.city,
    this.kilometer,
    this.mobile,
    this.contactPerson,
    this.id,
    this.title,
  });
  final bool isSubmitted;
  final double geoLongitude;
  final int sequence;
  final double geoLatitude;
  final String flag;
  final String city;
  final double kilometer;
  final String mobile;
  final String contactPerson;
  final int id;
  final String title;

  FetchHubsResponse copyWith({
    double geoLongitude,
    int sequence,
    double geoLatitude,
    String flag,
    String city,
    int kilometer,
    String mobile,
    String contactPerson,
    int id,
    bool isSubmitted,
    String title,
  }) =>
      FetchHubsResponse(
          geoLongitude: geoLongitude ?? this.geoLongitude,
          sequence: sequence ?? this.sequence,
          geoLatitude: geoLatitude ?? this.geoLatitude,
          flag: flag ?? this.flag,
          city: city ?? this.city,
          kilometer: kilometer ?? this.kilometer,
          mobile: mobile ?? this.mobile,
          contactPerson: contactPerson ?? this.contactPerson,
          id: id ?? this.id,
          title: title ?? this.title,
          isSubmitted: isSubmitted ?? this.isSubmitted);

  factory FetchHubsResponse.fromJson(String str) =>
      FetchHubsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FetchHubsResponse.fromMap(Map<String, dynamic> json) =>
      FetchHubsResponse(
        geoLongitude: json["geoLongitude"].toDouble(),
        sequence: json["sequence"],
        geoLatitude: json["geoLatitude"].toDouble(),
        flag: json["flag"],
        city: json["city"],
        kilometer: json["kilometer"],
        mobile: json["mobile"],
        contactPerson: json["contactPerson"],
        id: json["id"],
        title: json["title"],
        isSubmitted: false,
      );

  Map<String, dynamic> toMap() => {
        "geoLongitude": geoLongitude,
        "sequence": sequence,
        "geoLatitude": geoLatitude,
        "flag": flag,
        "city": city,
        "kilometer": kilometer,
        "mobile": mobile,
        "contactPerson": contactPerson,
        "id": id,
        "title": title,
        "isSubmitted": isSubmitted
      };
}
