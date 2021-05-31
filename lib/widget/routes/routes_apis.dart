import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/get_route_details_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/cupertino.dart';

abstract class RoutesApis {
  Future<GetRouteDetailsResponse> getRouteDetailsByRouteId(
      {@required int routeId});
}

class RoutesApisImpl extends BaseApi implements RoutesApis{
  @override
  Future<GetRouteDetailsResponse> getRouteDetailsByRouteId({int routeId}) async {
    GetRouteDetailsResponse routeResponse;

    ParentApiResponse _response =
    await apiService.getRouteDetailsByRouteId(routeId: routeId);

    if (filterResponse(_response, showSnackBar: false) != null) {
      routeResponse = GetRouteDetailsResponse.fromMap(_response.response.data);
    }

    return routeResponse;

  }

}