// To parse this JSON data, do
//
//     final hubResponse = hubResponseFromMap(jsonString);

import 'dart:convert';

class HubResponse {
  HubResponse({
    this.id,
    this.title,
    this.contactPerson,
    this.mobile,
    this.phone,
    this.email,
    this.street,
    this.locality,
    this.landmark,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.registrationDate,
    this.geoLatitude,
    this.geoLongitude,
    this.remarks,
    this.status,
    this.creationdate,
    this.lastupdated,
    this.clientId,
  });

  final int id;
  final String title;
  final String clientId;
  final String contactPerson;
  final String mobile;
  final String phone;
  final String email;
  final String street;
  final String locality;
  final String landmark;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String registrationDate;
  final double geoLatitude;
  final double geoLongitude;
  final String remarks;
  final bool status;
  final String creationdate;
  final String lastupdated;

  HubResponse copyWith({
    int id,
    String title,
    String contactPerson,
    String mobile,
    String phone,
    String email,
    String street,
    String locality,
    String landmark,
    String city,
    String state,
    String country,
    String pincode,
    String registrationDate,
    double geoLatitude,
    double geoLongitude,
    String remarks,
    bool status,
    String creationdate,
    String lastupdated,
    String clientId,
  }) =>
      HubResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        contactPerson: contactPerson ?? this.contactPerson,
        mobile: mobile ?? this.mobile,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        street: street ?? this.street,
        locality: locality ?? this.locality,
        landmark: landmark ?? this.landmark,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        registrationDate: registrationDate ?? this.registrationDate,
        geoLatitude: geoLatitude ?? this.geoLatitude,
        geoLongitude: geoLongitude ?? this.geoLongitude,
        remarks: remarks ?? this.remarks,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
        clientId: clientId ?? this.clientId,
      );

  factory HubResponse.fromJson(String str) =>
      HubResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubResponse.fromMap(Map<String, dynamic> json) => HubResponse(
        id: json["id"],
        title: json["title"],
        clientId: json["clientId"],
        contactPerson: json["contactPerson"],
        mobile: json["mobile"],
        phone: json["phone"],
        email: json["email"],
        street: json["street"],
        locality: json["locality"],
        landmark: json["landmark"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        registrationDate: json["registrationDate"],
        geoLatitude: (json["geoLatitude"] ?? 0.00).toDouble(),
        geoLongitude: (json["geoLongitude"] ?? 0.00).toDouble(),
        remarks: json["remarks"],
        status: json["status"] ?? false,
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "clientId": clientId,
        "contactPerson": contactPerson,
        "mobile": mobile,
        "phone": phone,
        "email": email,
        "street": street,
        "locality": locality,
        "landmark": landmark,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "registrationDate": registrationDate,
        "geoLatitude": geoLatitude,
        "geoLongitude": geoLongitude,
        "remarks": remarks,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
