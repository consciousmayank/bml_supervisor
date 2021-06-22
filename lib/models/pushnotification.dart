// To parse this JSON data, do
//
//     final pushnotification = pushnotificationFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Pushnotification {
  Pushnotification({
    @required this.priority,
    @required this.data,
    @required this.notification,
    @required this.to,
  });

  final String priority;
  final Data data;
  final Notification notification;
  final String to;

  Pushnotification copyWith({
    String priority,
    Data data,
    Notification notification,
    String to,
  }) =>
      Pushnotification(
        priority: priority ?? this.priority,
        data: data ?? this.data,
        notification: notification ?? this.notification,
        to: to ?? this.to,
      );

  factory Pushnotification.fromJson(String str) =>
      Pushnotification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pushnotification.fromMap(Map<String, dynamic> json) =>
      Pushnotification(
        priority: json["priority"],
        data: Data.fromMap(json["data"]),
        notification: Notification.fromMap(json["notification"]),
        to: json["to"],
      );

  Map<String, dynamic> toMap() => {
        "priority": priority,
        "data": data.toMap(),
        "notification": notification.toMap(),
        "to": to,
      };
}

class Data {
  Data({
    @required this.clickAction,
    @required this.title,
    @required this.body,
  });

  final String clickAction;
  final String title;
  final String body;

  Data copyWith({
    String clickAction,
    String title,
    String body,
  }) =>
      Data(
        clickAction: clickAction ?? this.clickAction,
        title: title ?? this.title,
        body: body ?? this.body,
      );

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        clickAction: json["click_action"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toMap() => {
        "click_action": clickAction,
        "title": title,
        "body": body,
      };
}

class Notification {
  Notification({
    @required this.title,
    @required this.body,
  });

  final String title;
  final String body;

  Notification copyWith({
    String title,
    String body,
  }) =>
      Notification(
        title: title ?? this.title,
        body: body ?? this.body,
      );

  factory Notification.fromJson(String str) =>
      Notification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "body": body,
      };
}
