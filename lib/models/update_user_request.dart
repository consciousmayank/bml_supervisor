// To parse this JSON data, do
//
//     final updateUserMobileRequest = updateUserMobileRequestFromMap(jsonString);

import 'dart:convert';

UpdateUserRequest updateUserMobileRequestFromMap(String str) => UpdateUserRequest.fromMap(json.decode(str));

String updateUserMobileRequestToMap(UpdateUserRequest data) => json.encode(data.toMap());

class UpdateUserRequest {
  UpdateUserRequest({
    this.mobile,
    this.email,
  });

  String mobile;
  String email;

  UpdateUserRequest copyWith({
    String mobile,
    String email,
  }) =>
      UpdateUserRequest(
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
      );

  factory UpdateUserRequest.fromMap(Map<String, dynamic> json) => UpdateUserRequest(
    mobile: json["mobile"],
    email: json["email"],
  );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
    "mobile": mobile,
    "email": email,
  };
}
