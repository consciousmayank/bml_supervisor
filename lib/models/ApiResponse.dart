// To parse this JSON data, do
//
//     final vehicleRegistrationResponse = vehicleRegistrationResponseFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

class ApiResponse {
  ApiResponse({
    @required this.success,
    @required this.recordId,
    @required this.failed,
  });

  final String success;
  final int recordId;
  final String failed;

  ApiResponse copyWith({
    String success,
    int recordId,
    String failed,
  }) =>
      ApiResponse(
        success: success ?? this.success,
        recordId: recordId ?? this.recordId,
        failed: failed ?? this.failed,
      );

  factory ApiResponse.fromJson(String str) =>
      ApiResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromMap(Map<String, dynamic> json) => ApiResponse(
        success: json["Success"],
        recordId: json["RecordId"],
        failed: json["Failed"],
      );

  Map<String, dynamic> toMap() => {
        "Success": success,
        "RecordId": recordId,
        "Failed": failed,
      };
}
