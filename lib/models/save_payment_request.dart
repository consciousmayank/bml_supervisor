// To parse this JSON data, do
//
//     final savePaymentRequest = savePaymentRequestFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

class SavePaymentRequest {
  String clientId;
  String entryDate;
  String remarks;
  double amount;
  double kilometers;

  SavePaymentRequest({
    @required this.clientId,
    @required this.entryDate,
    @required this.remarks,
    @required this.amount,
    @required this.kilometers,
  });

  factory SavePaymentRequest.fromJson(String str) =>
      SavePaymentRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SavePaymentRequest.fromMap(Map<String, dynamic> json) =>
      SavePaymentRequest(
        clientId: json["clientId"],
        entryDate: json["entryDate"],
        remarks: json["remarks"],
        amount: json["amount"],
        kilometers: json["kilometers"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "clientId": clientId,
        "entryDate": entryDate,
        "remarks": remarks,
        "amount": amount,
        "kilometers": kilometers,
      };
}
