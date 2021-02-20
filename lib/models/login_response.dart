// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

class LoginResponse {
  LoginResponse({
    this.userRole,
    this.firstName,
    this.lastName,
  });

  final String userRole;
  final String firstName;
  final String lastName;

  LoginResponse copyWith({
    String userRole,
    String firstName,
    String lastName,
  }) =>
      LoginResponse(
        userRole: userRole ?? this.userRole,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        userRole: json["userRole"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toMap() => {
        "userRole": userRole,
        "firstName": firstName,
        "lastName": lastName,
      };
}
