import 'dart:convert';

import 'package:flutter/material.dart';

class ExpenseAggregate {
  double totalAmount;
  int recordCount;
  ExpenseAggregate({
    @required this.totalAmount,
    @required this.recordCount,
  });

  ExpenseAggregate copyWith({
    double totalAmount,
    int recordCount,
  }) {
    return ExpenseAggregate(
      totalAmount: totalAmount ?? this.totalAmount,
      recordCount: recordCount ?? this.recordCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAmount': totalAmount,
      'recordCount': recordCount,
    };
  }

  factory ExpenseAggregate.fromMap(Map<String, dynamic> map) {
    return ExpenseAggregate(
      totalAmount: map['totalAmount'],
      recordCount: map['recordCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseAggregate.fromJson(String source) => ExpenseAggregate.fromMap(json.decode(source));

  @override
  String toString() => 'ExpenseAggregate(totalAmount: $totalAmount, recordCount: $recordCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ExpenseAggregate &&
      other.totalAmount == totalAmount &&
      other.recordCount == recordCount;
  }

  @override
  int get hashCode => totalAmount.hashCode ^ recordCount.hashCode;
}
