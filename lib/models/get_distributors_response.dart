// To parse this JSON data, do
//
//     final getDistributorsResponse = getDistributorsResponseFromMap(jsonString);

import 'dart:convert';

List<GetDistributorsResponse> getDistributorsResponseFromMap(String str) =>
    List<GetDistributorsResponse>.from(
        json.decode(str).map((x) => GetDistributorsResponse.fromMap(x)));

String getDistributorsResponseToMap(List<GetDistributorsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GetDistributorsResponse {
  GetDistributorsResponse(
      {this.id,
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
      this.isCheck = false,
      this.kiloMeters = 0});

  int id;
  String clientId;
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
  bool isCheck;
  int kiloMeters;

  GetDistributorsResponse copyWith(
          {int id,
          String clientId,
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
          int kiloMeters}) =>
      GetDistributorsResponse(
        id: id ?? this.id,
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
        kiloMeters: kiloMeters ?? this.kiloMeters,
      );

  factory GetDistributorsResponse.fromMap(Map<String, dynamic> json) =>
      GetDistributorsResponse(
        id: json["id"],
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
        geoLatitude: json["geoLatitude"],
        geoLongitude: json["geoLongitude"],
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
