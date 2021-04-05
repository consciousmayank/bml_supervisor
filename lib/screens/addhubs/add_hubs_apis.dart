import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:flutter/material.dart';

import '../../app_level/BaseApi.dart';
import '../../models/ApiResponse.dart';
import '../../models/parent_api_response.dart';

abstract class AddHubsApis{
  Future<ApiResponse> addHub({@required AddHubRequest request});
}

class AddHubApisImpl extends BaseApi implements AddHubsApis{
  @override
  Future<ApiResponse> addHub({AddHubRequest request}) async{
    ApiResponse _apiResponse =
    ApiResponse(status: 'failed', message: 'Failed to add Hub');
    ParentApiResponse _parentApiResponse =
        await apiService.addHub(request: request);
    if (filterResponse(_parentApiResponse) != null) {
      _apiResponse = ApiResponse.fromMap(_parentApiResponse.response.data);
    }

    return _apiResponse;
  }

}