import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/get_daily_kilometers_info.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/models/view_entry_request.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:flutter/material.dart';

abstract class DailyEntryApis {
  Future<List<RoutesForSelectedClientAndDateResponse>>
      getRoutesForSelectedClientAndDate({
    @required String clientId,
    @required String date,
  });

  Future<EntryLog> getLatestDailyEntry({@required String registrationNumber});
  Future<ApiResponse> submitVehicleEntry({@required EntryLog entryLogRequest});
  Future<List<ViewEntryResponse>> getDailyEntries(
      {@required ViewEntryRequest viewEntryRequest});
  Future<List<GetDailyKilometerInfo>> getDailyKmInfo({@required String date});
}

class DailyEntryApisImpl extends BaseApi implements DailyEntryApis {
  @override
  Future<List<RoutesForSelectedClientAndDateResponse>>
      getRoutesForSelectedClientAndDate({String clientId, String date}) async {
    List<RoutesForSelectedClientAndDateResponse> _routesList = [];

    ParentApiResponse apiResponse = await apiService
        .getRoutesForSelectedClientAndDate(clientId: clientId, date: date);

    if (apiResponse.error == null) {
      if (apiResponse.isNoDataFound()) {
        snackBarService.showSnackbar(message: ParentApiResponse().emptyResult);
      } else {
        var routesList = apiResponse.response.data as List;

        routesList.forEach((element) {
          RoutesForSelectedClientAndDateResponse routes =
              RoutesForSelectedClientAndDateResponse.fromMap(element);

          _routesList.add(routes);
        });
      }
    } else {
      snackBarService.showSnackbar(
        message: apiResponse.getErrorReason(),
      );
    }

    return _routesList;
  }

  @override
  Future<EntryLog> getLatestDailyEntry({String registrationNumber}) async {
    EntryLog _vehicleLatestDailyEntry;
    ParentApiResponse apiResponse = await apiService.getLatestDailyEntry(
      registrationNumber: registrationNumber,
    );

    if (filterResponse(apiResponse) != null) {
      _vehicleLatestDailyEntry = EntryLog.fromMap(apiResponse.response.data);
    }

    return _vehicleLatestDailyEntry;
  }

  @override
  Future<ApiResponse> submitVehicleEntry({EntryLog entryLogRequest}) async {
    ApiResponse dailyEntrySubmitResponse =
        ApiResponse(status: 'failed', message: 'Something went wrong');
    ParentApiResponse apiResponse =
        await apiService.submitVehicleEntry(entryLogRequest: entryLogRequest);

    if (filterResponse(apiResponse) != null) {
      dailyEntrySubmitResponse = ApiResponse.fromMap(apiResponse.response.data);
    }

    return dailyEntrySubmitResponse;
  }

  @override
  Future<List<ViewEntryResponse>> getDailyEntries(
      {ViewEntryRequest viewEntryRequest}) async {
    List<ViewEntryResponse> apiResponseList = [];
    final ParentApiResponse response =
        await apiService.getDailyEntries(viewEntryRequest: viewEntryRequest);
    if (filterResponse(response) != null) {
      var list = response.response.data as List;
      for (Map singleItem in list) {
        ViewEntryResponse singleSearchResult =
            ViewEntryResponse.fromMap(singleItem);
        apiResponseList.add(singleSearchResult);
      }
    }

    return apiResponseList;
  }

  @override
  Future<List<GetDailyKilometerInfo>> getDailyKmInfo({String date}) async {
    List<GetDailyKilometerInfo> _responseList = [];
    final ParentApiResponse response =
        await apiService.getDailyKmInfo(date: date);
    if (filterResponse(response) != null) {
      var list = response.response.data as List;
      for (Map singleItem in list) {
        GetDailyKilometerInfo singleInfoObject =
            GetDailyKilometerInfo.fromMap(singleItem);
        _responseList.add(singleInfoObject);
      }
    }
    return _responseList;
  }
}
