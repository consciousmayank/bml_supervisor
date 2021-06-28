// To parse this JSON data, do
//
//     final getHubDetailsResponse = getHubDetailsResponseFromMap(jsonString);

import 'dart:convert';

GetHubDetailsResponse getHubDetailsResponseFromMap(String str) =>
    GetHubDetailsResponse.fromMap(json.decode(str));

String getHubDetailsResponseToMap(GetHubDetailsResponse data) =>
    json.encode(data.toMap());

class GetHubDetailsResponse {
  GetHubDetailsResponse({
    this.id,
    this.clientId,
    this.title,
    this.contactPerson,
    this.mobile,
    this.phone,
    this.email,
    this.addressLine,
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

  int id;
  int clientId;
  String title;
  String contactPerson;
  String mobile;
  String phone;
  String email;
  String addressLine;
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

  GetHubDetailsResponse copyWith({
    int id,
    int clientId,
    String title,
    String contactPerson,
    String mobile,
    String phone,
    String email,
    String addressLine,
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
      GetHubDetailsResponse(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        title: title ?? this.title,
        contactPerson: contactPerson ?? this.contactPerson,
        mobile: mobile ?? this.mobile,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        addressLine: addressLine ?? this.addressLine,
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

  factory GetHubDetailsResponse.fromMap(Map<String, dynamic> json) =>
      GetHubDetailsResponse(
        id: json["id"],
        clientId: json["clientId"],
        title: json["title"],
        contactPerson: json["contactPerson"],
        mobile: json["mobile"],
        phone: json["phone"],
        email: json["email"],
        addressLine: json["addressLine"],
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
        "id": id,
        "clientId": clientId,
        "title": title,
        "contactPerson": contactPerson,
        "mobile": mobile,
        "phone": phone,
        "email": email,
        "addressLine": addressLine,
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
