// To parse this JSON data, do
//
//     final citiesResponse = citiesResponseFromMap(jsonString);

import 'dart:convert';

class CitiesResponse {
  CitiesResponse({
    this.id,
    this.city,
  });

  final String id;
  final String city;

  CitiesResponse copyWith({
    String id,
    String city,
  }) =>
      CitiesResponse(
        id: id ?? this.id,
        city: city ?? this.city,
      );

  factory CitiesResponse.fromJson(String str) => CitiesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CitiesResponse.fromMap(Map<String, dynamic> json) => CitiesResponse(
    id: json["id"],
    city: json["city"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "city": city,
  };
}
