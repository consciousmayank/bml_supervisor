import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/completed_trips_details.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/cupertino.dart';

abstract class TripsApis {
  Future<CompletedTripsDetailsResponse> getCompletedTripsWithId(
      {@required int consignmentId});
}

class TripsApisImpl extends BaseApi implements TripsApis {
  @override
  Future<CompletedTripsDetailsResponse> getCompletedTripsWithId(
      {@required int consignmentId}) async {
    CompletedTripsDetailsResponse _response;
    ParentApiResponse apiResponse = await apiService.getCompletedTripsWithId(
      consignmentId: consignmentId.toString(),
      clientId: MyPreferences().getSelectedClient().clientId,
    );
    if (filterResponse(apiResponse) != null) {
      _response =
          CompletedTripsDetailsResponse.fromMap(apiResponse.response.data);
    }

    return _response;
  }
}
