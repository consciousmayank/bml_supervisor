// To parse this JSON data, do
//
//     final userProfileResponse = userProfileResponseFromJson(jsonString);

import 'dart:convert';

List<UserProfileResponse> userProfileResponseFromJson(String str) => List<UserProfileResponse>.from(json.decode(str).map((x) => UserProfileResponse.fromJson(x)));

String userProfileResponseToJson(List<UserProfileResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfileResponse {
  UserProfileResponse({
    this.firstName,
    this.lastName,
    this.gender,
    this.whatsApp,
    this.mobile,
    this.workExperience,
    this.photo,
    this.emailId,
    this.designation,
  });

  String firstName;
  String lastName;
  String gender;
  String whatsApp;
  String mobile;
  double workExperience;
  String photo;
  String emailId;
  String designation;

  UserProfileResponse copyWith({
    String firstName,
    String lastName,
    String gender,
    String whatsApp,
    String mobile,
    double workExperience,
    String photo,
    String emailId,
    String designation,
  }) =>
      UserProfileResponse(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        whatsApp: whatsApp ?? this.whatsApp,
        mobile: mobile ?? this.mobile,
        workExperience: workExperience ?? this.workExperience,
        photo: photo ?? this.photo,
        emailId: emailId ?? this.emailId,
        designation: designation ?? this.designation,
      );

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => UserProfileResponse(
    firstName: json["firstName"],
    lastName: json["lastName"],
    gender: json["gender"],
    whatsApp: json["WhatsApp"],
    mobile: json["mobile"],
    workExperience: json["workExperience"].toDouble(),
    photo: json["photo"],
    emailId: json["emailId"],
    designation: json["designation"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "gender": gender,
    "WhatsApp": whatsApp,
    "mobile": mobile,
    "workExperience": workExperience,
    "photo": photo,
    "emailId": emailId,
    "designation": designation,
  };
}
