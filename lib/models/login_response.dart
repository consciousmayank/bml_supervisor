// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

class LoginResponse {
  LoginResponse({
    this.userRole,
  });

  final String userRole;

  LoginResponse copyWith({
    String userRole,
  }) =>
      LoginResponse(
        userRole: userRole ?? this.userRole,
      );

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        userRole: json["userRole"],
      );

  Map<String, dynamic> toMap() => {
        "userRole": userRole,
      };
}
