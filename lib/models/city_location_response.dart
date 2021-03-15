// To parse this JSON data, do
//
//     final cityLocationResponse = cityLocationResponseFromMap(jsonString);

import 'dart:convert';

class CityLocationResponse {
  CityLocationResponse({
    this.id,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.geoLatitude,
    this.geoLongitude,
    this.status,
  });

  final int id;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final double geoLatitude;
  final double geoLongitude;
  final bool status;

  CityLocationResponse copyWith({
    int id,
    String city,
    String state,
    String country,
    String pincode,
    int geoLatitude,
    int geoLongitude,
    bool status,
  }) =>
      CityLocationResponse(
        id: id ?? this.id,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        geoLatitude: geoLatitude ?? this.geoLatitude,
        geoLongitude: geoLongitude ?? this.geoLongitude,
        status: status ?? this.status,
      );

  factory CityLocationResponse.fromJson(String str) =>
      CityLocationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CityLocationResponse.fromMap(Map<String, dynamic> json) =>
      CityLocationResponse(
        id: json["id"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        geoLatitude: json["geoLatitude"],
        geoLongitude: json["geoLongitude"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "geoLatitude": geoLatitude,
        "geoLongitude": geoLongitude,
        "status": status,
      };
}
