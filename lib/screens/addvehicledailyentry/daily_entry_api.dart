import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class DailyEntryApis {
  Future<List<RoutesForSelectedClientAndDateResponse>>
      getRoutesForSelectedClientAndDate({
    @required String clientId,
    @required String date,
  });

  Future<EntryLog> getLatestDailyEntry({@required String registrationNumber});
  Future<bool> submitVehicleEntry({@required EntryLog entryLogRequest});
}

//entryLog = await apiService.getLatestDailyEntry(registrationNumber: registrationNumber);

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
  Future<bool> submitVehicleEntry({EntryLog entryLogRequest}) async {
    bool submitSuccessful = true;
    ApiResponse dailyEntrySubmitResponse;
    ParentApiResponse apiResponse =
        await apiService.submitVehicleEntry(entryLogRequest: entryLogRequest);

    if (filterResponse(apiResponse) != null) {
      dailyEntrySubmitResponse = ApiResponse.fromMap(apiResponse.response.data);
    } else {
      return false;
    }

    if (dailyEntrySubmitResponse.status == "success") {
      var dialogResponse =
          await locator<DialogService>().showConfirmationDialog(
        title: 'Congratulations...',
        description: dailyEntrySubmitResponse.message.split("!")[0],
      );
      if (dialogResponse == null || dialogResponse.confirmed) {
        submitSuccessful = true;
      }
    } else {
      var dialogResponse =
          await locator<DialogService>().showConfirmationDialog(
        title: 'Oops...',
        description: dailyEntrySubmitResponse.message,
      );

      if (dialogResponse == null || dialogResponse.confirmed) {
        submitSuccessful = false;
      }
    }

    return submitSuccessful;
  }
}
