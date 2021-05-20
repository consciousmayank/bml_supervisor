// To parse this JSON data, do
//
//     final userProfileResponse = userProfileResponseFromMap(jsonString);

import 'dart:convert';

class UserProfileResponse {
  UserProfileResponse({
    this.id,
    this.vendorId,
    this.designation,
    this.salutation,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.fatherName,
    this.nationality,
    this.mobile,
    this.mobileAlternate,
    this.mobileWhatsApp,
    this.email,
    this.aadhaar,
    this.address,
    this.bank,
    this.salary,
    this.qualification,
    this.dateOfJoin,
    this.dateOfLeave,
    this.workExperienceYr,
    this.lastCompany,
    this.lastCompanyDol,
    this.policyStatus,
    this.policyNumber,
    this.policyExpirationDate,
    this.photo,
    this.remarks,
    this.username,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final int vendorId;
  final int designation;
  final String salutation;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String fatherName;
  final String nationality;
  final String mobile;
  final String mobileAlternate;
  final String mobileWhatsApp;
  final String email;
  final String aadhaar;
  final List<dynamic> address;
  final List<dynamic> bank;
  final List<dynamic> salary;
  final List<dynamic> qualification;
  final String dateOfJoin;
  final dynamic dateOfLeave;
  final int workExperienceYr;
  final String lastCompany;
  final dynamic lastCompanyDol;
  final bool policyStatus;
  final dynamic policyNumber;
  final dynamic policyExpirationDate;
  final String photo;
  final String remarks;
  final String username;
  final bool status;
  final String creationdate;
  final String lastupdated;

  UserProfileResponse copyWith({
    int id,
    int vendorId,
    int designation,
    String salutation,
    String firstName,
    String lastName,
    String dob,
    String gender,
    String bloodGroup,
    String fatherName,
    String nationality,
    String mobile,
    String mobileAlternate,
    String mobileWhatsApp,
    String email,
    String aadhaar,
    List<dynamic> address,
    List<dynamic> bank,
    List<dynamic> salary,
    List<dynamic> qualification,
    String dateOfJoin,
    dynamic dateOfLeave,
    int workExperienceYr,
    String lastCompany,
    dynamic lastCompanyDol,
    bool policyStatus,
    dynamic policyNumber,
    dynamic policyExpirationDate,
    String photo,
    String remarks,
    String username,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      UserProfileResponse(
        id: id ?? this.id,
        vendorId: vendorId ?? this.vendorId,
        designation: designation ?? this.designation,
        salutation: salutation ?? this.salutation,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        gender: gender ?? this.gender,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        fatherName: fatherName ?? this.fatherName,
        nationality: nationality ?? this.nationality,
        mobile: mobile ?? this.mobile,
        mobileAlternate: mobileAlternate ?? this.mobileAlternate,
        mobileWhatsApp: mobileWhatsApp ?? this.mobileWhatsApp,
        email: email ?? this.email,
        aadhaar: aadhaar ?? this.aadhaar,
        address: address ?? this.address,
        bank: bank ?? this.bank,
        salary: salary ?? this.salary,
        qualification: qualification ?? this.qualification,
        dateOfJoin: dateOfJoin ?? this.dateOfJoin,
        dateOfLeave: dateOfLeave ?? this.dateOfLeave,
        workExperienceYr: workExperienceYr ?? this.workExperienceYr,
        lastCompany: lastCompany ?? this.lastCompany,
        lastCompanyDol: lastCompanyDol ?? this.lastCompanyDol,
        policyStatus: policyStatus ?? this.policyStatus,
        policyNumber: policyNumber ?? this.policyNumber,
        policyExpirationDate: policyExpirationDate ?? this.policyExpirationDate,
        photo: photo ?? this.photo,
        remarks: remarks ?? this.remarks,
        username: username ?? this.username,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory UserProfileResponse.fromJson(String str) =>
      UserProfileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileResponse.fromMap(Map<String, dynamic> json) =>
      UserProfileResponse(
        id: json["id"],
        vendorId: json["vendorId"],
        designation: json["designation"],
        salutation: json["salutation"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"],
        gender: json["gender"],
        bloodGroup: json["bloodGroup"],
        fatherName: json["fatherName"],
        nationality: json["nationality"],
        mobile: json["mobile"],
        mobileAlternate: json["mobileAlternate"],
        mobileWhatsApp: json["mobileWhatsApp"],
        email: json["email"],
        aadhaar: json["aadhaar"],
        address: List<dynamic>.from(json["address"].map((x) => x)),
        bank: List<dynamic>.from(json["bank"].map((x) => x)),
        salary: List<dynamic>.from(json["salary"].map((x) => x)),
        qualification: List<dynamic>.from(json["qualification"].map((x) => x)),
        dateOfJoin: json["dateOfJoin"],
        dateOfLeave: json["dateOfLeave"],
        workExperienceYr: json["workExperienceYr"],
        lastCompany: json["lastCompany"],
        lastCompanyDol: json["lastCompanyDol"],
        policyStatus: json["policyStatus"],
        policyNumber: json["policyNumber"],
        policyExpirationDate: json["policyExpirationDate"],
        photo: json["photo"],
        remarks: json["remarks"],
        username: json["username"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "vendorId": vendorId,
        "designation": designation,
        "salutation": salutation,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob,
        "gender": gender,
        "bloodGroup": bloodGroup,
        "fatherName": fatherName,
        "nationality": nationality,
        "mobile": mobile,
        "mobileAlternate": mobileAlternate,
        "mobileWhatsApp": mobileWhatsApp,
        "email": email,
        "aadhaar": aadhaar,
        "address": List<dynamic>.from(address.map((x) => x)),
        "bank": List<dynamic>.from(bank.map((x) => x)),
        "salary": List<dynamic>.from(salary.map((x) => x)),
        "qualification": List<dynamic>.from(qualification.map((x) => x)),
        "dateOfJoin": dateOfJoin,
        "dateOfLeave": dateOfLeave,
        "workExperienceYr": workExperienceYr,
        "lastCompany": lastCompany,
        "lastCompanyDol": lastCompanyDol,
        "policyStatus": policyStatus,
        "policyNumber": policyNumber,
        "policyExpirationDate": policyExpirationDate,
        "photo": photo,
        "remarks": remarks,
        "username": username,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
