import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_vehicle_request.dart';
import 'package:flutter/material.dart';
import 'package:bml/bml.dart';

abstract class VehicleApis {
  Future<ApiResponse> addVehicle({@required AddVehicleRequest request});
}

class VehicleApisImpl extends BaseApi implements VehicleApis {
  @override
  Future<ApiResponse> addVehicle({@required AddVehicleRequest request}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);

    ParentApiResponse apiResponse =
        await apiService.addVehicle(addVehicleRequest: request);

    if (filterResponse(apiResponse) != null) {
      response = ApiResponse.fromMap(apiResponse.response.data);
    }

    return response;
  }
}
