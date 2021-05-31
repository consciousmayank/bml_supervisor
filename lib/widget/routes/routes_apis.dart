import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/get_hub_details_response.dart';
import 'package:bml_supervisor/models/get_route_details_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/cupertino.dart';

abstract class RoutesApis {
  Future<GetRouteDetailsResponse> getRouteDetailsByRouteId(
      {@required int routeId});

  Future<GetHubDetailsResponse> getHubDetailsByHubId({@required int hubId});
}

class RoutesApisImpl extends BaseApi implements RoutesApis {
  @override
  Future<GetRouteDetailsResponse> getRouteDetailsByRouteId(
      {int routeId}) async {
    GetRouteDetailsResponse routeResponse;

    ParentApiResponse _response =
        await apiService.getRouteDetailsByRouteId(routeId: routeId);

    if (filterResponse(_response, showSnackBar: false) != null) {
      routeResponse = GetRouteDetailsResponse.fromMap(_response.response.data);
    }

    return routeResponse;
  }

  @override
  Future<GetHubDetailsResponse> getHubDetailsByHubId({int hubId}) async {
    GetHubDetailsResponse hubResponse;

    ParentApiResponse _response =
        await apiService.getHubDetailsByHubId(hubId: hubId);

    if (filterResponse(_response, showSnackBar: false) != null) {
      hubResponse = GetHubDetailsResponse.fromMap(_response.response.data);
    }

    return hubResponse;
  }
}
