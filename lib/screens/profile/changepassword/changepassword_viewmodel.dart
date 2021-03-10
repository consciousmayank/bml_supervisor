import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';

import '../profile_apis.dart';

class ChangePasswordViewModel extends GeneralisedBaseViewModel {
  bool _passwordVisible = true;
  bool _reEnterPasswordVisible = true;

  bool get passwordVisible => _passwordVisible;

  set passwordVisible(bool value) {
    _passwordVisible = value;
    notifyListeners();
  }

  ProfileApi _profileApi = locator<ProfileApisImpl>();

  void changePassword(
      {@required String userId, @required String password}) async {
    setBusy(true);
    bool response = await _profileApi.changePassword(
        userName: getUserName(value: userId).split(':')[0],
        newPassword: password);
    setBusy(false);
    if (response) {
      navigationService.back();
      navigationService.back();
    }
  }

  bool get reEnterPasswordVisible => _reEnterPasswordVisible;

  set reEnterPasswordVisible(bool value) {
    _reEnterPasswordVisible = value;
    notifyListeners();
  }
}
