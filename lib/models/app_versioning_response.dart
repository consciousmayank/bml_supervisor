// To parse this JSON data, do
//
//     final appVersioningResponse = appVersioningResponseFromMap(jsonString);

import 'dart:convert';

class AppVersioningResponse {
  AppVersioningResponse({
    this.appName,
    this.title,
    this.major,
    this.minor,
    this.build,
    this.revision,
  });

  final String appName;
  final String title;
  final int major;
  final int minor;
  final int build;
  final int revision;

  AppVersioningResponse copyWith({
    String appName,
    String title,
    int major,
    int minor,
    int build,
    int revision,
  }) =>
      AppVersioningResponse(
        appName: appName ?? this.appName,
        title: title ?? this.title,
        major: major ?? this.major,
        minor: minor ?? this.minor,
        build: build ?? this.build,
        revision: revision ?? this.revision,
      );

  factory AppVersioningResponse.fromJson(String str) =>
      AppVersioningResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppVersioningResponse.fromMap(Map<String, dynamic> json) =>
      AppVersioningResponse(
        appName: json["appName"],
        title: json["title"],
        major: json["major"],
        minor: json["minor"],
        build: json["build"],
        revision: json["revision"],
      );

  Map<String, dynamic> toMap() => {
        "appName": appName,
        "title": title,
        "major": major,
        "minor": minor,
        "build": build,
        "revision": revision,
      };
}
