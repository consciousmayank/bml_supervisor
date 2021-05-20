// To parse this JSON data, do
//
//     final getClientsResponse = getClientsResponseFromMap(jsonString);

import 'dart:convert';

class GetClientsResponse {
  GetClientsResponse({
    this.id,
    this.vendorId,
    this.dateOfReg,
    this.businessName,
    this.contactPerson,
    this.mobile,
    this.mobileAlternate,
    this.email,
    this.photo,
    this.address,
    this.username,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final int vendorId;
  final String dateOfReg;
  final String businessName;
  final String contactPerson;
  final String mobile;
  final String mobileAlternate;
  final String email;
  final dynamic photo;
  final List<Address> address;
  final String username;
  final bool status;
  final String creationdate;
  final String lastupdated;

  get clientId => 'speedx';

  GetClientsResponse copyWith({
    int id,
    int vendorId,
    String dateOfReg,
    String businessName,
    String contactPerson,
    String mobile,
    String mobileAlternate,
    String email,
    dynamic photo,
    List<Address> address,
    String username,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      GetClientsResponse(
        id: id ?? this.id,
        vendorId: vendorId ?? this.vendorId,
        dateOfReg: dateOfReg ?? this.dateOfReg,
        businessName: businessName ?? this.businessName,
        contactPerson: contactPerson ?? this.contactPerson,
        mobile: mobile ?? this.mobile,
        mobileAlternate: mobileAlternate ?? this.mobileAlternate,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        address: address ?? this.address,
        username: username ?? this.username,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory GetClientsResponse.fromJson(String str) =>
      GetClientsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetClientsResponse.fromMap(Map<String, dynamic> json) =>
      GetClientsResponse(
        id: json["id"],
        vendorId: json["vendorId"],
        dateOfReg: json["dateOfReg"],
        businessName: json["businessName"],
        contactPerson: json["contactPerson"],
        mobile: json["mobile"],
        mobileAlternate: json["mobileAlternate"],
        email: json["email"],
        photo: json["photo"],
        address:
            List<Address>.from(json["address"].map((x) => Address.fromMap(x))),
        username: json["username"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "vendorId": vendorId,
        "dateOfReg": dateOfReg,
        "businessName": businessName,
        "contactPerson": contactPerson,
        "mobile": mobile,
        "mobileAlternate": mobileAlternate,
        "email": email,
        "photo": photo,
        "address": List<dynamic>.from(address.map((x) => x.toMap())),
        "username": username,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}

class Address {
  Address({
    this.id,
    this.type,
    this.addressLine1,
    this.addressLine2,
    this.locality,
    this.nearby,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final String type;
  final String addressLine1;
  final String addressLine2;
  final String locality;
  final String nearby;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final bool status;
  final String creationdate;
  final String lastupdated;

  Address copyWith({
    int id,
    String type,
    String addressLine1,
    String addressLine2,
    String locality,
    String nearby,
    String city,
    String state,
    String country,
    String pincode,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      Address(
        id: id ?? this.id,
        type: type ?? this.type,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        locality: locality ?? this.locality,
        nearby: nearby ?? this.nearby,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"],
        type: json["type"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        locality: json["locality"],
        nearby: json["nearby"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "locality": locality,
        "nearby": nearby,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
