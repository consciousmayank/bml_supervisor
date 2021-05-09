import 'dart:typed_data';

import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/update_user_request.dart';
import 'package:bml_supervisor/models/user_profile_response.dart';
import 'package:bml_supervisor/screens/profile/profile_apis.dart';
import 'package:bml/src/widget_utils.dart';

class UserProfileViewModel extends GeneralisedBaseViewModel {
  ProfileApi _profileApi = locator<ProfileApisImpl>();
  Uint8List _image;

  Uint8List get image => _image;

  set image(Uint8List value) {
    _image = value;
    notifyListeners();
  }

  UserProfileResponse _userProfile;

  UserProfileResponse get userProfile => _userProfile;

  set userProfile(UserProfileResponse value) {
    _userProfile = value;
    notifyListeners();
  }

  bool _isMobileUpdated = false;

  bool get isMobileUpdated => _isMobileUpdated;

  set isMobileUpdated(bool value) {
    _isMobileUpdated = value;
    notifyListeners();
  }

  bool _isEmailUpdate = false;

  bool get isEmailUpdate => _isEmailUpdate;

  set isEmailUpdate(bool value) {
    _isEmailUpdate = value;
    notifyListeners();
  }

  Future getUserProfile() async {
    setBusy(true);
    UserProfileResponse profileResponse = await _profileApi.getUserProfile();
    if (profileResponse != null) {
      userProfile = profileResponse;
      image = Utils().getImageFromBase64String(base64String: userProfile.photo);
    }
    notifyListeners();
    setBusy(false);
  }

  Future updateMobileNumber({UpdateUserRequest request}) async {
    setBusy(true);
    isEmailUpdate = false;
    ApiResponse apiResponse =
        await _profileApi.updateUserMobile(request: request);
    if (apiResponse.isSuccessful()) {
      isMobileUpdated = true;
    }
    snackBarService.showSnackbar(message: apiResponse.message);
    notifyListeners();
    setBusy(false);
  }

  Future updateEmail({UpdateUserRequest request}) async {
    setBusy(true);
    isEmailUpdate = false;
    ApiResponse apiResponse =
        await _profileApi.updateUserEmail(request: request);
    if (apiResponse.isSuccessful()) {
      isEmailUpdate = true;
    }
    snackBarService.showSnackbar(message: apiResponse.message);
    notifyListeners();
    setBusy(false);
  }
}
