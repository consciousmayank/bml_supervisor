// To parse this JSON data, do
//
//     final paymentListAggregate = paymentListAggregateFromMap(jsonString);

import 'dart:convert';

class PaymentListAggregate {
  PaymentListAggregate({
    this.totalKm,
    this.dueKm,
    this.paymentTotal,
    this.paymentCount,
  });

  PaymentListAggregate.zero({
    this.totalKm = 0,
    this.dueKm = 0,
    this.paymentTotal = 0,
    this.paymentCount = 0,
  });

  final dynamic totalKm;
  final dynamic dueKm;
  final dynamic paymentTotal;
  final dynamic paymentCount;

  PaymentListAggregate copyWith({
    dynamic totalKm,
    dynamic dueKm,
    dynamic paymentTotal,
    dynamic paymentCount,
  }) =>
      PaymentListAggregate(
        totalKm: totalKm ?? this.totalKm,
        dueKm: dueKm ?? this.dueKm,
        paymentTotal: paymentTotal ?? this.paymentTotal,
        paymentCount: paymentCount ?? this.paymentCount,
      );

  factory PaymentListAggregate.fromJson(String str) =>
      PaymentListAggregate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentListAggregate.fromMap(Map<String, dynamic> json) =>
      PaymentListAggregate(
        totalKm: json["totalKm"],
        dueKm: json["dueKm"],
        paymentTotal: json["paymentTotal"],
        paymentCount: json["paymentCount"],
      );

  Map<String, dynamic> toMap() => {
        "totalKm": totalKm,
        "dueKm": dueKm,
        "paymentTotal": paymentTotal,
        "paymentCount": paymentCount,
      };
}
