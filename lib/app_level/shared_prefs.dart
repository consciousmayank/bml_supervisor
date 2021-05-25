import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  final String userSelectedClient = "selected_client";
  final String userSelectedDuration = "selected_duration";
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
      _sharedPrefs.remove(userSelectedClient);
    } else {
      _sharedPrefs.setString(userSelectedClient, selectedClient.toJson());
    }
  }

  GetClientsResponse getSelectedClient() {
    String savedResponseString = _sharedPrefs.getString(userSelectedClient);
    if (savedResponseString == null) {
      return null;
    } else {
      return GetClientsResponse.fromJson(savedResponseString);
    }
  }

  void saveSelectedDuration(String selectedDuration) {
    if (selectedDuration == null) {
      _sharedPrefs.remove(userSelectedDuration);
    } else {
      _sharedPrefs.setString(userSelectedDuration, selectedDuration);
    }
  }

  String getSelectedDuration() {
    return _sharedPrefs.getString(userSelectedDuration) ?? "THIS MONTH";
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

  void setLoggedInUser(LoginResponse user) {
    if (user == null) {
      _sharedPrefs.remove(loggedInUser);
    } else {
      // _sharedPrefs.setString(loggedInUser, json.encode(user));
      _sharedPrefs.setString(loggedInUser, user.toJson());
    }
  }

  LoginResponse getUserLoggedIn() {
    String savedResponseString = _sharedPrefs.getString(loggedInUser);
    if (savedResponseString == null) {
      return null;
    } else {
      // return LoginResponse.fromJson(json.decode(savedResponseString));
      return LoginResponse.fromJson(savedResponseString);
    }
  }
}
