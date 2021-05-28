import 'dart:convert';

import 'package:flutter/material.dart';

class ExpensePeriodResponse {
  int year;
  int month;
  ExpensePeriodResponse({
    @required this.year,
    @required this.month,
  });

  ExpensePeriodResponse copyWith({
    int year,
    int month,
  }) {
    return ExpensePeriodResponse(
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
    };
  }

  factory ExpensePeriodResponse.fromMap(Map<String, dynamic> map) {
    return ExpensePeriodResponse(
      year: map['Year'],
      month: map['Month'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpensePeriodResponse.fromJson(String source) =>
      ExpensePeriodResponse.fromMap(json.decode(source));

  @override
  String toString() => 'ExpensePeriodResponse(year: $year, month: $month)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpensePeriodResponse &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}
