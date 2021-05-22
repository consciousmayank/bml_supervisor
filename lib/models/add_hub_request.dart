// To parse this JSON data, do
//
//     final addHubRequest = addHubRequestFromMap(jsonString);

import 'dart:convert';

AddHubRequest addHubRequestFromMap(String str) =>
    AddHubRequest.fromMap(json.decode(str));

String addHubRequestToMap(AddHubRequest data) => json.encode(data.toMap());

class AddHubRequest {
  AddHubRequest({
    this.clientId,
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
  });

  int clientId;
  String title;
  String contactPerson;
  String mobile;
  String phone;
  String email;
  String street;
  String locality;
  String landmark;
  String city;
  String state;
  String country;
  String pincode;
  String registrationDate;
  double geoLatitude;
  double geoLongitude;
  String remarks;

  AddHubRequest copyWith({
    int clientId,
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
  }) =>
      AddHubRequest(
        clientId: clientId ?? this.clientId,
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
      );

  factory AddHubRequest.fromJson(String str) =>
      AddHubRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddHubRequest.fromMap(Map<String, dynamic> json) => AddHubRequest(
        clientId: json["clientId"],
        title: json["title"],
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
        geoLatitude: json["geoLatitude"].toDouble(),
        geoLongitude: json["geoLongitude"].toDouble(),
        remarks: json["remarks"],
      );

  Map<String, dynamic> toMap() => {
        "clientId": clientId,
        "title": title,
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
      };
}
