import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/update_user_request.dart';
import 'package:bml_supervisor/models/user_profile_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileApi {
  Future<bool> changePassword(
      {@required String userName, @required String newPassword});

  // Future<UserProfileResponse> getUserProfile({bool showResponseToast = true});
  Future<ApiResponse> updateUserMobile({UpdateUserRequest request});
  Future<ApiResponse> updateUserEmail({UpdateUserRequest request});
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

  // @override
  // Future<UserProfileResponse> getUserProfile(
  //     {bool showResponseToast = true}) async {
  //   ParentApiResponse response = await apiService.getUserProfile();
  //   if (filterResponse(response, showSnackBar: showResponseToast) != null) {
  //     return UserProfileResponse.fromJson(response.response.data);
  //   } else {
  //     return null;
  //   }
  // }

  @override
  Future<ApiResponse> updateUserMobile({UpdateUserRequest request}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);
    ParentApiResponse parentApiResponse =
        await apiService.updateUserMobile(request: request);

    if (filterResponse(parentApiResponse) != null) {
      response = ApiResponse.fromMap(parentApiResponse.response.data);
      return response;
    }
    return null;
  }

  @override
  Future<ApiResponse> updateUserEmail({UpdateUserRequest request}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);
    ParentApiResponse parentApiResponse =
        await apiService.updateUserEmail(request: request);

    if (filterResponse(parentApiResponse) != null) {
      response = ApiResponse.fromMap(parentApiResponse.response.data);
      return response;
    }
    return null;
  }
}
