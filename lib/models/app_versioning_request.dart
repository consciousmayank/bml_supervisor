// To parse this JSON data, do
//
//     final appVersioningRequest = appVersioningRequestFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

class AppVersioningRequest {
  AppVersioningRequest({
    @required this.appName,
  });

  final String appName;

  AppVersioningRequest copyWith({
    String appName,
  }) =>
      AppVersioningRequest(
        appName: appName ?? this.appName,
      );

  factory AppVersioningRequest.fromJson(String str) =>
      AppVersioningRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppVersioningRequest.fromMap(Map<String, dynamic> json) =>
      AppVersioningRequest(
        appName: json["appName"],
      );

  Map<String, dynamic> toMap() => {
        "appName": appName,
      };
}
