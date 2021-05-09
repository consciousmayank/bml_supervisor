import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/models/dashborad_tiles_response.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:bml/bml.dart';

abstract class DashBoardApis {
  Future<List<GetClientsResponse>> getClientList();
  Future<List<FetchRoutesResponse>> getRoutes({@required String clientId});
  Future<List<FetchHubsResponse>> getHubs({@required int routeId});
  Future<DashboardTilesStatsResponse> getDashboardTilesStats(
      {@required String clientId});
  Future<List<GetDistributorsResponse>> getDistributors(
      {@required String clientId});
  Future<List<ConsignmentTrackingStatusResponse>> getConsignmentTrackingStatus(
      {@required String clientId, @required TripStatus tripStatus});
}

class DashBoardApisImpl extends BaseApi implements DashBoardApis {
  ApiService apiService = locator<ApiService>();
  SnackbarService snackBarService = locator<SnackbarService>();

  @override
  Future<List<GetClientsResponse>> getClientList() async {
    List<GetClientsResponse> clientsList = [];
    ParentApiResponse apiResponse = await apiService.getClientsList();

    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var list = apiResponse.response.data as List;
      list.forEach((element) {
        GetClientsResponse getClientsResponse =
            GetClientsResponse.fromMap(element);
        clientsList.add(getClientsResponse);
      });
    }

    return clientsList;
  }

  @override
  Future<DashboardTilesStatsResponse> getDashboardTilesStats(
      {@required String clientId}) async {
    DashboardTilesStatsResponse initialDashBoardStats =
        DashboardTilesStatsResponse(
            hubCount: 0,
            totalKm: 0,
            routeCount: 0,
            dueKm: 0,
            dueExpense: 0,
            totalExpense: 0);

    ParentApiResponse dashboardTilesData =
        await apiService.getDashboardTilesStats(clientId: clientId);

    if (filterResponse(dashboardTilesData, showSnackBar: false) != null) {
      initialDashBoardStats = DashboardTilesStatsResponse.fromJson(
          dashboardTilesData.response.data);
    }

    return initialDashBoardStats;
  }

  @override
  Future<List<FetchRoutesResponse>> getRoutes({String clientId}) async {
    List<FetchRoutesResponse> _routesList = [];
    ParentApiResponse routesListResponse =
        await apiService.getRoutesForClientId(clientId: clientId);

    if (filterResponse(routesListResponse, showSnackBar: false) != null) {
      if (routesListResponse.isNoDataFound()) {
        snackBarService.showSnackbar(message: routesListResponse.emptyResult);
      } else {
        List routesList = routesListResponse.response.data as List;
        routesList.forEach((element) {
          _routesList.add(FetchRoutesResponse.fromMap(element));
        });
      }
    }

    return _routesList;
  }

  @override
  Future<List<FetchHubsResponse>> getHubs({int routeId}) async {
    List<FetchHubsResponse> _hubsList = [];
    ParentApiResponse routesListResponse =
        await apiService.getHubsList(routeId: routeId);

    if (filterResponse(routesListResponse, showSnackBar: false) != null) {
      if (routesListResponse.isNoDataFound()) {
        snackBarService.showSnackbar(message: routesListResponse.emptyResult);
      } else {
        List routesList = routesListResponse.response.data as List;
        routesList.forEach((element) {
          _hubsList.add(FetchHubsResponse.fromMap(element));
        });
      }
    }

    return _hubsList;
  }

  @override
  Future<List<GetDistributorsResponse>> getDistributors(
      {@required String clientId}) async {
    List<GetDistributorsResponse> _responseList = [];
    ParentApiResponse response =
        await apiService.getDistributors(clientId: clientId);

    if (filterResponse(response, showSnackBar: false) != null) {
      var list = response.response.data as List;
      if (list.length > 0) {
        for (Map singleHub in list) {
          GetDistributorsResponse singleDistributorsResponse =
              GetDistributorsResponse.fromMap(singleHub);
          _responseList.add(singleDistributorsResponse);
        }
      }
    }
    return _responseList;
  }

  @override
  Future<List<ConsignmentTrackingStatusResponse>> getConsignmentTrackingStatus(
      {@required String clientId, @required TripStatus tripStatus}) async {
    List<ConsignmentTrackingStatusResponse> _responseList = [];
    ParentApiResponse response = await apiService.getConsignmentTrackingStatus(
        clientId: clientId, tripStatus: tripStatus);
    if (filterResponse(response, showSnackBar: false) != null) {
      var list = response.response.data as List;
      if (list.length > 0) {
        for (Map singleHub in list) {
          ConsignmentTrackingStatusResponse singleItemResponse =
              ConsignmentTrackingStatusResponse.fromMap(singleHub);
          _responseList.add(singleItemResponse);
        }
      }
    }
    return _responseList;
  }
}
