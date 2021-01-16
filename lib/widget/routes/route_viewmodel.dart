import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:dio/dio.dart';

class RoutesViewModel extends GeneralisedBaseViewModel {
  List<FetchRoutesResponse> _routesList = [];

  List<FetchRoutesResponse> get routesList => _routesList;

  set routesList(List<FetchRoutesResponse> value) {
    _routesList = value;
  }

  Future getRoutesForClient(GetClientsResponse selectedClient) async {
    setBusy(true);
    var routesApiResponse =
        await apiService.getRoutesForClientId(selectedClient: selectedClient);
    if (routesApiResponse is String) {
      snackBarService.showSnackbar(message: routesApiResponse);
    } else {
      Response apiResponse = routesApiResponse;
      List routesList = apiResponse.data as List;
      routesList.forEach((element) {
        _routesList.add(FetchRoutesResponse.fromMap(element));
      });
    }
    setBusy(false);
    notifyListeners();
  }
}
