import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/RoutesForSelectedClientAndDateResponse.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';

class ViewConsignmentViewModel extends GeneralisedBaseViewModel {
  SearchByRegNoResponse validatedRegistrationNumber;
  DateTime _entryDate;
  GetClientsResponse _selectedClient;
  List<GetRoutesResponse> _routesList = [];

  GetRoutesResponse _selectedRoute;

  GetRoutesResponse get selectedRoute => _selectedRoute;

  set selectedRoute(GetRoutesResponse value) {
    _selectedRoute = value;
  }

  List<GetRoutesResponse> get routesList => _routesList;

  set routesList(List<GetRoutesResponse> value) {
    _routesList = value;
  }

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
  }

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime value) {
    _entryDate = value;
  }

  List<FetchHubsResponse> _hubsList = [];

  List<GetClientsResponse> _clientsList = [];

  getClientIds() async {
    var clientIdsResponse = await apiService.getClientsList();
    if (clientIdsResponse is String) {
      snackBarService.showSnackbar(message: clientIdsResponse);
    } else {
      Response apiResponse = clientIdsResponse;
      var clientsList = apiResponse.data as List;

      clientsList.forEach((element) {
        GetClientsResponse getClientsResponse =
            GetClientsResponse.fromMap(element);
        _clientsList.add(getClientsResponse);
      });
      notifyListeners();
    }
  }

  getRoutes(int clientId) async {
    setBusy(true);
    routesList = [];
    var response = await apiService.getRoutesForSelectedClientAndDate(
      clientId: clientId,
      date: getDateString(entryDate),
    );

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      var routesList = apiResponse.data as List;

      routesList.forEach((element) {
        RoutesForSelectedClientAndDateResponse routes =
            RoutesForSelectedClientAndDateResponse.fromMap(element);

        this.routesList.add(GetRoutesResponse(
              id: routes.routeId,
              title: routes.routeName,
            ));
      });
    }
    setBusy(false);
    notifyListeners();
  }

  List<FetchHubsResponse> get hubsList => _hubsList;

  set hubsList(List<FetchHubsResponse> value) {
    _hubsList = value;
  }

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
  }

  void getConsignments() async {
    setBusy(true);
    routesList = [];
    var response = await apiService.getConsignment(
      clientId: selectedClient.id,
      entryDate: getDateString(entryDate),
      routeId: selectedRoute.id,
    );

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      var routesList = apiResponse.data as List;

      routesList.forEach((element) {
        RoutesForSelectedClientAndDateResponse routes =
            RoutesForSelectedClientAndDateResponse.fromMap(element);

        this.routesList.add(GetRoutesResponse(
              id: routes.routeId,
              title: routes.routeName,
            ));
      });
    }
    setBusy(false);
    notifyListeners();
  }
}
