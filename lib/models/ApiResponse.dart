// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromMap(jsonString);

import 'dart:convert';

class ApiResponse {
  ApiResponse({
    this.status,
    this.message,
  });

  final String status;
  final String message;

  ApiResponse copyWith({
    String status,
    String message,
  }) =>
      ApiResponse(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory ApiResponse.fromJson(String str) =>
      ApiResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromMap(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
      };
}
