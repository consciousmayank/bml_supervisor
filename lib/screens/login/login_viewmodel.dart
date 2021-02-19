import 'package:bml_supervisor/app_level/dio_client.dart';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class LoginViewModel extends GeneralisedBaseViewModel {
  bool _hidePassword = true;

  bool get hidePassword => _hidePassword;

  set hidePassword(bool value) {
    _hidePassword = value;
    notifyListeners();
  }

  void login({String userName, String password}) async {
    setBusy(true);

    ParentApiResponse loginResponse = await apiService.login(
      userName: userName,
      base64string: getBase64String(value: '$userName:$password'),
    );

    if (loginResponse.error == null) {
      //positive
      PreferencesSavedUser preferencesSavedUser;
      preferencesSavedUser = PreferencesSavedUser(
          isUserLoggedIn: true,
          userRole: LoginResponse.fromMap(loginResponse.response.data).userRole,
          userName: userName);
      preferences.setLoggedInUser(preferencesSavedUser);
      preferences.saveCredentials(
        getBase64String(value: '$userName:$password'),
      );
      locator<DioConfig>().configureDio();
      takeToDashBoard();
    } else {
      //negative
      snackBarService.showSnackbar(message: loginResponse.getErrorReason());
    }
  }

  void takeToDashBoard() {
    navigationService.replaceWith(dashBoardPageRoute);
  }
}
