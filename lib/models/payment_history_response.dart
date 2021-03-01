import 'dart:convert';

PaymentHistoryResponse paymentHistoryResponseFromJson(String str) =>
    PaymentHistoryResponse.fromJson(json.decode(str));

String paymentHistoryResponseToJson(PaymentHistoryResponse data) =>
    json.encode(data.toJson());

class PaymentHistoryResponse {
  PaymentHistoryResponse({
    this.id,
    this.transactionId,
    this.clientId,
    this.entryDate,
    this.remarks,
    this.amount,
    this.kilometers,
    this.creationdate,
    this.lastupdated,
  });

  int id;
  int transactionId;
  String clientId;
  String entryDate;
  String remarks;
  double amount;
  double kilometers;
  String creationdate;
  String lastupdated;

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryResponse(
        id: json["id"],
        transactionId: json["transactionId"],
        clientId: json["clientId"],
        entryDate: json["entryDate"],
        remarks: json["remarks"],
        amount: json["amount"].toDouble(),
        kilometers: json["kilometers"].toDouble(),
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionId": transactionId,
        "clientId": clientId,
        "entryDate": entryDate,
        "remarks": remarks,
        "amount": amount,
        "kilometers": kilometers,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
