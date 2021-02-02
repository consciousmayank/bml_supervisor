// To parse this JSON data, do
//
//     final reviewConsignmentRequest = reviewConsignmentRequestFromMap(jsonString);

import 'dart:convert';

ReviewConsignmentRequest reviewConsignmentRequestFromMap(String str) => ReviewConsignmentRequest.fromMap(json.decode(str));

String reviewConsignmentRequestToMap(ReviewConsignmentRequest data) => json.encode(data.toMap());

class ReviewConsignmentRequest {
  ReviewConsignmentRequest({
    this.assessBy,
    this.reviewedItems,
  });

  String assessBy;
  List<Item> reviewedItems;

  ReviewConsignmentRequest copyWith({
    String assessBy,
    List<Item> reviewedItems,
  }) =>
      ReviewConsignmentRequest(
        assessBy: assessBy ?? this.assessBy,
        reviewedItems: reviewedItems ?? this.reviewedItems,
      );

  factory ReviewConsignmentRequest.fromMap(Map<String, dynamic> json) => ReviewConsignmentRequest(
    assessBy: json["assessBy"],
    reviewedItems: List<Item>.from(json["reviewedItems"].map((x) => Item.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "assessBy": assessBy,
    "reviewedItems": List<dynamic>.from(reviewedItems.map((x) => x.toMap())),
  };
}

class Item {
  Item({
    this.consignmentId,
    this.hubId,
    this.sequence,
    this.title,
    this.dropOff,
    this.collect,
    this.payment,
    this.paymentMode,
    this.paymentId,
    this.remarks,
    this.flag,
  });

  int consignmentId;
  int hubId;
  int sequence;
  String title;
  int dropOff;
  int collect;
  double payment;
  int paymentMode;
  String paymentId;
  String remarks;
  String flag;

  Item copyWith({
    int consignmentId,
    int hubId,
    int sequence,
    String title,
    int dropOff,
    int collect,
    double payment,
    int paymentMode,
    String paymentId,
    String remarks,
    String flag,
  }) =>
      Item(
        consignmentId: consignmentId ?? this.consignmentId,
        hubId: hubId ?? this.hubId,
        sequence: sequence ?? this.sequence,
        title: title ?? this.title,
        dropOff: dropOff ?? this.dropOff,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        paymentMode: paymentMode ?? this.paymentMode,
        paymentId: paymentId ?? this.paymentId,
        remarks: remarks ?? this.remarks,
        flag: flag ?? this.flag,
      );

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    consignmentId: json["consignmentId"],
    hubId: json["hubId"],
    sequence: json["sequence"],
    title: json["title"],
    dropOff: json["dropOff"],
    collect: json["collect"],
    payment: json["payment"],
    paymentMode: json["paymentMode"],
    paymentId: json["paymentId"],
    remarks: json["remarks"],
    flag: json["flag"],
  );

  Map<String, dynamic> toMap() => {
    "consignmentId": consignmentId,
    "hubId": hubId,
    "sequence": sequence,
    "title": title,
    "dropOff": dropOff,
    "collect": collect,
    "payment": payment,
    "paymentMode": paymentMode,
    "paymentId": paymentId,
    "remarks": remarks,
    "flag": flag,
  };
}
