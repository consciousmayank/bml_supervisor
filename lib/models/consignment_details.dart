// To parse this JSON data, do
//
//     final consignmentDetailsResponse = consignmentDetailsResponseFromMap(jsonString);

import 'dart:convert';

class ConsignmentDetailsResponse {
  ConsignmentDetailsResponse({
    this.hubId,
    this.hubSequence,
    this.consigmentId,
    this.flag,
    this.paymentMode,
    this.city,
    this.dropOff,
    this.locality,
    this.mobile,
    this.contactPerson,
    this.paymentG,
    this.geoLongitude,
    this.dropOffG,
    this.geoLatitude,
    this.consignmentTitle,
    this.consignmentHubTitle,
    this.payment,
    this.colletG,
    this.hubTitle,
    this.collect,
    this.remarks,
  });

  final int hubId;
  final int hubSequence;
  final int consigmentId;
  final String flag;
  final int paymentMode;
  final String city;
  final int dropOff;
  final String locality;
  final String mobile;
  final String contactPerson;
  final double paymentG;
  final double geoLongitude;
  final int dropOffG;
  final double geoLatitude;
  final String consignmentTitle;
  final String consignmentHubTitle;
  final double payment;
  final int colletG;
  final String hubTitle;
  final int collect;
  final String remarks;

  ConsignmentDetailsResponse copyWith({
    int hubId,
    int hubSequence,
    int consigmentId,
    String flag,
    int paymentMode,
    String city,
    int dropOff,
    String locality,
    String mobile,
    String contactPerson,
    int paymentG,
    double geoLongitude,
    int dropOffG,
    double geoLatitude,
    String consignmentTitle,
    String consignmentHubTitle,
    int payment,
    int colletG,
    String hubTitle,
    int collect,
    String remarks,
  }) =>
      ConsignmentDetailsResponse(
        hubId: hubId ?? this.hubId,
        hubSequence: hubSequence ?? this.hubSequence,
        consigmentId: consigmentId ?? this.consigmentId,
        flag: flag ?? this.flag,
        paymentMode: paymentMode ?? this.paymentMode,
        city: city ?? this.city,
        dropOff: dropOff ?? this.dropOff,
        locality: locality ?? this.locality,
        mobile: mobile ?? this.mobile,
        contactPerson: contactPerson ?? this.contactPerson,
        paymentG: paymentG ?? this.paymentG,
        geoLongitude: geoLongitude ?? this.geoLongitude,
        dropOffG: dropOffG ?? this.dropOffG,
        geoLatitude: geoLatitude ?? this.geoLatitude,
        consignmentTitle: consignmentTitle ?? this.consignmentTitle,
        consignmentHubTitle: consignmentHubTitle ?? this.consignmentHubTitle,
        payment: payment ?? this.payment,
        colletG: colletG ?? this.colletG,
        hubTitle: hubTitle ?? this.hubTitle,
        collect: collect ?? this.collect,
        remarks: remarks ?? this.remarks,
      );

  factory ConsignmentDetailsResponse.fromJson(String str) =>
      ConsignmentDetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsignmentDetailsResponse.fromMap(Map<String, dynamic> json) =>
      ConsignmentDetailsResponse(
        hubId: json["hubId"],
        hubSequence: json["hubSequence"],
        consigmentId: json["consigmentId"],
        flag: json["flag"],
        paymentMode: json["paymentMode"],
        city: json["city"],
        dropOff: json["dropOff"],
        locality: json["locality"],
        mobile: json["mobile"],
        contactPerson: json["contactPerson"],
        paymentG: json["paymentG"],
        geoLongitude: json["geoLongitude"].toDouble(),
        dropOffG: json["dropOffG"],
        geoLatitude: json["geoLatitude"].toDouble(),
        consignmentTitle: json["consignmentTitle"],
        consignmentHubTitle: json["consignmentHubTitle"],
        payment: json["payment"],
        colletG: json["colletG"],
        hubTitle: json["hubTitle"],
        collect: json["collect"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toMap() => {
        "hubId": hubId,
        "hubSequence": hubSequence,
        "consigmentId": consigmentId,
        "flag": flag,
        "paymentMode": paymentMode,
        "city": city,
        "dropOff": dropOff,
        "locality": locality,
        "mobile": mobile,
        "contactPerson": contactPerson,
        "paymentG": paymentG,
        "geoLongitude": geoLongitude,
        "dropOffG": dropOffG,
        "geoLatitude": geoLatitude,
        "consignmentTitle": consignmentTitle,
        "consignmentHubTitle": consignmentHubTitle,
        "payment": payment,
        "colletG": colletG,
        "hubTitle": hubTitle,
        "collect": collect,
        "remarks": remarks,
      };
}
