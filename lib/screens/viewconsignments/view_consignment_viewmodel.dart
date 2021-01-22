import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/consignment_details.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';

class ViewConsignmentViewModel extends GeneralisedBaseViewModel {
  SearchByRegNoResponse validatedRegistrationNumber;
  DateTime _entryDate;
  GetClientsResponse _selectedClient;
  List<RoutesForSelectedClientAndDateResponse> _routesList = [];
  List<ConsignmentDetailsResponse> _hubList = [];

  List<ConsignmentDetailsResponse> get hubList => _hubList;

  set hubList(List<ConsignmentDetailsResponse> value) {
    _hubList = value;
  }

  RoutesForSelectedClientAndDateResponse _selectedRoute;

  RoutesForSelectedClientAndDateResponse get selectedRoute => _selectedRoute;

  set selectedRoute(RoutesForSelectedClientAndDateResponse value) {
    _selectedRoute = value;
    notifyListeners();
  }

  List<RoutesForSelectedClientAndDateResponse> get routesList => _routesList;

  set routesList(List<RoutesForSelectedClientAndDateResponse> value) {
    _routesList = value;
  }

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
  }

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime value) {
    _entryDate = value;
    notifyListeners();
  }

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
    hubList = [];
    var response = await apiService.getRoutesForSelectedClientAndDate(
      clientId: clientId,
      date: getDateString(entryDate),
    );

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;

      try {
        var routesList = apiResponse.data as List;

        routesList.forEach((element) {
          RoutesForSelectedClientAndDateResponse routes =
              RoutesForSelectedClientAndDateResponse.fromMap(element);

          this.routesList.add(routes);
        });
      } catch (e) {
        snackBarService.showSnackbar(message: apiResponse.data['message']);
      }
    }
    setBusy(false);
    notifyListeners();
  }

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
  }

  void getConsignments() async {
    setBusy(true);
    hubList = [];
    var response = await apiService.getConsignmentsList(
      clientId: selectedClient.id,
      entryDate: getDateString(entryDate),
      routeId: selectedRoute.routeId,
    );

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      try {
        var hubsList = apiResponse.data as List;

        hubsList.forEach((element) {
          ConsignmentDetailsResponse singleHub =
              ConsignmentDetailsResponse.fromMap(element);

          this._hubList.add(singleHub);
        });
      } catch (e) {
        snackBarService.showSnackbar(message: apiResponse.data['message']);
      }
    }
    setBusy(false);
    notifyListeners();
  }
}
