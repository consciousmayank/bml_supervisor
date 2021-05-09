import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';

abstract class LoginApis {
  Future<LoginResponse> login(String credentials);
}

class LoginApisImpl extends BaseApi implements LoginApis {
  @override
  Future<LoginResponse> login(String credentials) async {
    preferences.saveCredentials(credentials);
    ParentApiResponse loginResponse =
        await apiService.login(base64string: credentials);

    if (loginResponse.error == null) {
      //positive
      return LoginResponse.fromMap(loginResponse.response.data);
    } else {
      //negative
      snackBarService.showSnackbar(message: loginResponse.getErrorReason());
    }
    return null;
  }
}
