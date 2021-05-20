// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

class LoginResponse {
  bool isUserLoggedIn;

  LoginResponse({
    this.firstName,
    this.lastName,
    this.gender,
    this.mobile,
    this.workExperience,
    this.emailId,
    this.designation,
    this.whatsApp,
    this.photo,
    this.isUserLoggedIn = false,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String mobile;
  final int workExperience;
  final String emailId;
  final String designation;
  final String whatsApp;
  final String photo;

  get userName => '${this.firstName} ${this.lastName}';

  LoginResponse copyWith({
    String firstName,
    String lastName,
    String gender,
    String mobile,
    int workExperience,
    String emailId,
    String designation,
    String whatsApp,
    String photo,
    bool isUserLoggedIn,
  }) =>
      LoginResponse(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        mobile: mobile ?? this.mobile,
        workExperience: workExperience ?? this.workExperience,
        emailId: emailId ?? this.emailId,
        designation: designation ?? this.designation,
        whatsApp: whatsApp ?? this.whatsApp,
        photo: photo ?? this.photo,
        isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
      );

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
      firstName: json["firstName"],
      lastName: json["lastName"],
      gender: json["gender"],
      mobile: json["mobile"],
      workExperience: json["workExperience"],
      emailId: json["emailId"],
      designation: json["designation"],
      whatsApp: json["WhatsApp"],
      photo: json["photo"],
      isUserLoggedIn: json['isUserLoggedIn']);

  Map<String, dynamic> toMap() => {
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "mobile": mobile,
        "workExperience": workExperience,
        "emailId": emailId,
        "designation": designation,
        "WhatsApp": whatsApp,
        "photo": photo,
        "isUserLoggedIn": isUserLoggedIn,
      };
}
