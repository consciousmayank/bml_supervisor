import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/completed_trips_details.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/cupertino.dart';

abstract class TripsApis {
  Future<CompletedTripsDetailsResponse> getCompletedTripsWithId(
      {@required int consignmentId});

  Future<ApiResponse> rejectCompletedTripWithId({@required int consignmentId});
}

class TripsApisImpl extends BaseApi implements TripsApis {
  @override
  Future<CompletedTripsDetailsResponse> getCompletedTripsWithId(
      {@required int consignmentId}) async {
    CompletedTripsDetailsResponse _response;
    ParentApiResponse apiResponse = await apiService.getCompletedTripsWithId(
      consignmentId: consignmentId.toString(),
      clientId: preferences.getSelectedClient().clientId,
    );
    if (filterResponse(apiResponse) != null) {
      _response =
          CompletedTripsDetailsResponse.fromMap(apiResponse.response.data);
    }

    return _response;
  }

  @override
  Future<ApiResponse> rejectCompletedTripWithId({int consignmentId}) async {
    ApiResponse _apiResponse = ApiResponse(
        status: 'failed',
        message: 'Failed to Complete Action Please try again');

    ParentApiResponse _parentApiResponse =
        await apiService.rejectCompletedTripWithId(
      consignmentId: consignmentId,
    );
    if (filterResponse(_parentApiResponse) != null) {
      _apiResponse = ApiResponse.fromMap(_parentApiResponse.response.data);
    }

    return _apiResponse;
  }
}
