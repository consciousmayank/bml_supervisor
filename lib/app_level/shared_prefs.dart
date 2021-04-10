import 'dart:convert';

import "package:bml_supervisor/app_level/string_extensions.dart";
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  final String selected_client = "selected_client";
  final String selected_duration = "selected_duration";
  final String loggedInUserRole = "logged_in_user_role";
  final String loggedInUserName = "logged_in_user_name";
  final String loggedInUserCredentials = "logged_in_user_credentials";
  final String loggedInUser = "logged_in_user";

  static SharedPreferences _sharedPrefs;

  factory MyPreferences() => MyPreferences._internal();

  MyPreferences._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  void saveSelectedClient(GetClientsResponse selectedClient) {
    if (selectedClient == null) {
      _sharedPrefs.remove(selected_client);
    } else {
      _sharedPrefs.setString(selected_client, json.encode(selectedClient));
    }
  }

  GetClientsResponse getSelectedClient() {
    String savedResponseString = _sharedPrefs.getString(selected_client);
    if (savedResponseString == null) {
      return null;
    } else {
      return GetClientsResponse.fromJson(savedResponseString);
    }
  }

  void saveSelectedDuration(String selectedDuration) {
    if (selectedDuration == null) {
      _sharedPrefs.remove(selected_duration);
    } else {
      _sharedPrefs.setString(selected_duration, selectedDuration);
    }
  }

  String getSelectedDuration() {
    return _sharedPrefs.getString(selected_duration) ?? "THIS MONTH";
  }

  void saveCredentials(String value) {
    if (value == null) {
      _sharedPrefs.remove(loggedInUserCredentials);
    } else {
      _sharedPrefs.setString(loggedInUserCredentials, value);
    }
  }

  String getCredentials() {
    return _sharedPrefs.getString(loggedInUserCredentials) ?? "";
  }

  void setLoggedInUser(PreferencesSavedUser user) {
    if (user == null) {
      _sharedPrefs.remove(loggedInUser);
    } else {
      _sharedPrefs.setString(loggedInUser, json.encode(user));
    }
  }

  PreferencesSavedUser getUserLoggedIn() {
    String savedResponseString = _sharedPrefs.getString(loggedInUser);
    if (savedResponseString == null) {
      return null;
    } else {
      return PreferencesSavedUser.fromJson(json.decode(savedResponseString));
    }
  }
}

class PreferencesSavedUser {
  PreferencesSavedUser({
    this.isUserLoggedIn,
    this.userRole,
    this.userName,
  });

  final bool isUserLoggedIn;
  final String userRole;
  final String userName;

  PreferencesSavedUser copyWith({
    bool isUserLoggedIn,
    String userRole,
    String userName,
  }) =>
      PreferencesSavedUser(
        isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
        userRole: userRole ?? this.userRole,
        userName: userName ?? this.userName,
      );

  String get role {
    List<String> splitRoles = userRole.split('_');

    return splitRoles[splitRoles.length - 1]
        .toLowerCase()
        .capitalizeFirstLetter();
  }

  String getUnEditedRole() {
    return userRole;
  }

  factory PreferencesSavedUser.fromJson(String str) =>
      PreferencesSavedUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PreferencesSavedUser.fromMap(Map<String, dynamic> json) =>
      PreferencesSavedUser(
        isUserLoggedIn: json["isUserLoggedIn"],
        userRole: json["userRole"],
        userName: json["userName"],
      );

  Map<String, dynamic> toMap() => {
        "isUserLoggedIn": isUserLoggedIn,
        "userRole": userRole,
        "userName": userName,
      };
}
