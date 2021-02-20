import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/dashborad_tiles_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class DashBoardApis {
  Future<List<GetClientsResponse>> getClientList();

  Future<DashboardTilesStatsResponse> getDashboardTilesStats();
}

class DashBoardApisImpl implements DashBoardApis {
  ApiService apiService = locator<ApiService>();
  SnackbarService snackBarService = locator<SnackbarService>();

  @override
  Future<List<GetClientsResponse>> getClientList() async {
    List<GetClientsResponse> clientsList = [];
    ParentApiResponse apiResponse = await apiService.getClientsList();
    if (apiResponse.error == null) {
      //positive
      var list = apiResponse.response.data as List;
      list.forEach((element) {
        GetClientsResponse getClientsResponse =
            GetClientsResponse.fromMap(element);
        clientsList.add(getClientsResponse);
      });
    } else {
      //negative
      snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }
    return clientsList;
  }

  @override
  Future<DashboardTilesStatsResponse> getDashboardTilesStats() async {
    ParentApiResponse dashboardTilesData =
        await apiService.getDashboardTilesStats();
    if (dashboardTilesData.error == null) {
      //positive
      return DashboardTilesStatsResponse.fromJson(
          dashboardTilesData.response.data);
    } else {
      //negative
      snackBarService.showSnackbar(
          message: dashboardTilesData.getErrorReason());
    }

    return DashboardTilesStatsResponse(
        hubCount: 0, kmCount: 0, routeCount: 0, dueCount: 0);
  }
}
