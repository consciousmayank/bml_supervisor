// To parse this JSON data, do
//
//     final consignmentTrackingStatisticsResponse = consignmentTrackingStatisticsResponseFromMap(jsonString);

import 'dart:convert';

class ConsignmentTrackingStatisticsResponse {
  ConsignmentTrackingStatisticsResponse({
    this.created,
    this.ongoing,
    this.completed,
    this.approved,
    this.discarded,
  });

  final int created;
  final int ongoing;
  final int completed;
  final int approved;
  final int discarded;

  ConsignmentTrackingStatisticsResponse copyWith({
    int created,
    int ongoing,
    int completed,
    int approved,
    int discarded,
  }) =>
      ConsignmentTrackingStatisticsResponse(
        created: created ?? this.created,
        ongoing: ongoing ?? this.ongoing,
        completed: completed ?? this.completed,
        approved: approved ?? this.approved,
        discarded: discarded ?? this.discarded,
      );

  factory ConsignmentTrackingStatisticsResponse.fromJson(String str) =>
      ConsignmentTrackingStatisticsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsignmentTrackingStatisticsResponse.fromMap(
          Map<String, dynamic> json) =>
      ConsignmentTrackingStatisticsResponse(
        created: json["created"],
        ongoing: json["ongoing"],
        completed: json["completed"],
        approved: json["approved"],
        discarded: json["discarded"],
      );

  Map<String, dynamic> toMap() => {
        "created": created,
        "ongoing": ongoing,
        "completed": completed,
        "approved": approved,
        "discarded": discarded,
      };
}
