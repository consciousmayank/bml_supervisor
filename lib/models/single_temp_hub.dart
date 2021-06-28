// To parse this JSON data, do
//
//     final singleTempHub = singleTempHubFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

class SingleTempHub {
  SingleTempHub.empty({
    this.clientId = 0,
    this.consignmentId = 0,
    this.itemUnit,
    this.dropOff,
    this.collect,
    this.title = '',
    this.contactPerson,
    this.mobile,
    this.addressType,
    this.addressLine1,
    this.addressLine2,
    this.locality,
    this.nearby,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.geoLatitude = 0,
    this.geoLongitude = 0,
    this.remarks = 'NA',
  });

  SingleTempHub({
    @required this.clientId,
    @required this.consignmentId,
    @required this.itemUnit,
    @required this.dropOff,
    @required this.collect,
    @required this.title,
    @required this.contactPerson,
    @required this.mobile,
    @required this.addressType,
    @required this.addressLine1,
    @required this.addressLine2,
    @required this.locality,
    @required this.nearby,
    @required this.city,
    @required this.state,
    @required this.country,
    @required this.pincode,
    @required this.geoLatitude,
    @required this.geoLongitude,
    @required this.remarks,
  });

  final int clientId;
  final int consignmentId;
  final String itemUnit;
  final double dropOff;
  final double collect;
  final String title;
  final String contactPerson;
  final String mobile;
  final String addressType;
  final String addressLine1;
  final String addressLine2;
  final String locality;
  final String nearby;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final double geoLatitude;
  final double geoLongitude;
  final String remarks;

  SingleTempHub copyWith({
    int clientId,
    int consignmentId,
    String itemUnit,
    double dropOff,
    double collect,
    String title,
    String contactPerson,
    String mobile,
    String addressType,
    String addressLine1,
    String addressLine2,
    String locality,
    String nearby,
    String city,
    String state,
    String country,
    String pincode,
    double geoLatitude,
    double geoLongitude,
    String remarks,
  }) =>
      SingleTempHub(
        clientId: clientId ?? this.clientId,
        consignmentId: consignmentId ?? this.consignmentId,
        itemUnit: itemUnit ?? this.itemUnit,
        dropOff: dropOff ?? this.dropOff,
        collect: collect ?? this.collect,
        title: title ?? this.title,
        contactPerson: contactPerson ?? this.contactPerson,
        mobile: mobile ?? this.mobile,
        addressType: addressType ?? this.addressType,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        locality: locality ?? this.locality,
        nearby: nearby ?? this.nearby,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        geoLatitude: geoLatitude ?? this.geoLatitude,
        geoLongitude: geoLongitude ?? this.geoLongitude,
        remarks: remarks ?? this.remarks,
      );

  factory SingleTempHub.fromJson(String str) =>
      SingleTempHub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SingleTempHub.fromMap(Map<String, dynamic> json) => SingleTempHub(
        clientId: json["clientId"],
        consignmentId: json["consignmentId"],
        itemUnit: json["itemUnit"],
        dropOff: json["dropOff"],
        collect: json["collect"],
        title: json["title"],
        contactPerson: json["contactPerson"],
        mobile: json["mobile"],
        addressType: json["addressType"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        locality: json["locality"],
        nearby: json["nearby"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        geoLatitude: json["geoLatitude"],
        geoLongitude: json["geoLongitude"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toMap() => {
        "clientId": clientId,
        "consignmentId": consignmentId,
        "itemUnit": itemUnit,
        "dropOff": dropOff,
        "collect": collect,
        "title": title,
        "contactPerson": contactPerson,
        "mobile": mobile,
        "addressType": addressType,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "locality": locality,
        "nearby": nearby,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "geoLatitude": geoLatitude,
        "geoLongitude": geoLongitude,
        "remarks": remarks,
      };
}
