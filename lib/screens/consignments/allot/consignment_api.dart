import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class ConsignmentApis {
  Future<SearchByRegNoResponse> getVehicleDetails(
      {@required String registrationNumber});

  Future<ApiResponse> createConsignment(
      {@required CreateConsignmentRequest createConsignmentRequest});
}

class ConsignmentApisImpl extends ConsignmentApis {
  ApiService _apiService = locator<ApiService>();
  SnackbarService _snackBarService = locator<SnackbarService>();

  @override
  Future<SearchByRegNoResponse> getVehicleDetails(
      {String registrationNumber}) async {
    SearchByRegNoResponse vehicleDetails;
    ParentApiResponse apiResponse =
        await _apiService.getVehicleDetails(registrationNumber);
    if (apiResponse.error == null) {
      //positive

      if (apiResponse.isNoDataFound()) {
        _snackBarService.showSnackbar(message: apiResponse.emptyResult);
      } else {
        vehicleDetails =
            SearchByRegNoResponse.fromMap(apiResponse.response.data);
      }
    } else {
      //negative
      _snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }
    return vehicleDetails;
  }

  @override
  Future<ApiResponse> createConsignment(
      {CreateConsignmentRequest createConsignmentRequest}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);

    ParentApiResponse apiResponse =
        await _apiService.createConsignment(request: createConsignmentRequest);
    if (apiResponse.error == null) {
      //positive

      if (apiResponse.isNoDataFound()) {
        _snackBarService.showSnackbar(message: apiResponse.emptyResult);
      } else {
        response = ApiResponse.fromMap(apiResponse.response.data);
      }
    } else {
      //negative
      _snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }

    return response;
  }
}
