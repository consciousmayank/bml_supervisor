import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/foundation.dart';

abstract class AddRoutesApis{
  Future<ApiResponse> addRoute({@required CreateRouteRequest request});
}

class AddRouteApisImpl extends BaseApi implements AddRoutesApis{
  @override
  Future<ApiResponse> addRoute({CreateRouteRequest request}) async{
    ApiResponse _apiResponse =
    ApiResponse(status: 'failed', message: 'Failed to add Driver');

    ParentApiResponse _parentApiResponse =
    await apiService.addRoute(request: request);
    if (filterResponse(_parentApiResponse) != null) {
      _apiResponse = ApiResponse.fromMap(_parentApiResponse.response.data);
    }

    return _apiResponse;
  }
  
}