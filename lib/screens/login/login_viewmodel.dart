import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';

class LoginViewModel extends GeneralisedBaseViewModel {
  bool _hidePassword = true;

  bool get hidePassword => _hidePassword;

  set hidePassword(bool value) {
    _hidePassword = value;
    notifyListeners();
  }

  void login({String userName, String password}) async {
    var response = await apiService.login(
      userName: userName,
      base64string: getBase64String(value: '$userName:$password'),
    );

    PreferencesSavedUser preferencesSavedUser;
    try {
      Response apiResponse = response;
      if (apiResponse.statusCode == 200) {
        preferencesSavedUser = PreferencesSavedUser(
            isUserLoggedIn: true,
            userRole: LoginResponse.fromMap(apiResponse.data).userRole,
            userName: userName);
        preferences.setLoggedInUser(preferencesSavedUser);
        takeToDashBoard();
      } else {
        preferences.setLoggedInUser(null);
      }
    } catch (e) {
      preferences.setLoggedInUser(null);
    }
  }

  void takeToDashBoard() {
    navigationService.navigateTo(dashBoardPageRoute);
  }
}
