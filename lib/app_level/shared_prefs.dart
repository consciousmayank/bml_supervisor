import 'dart:convert';

import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  final String selected_client = "selected_client";
  final String selected_duration = "selected_duration";
  final String loggedInUserRole = "logged_in_user_role";
  final String loggedInUserName = "logged_in_user_name";
  final String loggedInUserCredentials = "logged_in_user_credentials";
  final String loggedInUser = "logged_in_user";

  void saveSelectedClient(GetClientsResponse selectedClient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (selectedClient == null) {
      await prefs.remove(selected_client);
    } else {
      await prefs.setString(selected_client, json.encode(selectedClient));
    }
  }

  Future<GetClientsResponse> getSelectedClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedResponseString = prefs.getString(selected_client);
    if (savedResponseString == null) {
      return GetClientsResponse(id: 1, title: "Golden Harvest");
    } else {
      return GetClientsResponse.fromJson(savedResponseString);
    }
  }

  void saveSelectedDuration(String selectedDuration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (selectedDuration == null) {
      await prefs.remove(selected_duration);
    } else {
      await prefs.setString(selected_duration, selectedDuration);
    }
  }

  Future<String> getSelectedDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(selected_duration) ?? "THIS MONTH";
  }

  void saveCredentials(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(loggedInUserCredentials);
    } else {
      await prefs.setString(loggedInUserCredentials, value);
    }
  }

  Future<String> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(loggedInUserCredentials) ?? "";
  }

  void setLoggedInUser(PreferencesSavedUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user == null) {
      await prefs.remove(loggedInUser);
    } else {
      await prefs.setString(loggedInUser, json.encode(user));
    }
  }

  Future<PreferencesSavedUser> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedResponseString = prefs.getString(loggedInUser);
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

    return splitRoles[splitRoles.length - 1];
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
