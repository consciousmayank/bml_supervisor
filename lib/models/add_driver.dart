// To parse this JSON data, do
//
//     final addDriverRequest = addDriverRequestFromMap(jsonString);

import 'dart:convert';

class AddDriverRequest {
  AddDriverRequest({
    this.salutation,
    this.firstName,
    this.lastName,
    this.dob,
    this.dateOfJoin,
    this.gender,
    this.fatherName,
    this.mobile,
    this.mobileAlternate,
    this.mobileWhatsApp,
    this.drivingLicense,
    this.aadhaar,
    this.photo,
    this.address,
    this.workExperienceYr,
    this.remarks,
    this.vehicleId,
  });

  final String salutation;
  final String firstName;
  final String lastName;
  final String dob;
  final String dateOfJoin;
  final String gender;
  final String fatherName;
  final String mobile;
  final String mobileAlternate;
  final String mobileWhatsApp;
  final String drivingLicense;
  final String aadhaar;
  final String photo;
  final List<Address> address;
  final int workExperienceYr;
  final String remarks;
  final String vehicleId;

  AddDriverRequest copyWith({
    String salutation,
    String firstName,
    String lastName,
    String dob,
    String dateOfJoin,
    String gender,
    String fatherName,
    String mobile,
    String mobileAlternate,
    String mobileWhatsApp,
    String drivingLicense,
    String aadhaar,
    String photo,
    List<Address> address,
    int workExperienceYr,
    String remarks,
    String vehicleId,
  }) =>
      AddDriverRequest(
        salutation: salutation ?? this.salutation,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        dateOfJoin: dateOfJoin ?? this.dateOfJoin,
        gender: gender ?? this.gender,
        fatherName: fatherName ?? this.fatherName,
        mobile: mobile ?? this.mobile,
        mobileAlternate: mobileAlternate ?? this.mobileAlternate,
        mobileWhatsApp: mobileWhatsApp ?? this.mobileWhatsApp,
        drivingLicense: drivingLicense ?? this.drivingLicense,
        aadhaar: aadhaar ?? this.aadhaar,
        photo: photo ?? this.photo,
        address: address ?? this.address,
        workExperienceYr: workExperienceYr ?? this.workExperienceYr,
        remarks: remarks ?? this.remarks,
        vehicleId: vehicleId ?? this.vehicleId,
      );

  factory AddDriverRequest.fromJson(String str) =>
      AddDriverRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddDriverRequest.fromMap(Map<String, dynamic> json) =>
      AddDriverRequest(
        salutation: json["salutation"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"],
        dateOfJoin: json["dateOfJoin"],
        gender: json["gender"],
        fatherName: json["fatherName"],
        mobile: json["mobile"],
        mobileAlternate: json["mobileAlternate"],
        mobileWhatsApp: json["mobileWhatsApp"],
        drivingLicense: json["drivingLicense"],
        aadhaar: json["aadhaar"],
        photo: json["photo"],
        address:
            List<Address>.from(json["address"].map((x) => Address.fromMap(x))),
        workExperienceYr: json["workExperienceYr"],
        remarks: json["remarks"],
        vehicleId: json["vehicleId"],
      );

  Map<String, dynamic> toMap() => {
        "salutation": salutation,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob,
        "dateOfJoin": dateOfJoin,
        "gender": gender,
        "fatherName": fatherName,
        "mobile": mobile,
        "mobileAlternate": mobileAlternate,
        "mobileWhatsApp": mobileWhatsApp,
        "drivingLicense": drivingLicense,
        "aadhaar": aadhaar,
        "photo": photo,
        "address": List<dynamic>.from(address.map((x) => x.toMap())),
        "workExperienceYr": workExperienceYr,
        "remarks": remarks,
        "vehicleId": vehicleId,
      };
}

class Address {
  Address({
    this.type,
    this.addressLine1,
    this.addressLine2,
    this.locality,
    this.nearby,
    this.city,
    this.state,
    this.country,
    this.pincode,
  });

  final String type;
  final String addressLine1;
  final String addressLine2;
  final String locality;
  final String nearby;
  final String city;
  final String state;
  final String country;
  final String pincode;

  Address copyWith({
    String type,
    String addressLine1,
    String addressLine2,
    String locality,
    String nearby,
    String city,
    String state,
    String country,
    String pincode,
  }) =>
      Address(
        type: type ?? this.type,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        locality: locality ?? this.locality,
        nearby: nearby ?? this.nearby,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
      );

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        type: json["type"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        locality: json["locality"],
        nearby: json["nearby"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "locality": locality,
        "nearby": nearby,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
      };
}
