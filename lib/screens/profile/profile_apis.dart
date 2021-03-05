import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileApi {
  Future<bool> changePassword(
      {@required String userName, @required String newPassword});
}

class ProfileApisImpl extends BaseApi implements ProfileApi {
  @override
  Future<bool> changePassword({String userName, String newPassword}) async {
    ApiResponse _apiResponse = ApiResponse(
        status: "failed", message: "Password Change Failed! Try Again.");
    ParentApiResponse _parentApiResponse = await apiService.changePassword(
        userName: userName, newPassword: newPassword);

    if (filterResponse(_parentApiResponse) != null) {
      _apiResponse = ApiResponse.fromMap(_parentApiResponse.response.data);
    }

    snackBarService.showSnackbar(message: _apiResponse.message);
    if (_apiResponse.isSuccessful())
      MyPreferences().saveCredentials(
        getBase64String(value: '$userName:$newPassword'),
      );
    return _apiResponse.isSuccessful();
  }
}
