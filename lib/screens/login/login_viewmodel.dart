import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/login/login_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class LoginViewModel extends GeneralisedBaseViewModel {
  LoginApis _loginApi = locator<LoginApisImpl>();

  bool _hidePassword = true;

  bool get hidePassword => _hidePassword;

  set hidePassword(bool value) {
    _hidePassword = value;
    notifyListeners();
  }

  void login({String userName, String password}) async {
    setBusy(true);

    LoginResponse loginResponse =
        await _loginApi.login(getBase64String(value: '$userName:$password'));

    if (loginResponse != null) {
      if (loginResponse.userRole == 'ROLE_MANAGER') {
        PreferencesSavedUser preferencesSavedUser;
        preferencesSavedUser = PreferencesSavedUser(
            isUserLoggedIn: true,
            userRole: loginResponse.userRole,
            userName: '${loginResponse.firstName} ${loginResponse.lastName}');
        preferences.setLoggedInUser(preferencesSavedUser);
        preferences.saveCredentials(
          getBase64String(value: '$userName:$password'),
        );
        // locator<DioConfig>().configureDio();
        takeToClientSelect();
      } else {
        snackBarService.showSnackbar(
            message: 'You do not have access to use this app.');
      }
    }
    setBusy(false);
  }

  void takeToClientSelect() {
    navigationService.replaceWith(clientSelectPageRoute);
  }
}
