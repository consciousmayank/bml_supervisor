// To parse this JSON data, do
//
//     final driverInfo = driverInfoFromMap(jsonString);

import 'dart:convert';

class DriverInfo {
  DriverInfo({
    this.id,
    this.designation,
    this.salutation,
    this.firstName,
    this.lastName,
    this.dob,
    this.dateOfJoin,
    this.gender,
    this.bloodGroup,
    this.fatherName,
    this.nationality,
    this.mobile,
    this.mobileAlternate,
    this.mobileWhatsApp,
    this.email,
    this.drivingLicense,
    this.aadhaar,
    this.address,
    this.bank,
    this.workExperienceYr,
    this.lastCompany,
    this.lastCompanyDol,
    this.photo,
    this.remarks,
    this.username,
    this.vehicleId,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final int designation;
  final String salutation;
  final String firstName;
  final String lastName;
  final String dob;
  final String dateOfJoin;
  final String gender;
  final String bloodGroup;
  final String fatherName;
  final dynamic nationality;
  final String mobile;
  final String mobileAlternate;
  final String mobileWhatsApp;
  final dynamic email;
  final String drivingLicense;
  final String aadhaar;
  final List<Address> address;
  final List<dynamic> bank;
  final int workExperienceYr;
  final dynamic lastCompany;
  final dynamic lastCompanyDol;
  final String photo;
  final String remarks;
  final String username;
  final String vehicleId;
  final bool status;
  final String creationdate;
  final String lastupdated;

  DriverInfo copyWith({
    int id,
    int designation,
    String salutation,
    String firstName,
    String lastName,
    String dob,
    String dateOfJoin,
    String gender,
    String bloodGroup,
    String fatherName,
    dynamic nationality,
    String mobile,
    String mobileAlternate,
    String mobileWhatsApp,
    dynamic email,
    String drivingLicense,
    String aadhaar,
    List<Address> address,
    List<dynamic> bank,
    int workExperienceYr,
    dynamic lastCompany,
    dynamic lastCompanyDol,
    String photo,
    String remarks,
    String username,
    String vehicleId,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      DriverInfo(
        id: id ?? this.id,
        designation: designation ?? this.designation,
        salutation: salutation ?? this.salutation,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        dateOfJoin: dateOfJoin ?? this.dateOfJoin,
        gender: gender ?? this.gender,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        fatherName: fatherName ?? this.fatherName,
        nationality: nationality ?? this.nationality,
        mobile: mobile ?? this.mobile,
        mobileAlternate: mobileAlternate ?? this.mobileAlternate,
        mobileWhatsApp: mobileWhatsApp ?? this.mobileWhatsApp,
        email: email ?? this.email,
        drivingLicense: drivingLicense ?? this.drivingLicense,
        aadhaar: aadhaar ?? this.aadhaar,
        address: address ?? this.address,
        bank: bank ?? this.bank,
        workExperienceYr: workExperienceYr ?? this.workExperienceYr,
        lastCompany: lastCompany ?? this.lastCompany,
        lastCompanyDol: lastCompanyDol ?? this.lastCompanyDol,
        photo: photo ?? this.photo,
        remarks: remarks ?? this.remarks,
        username: username ?? this.username,
        vehicleId: vehicleId ?? this.vehicleId,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory DriverInfo.fromJson(String str) =>
      DriverInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DriverInfo.fromMap(Map<String, dynamic> json) => DriverInfo(
        id: json["id"],
        designation: json["designation"],
        salutation: json["salutation"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"],
        dateOfJoin: json["dateOfJoin"],
        gender: json["gender"],
        bloodGroup: json["bloodGroup"],
        fatherName: json["fatherName"],
        nationality: json["nationality"],
        mobile: json["mobile"],
        mobileAlternate: json["mobileAlternate"],
        mobileWhatsApp: json["mobileWhatsApp"],
        email: json["email"],
        drivingLicense: json["drivingLicense"],
        aadhaar: json["aadhaar"],
        address:
            List<Address>.from(json["address"].map((x) => Address.fromMap(x))),
        bank: List<dynamic>.from(json["bank"].map((x) => x)),
        workExperienceYr: json["workExperienceYr"],
        lastCompany: json["lastCompany"],
        lastCompanyDol: json["lastCompanyDol"],
        photo: json["photo"],
        remarks: json["remarks"],
        username: json["username"],
        vehicleId: json["vehicleId"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "designation": designation,
        "salutation": salutation,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob,
        "dateOfJoin": dateOfJoin,
        "gender": gender,
        "bloodGroup": bloodGroup,
        "fatherName": fatherName,
        "nationality": nationality,
        "mobile": mobile,
        "mobileAlternate": mobileAlternate,
        "mobileWhatsApp": mobileWhatsApp,
        "email": email,
        "drivingLicense": drivingLicense,
        "aadhaar": aadhaar,
        "address": List<dynamic>.from(address.map((x) => x.toMap())),
        "bank": List<dynamic>.from(bank.map((x) => x)),
        "workExperienceYr": workExperienceYr,
        "lastCompany": lastCompany,
        "lastCompanyDol": lastCompanyDol,
        "photo": photo,
        "remarks": remarks,
        "username": username,
        "vehicleId": vehicleId,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}

class Address {
  Address({
    this.id,
    this.type,
    this.addressLine1,
    this.addressLine2,
    this.locality,
    this.nearby,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.status,
    this.creationdate,
    this.lastupdated,
  });

  final int id;
  final String type;
  final String addressLine1;
  final String addressLine2;
  final String locality;
  final String nearby;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final bool status;
  final String creationdate;
  final String lastupdated;

  Address copyWith({
    int id,
    String type,
    String addressLine1,
    String addressLine2,
    String locality,
    String nearby,
    String city,
    String state,
    String country,
    String pincode,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      Address(
        id: id ?? this.id,
        type: type ?? this.type,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        locality: locality ?? this.locality,
        nearby: nearby ?? this.nearby,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"],
        type: json["type"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        locality: json["locality"],
        nearby: json["nearby"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "locality": locality,
        "nearby": nearby,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
