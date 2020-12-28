import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:dio/dio.dart';

class ConsignmentAllotmentViewModel extends GeneralisedBaseViewModel {
  GetRoutesResponse _selectedRoute;
  List<GetRoutesResponse> _routesList = [];

  List<GetRoutesResponse> get routesList => _routesList;

  set routesList(List<GetRoutesResponse> value) {
    _routesList = value;
  }

  GetRoutesResponse get selectedRoute => _selectedRoute;

  set selectedRoute(GetRoutesResponse selectedRoute) {
    _selectedRoute = selectedRoute;
    notifyListeners();
  }

  getRoutes() async {
    setBusy(true);
    var response = await apiService.getRoutesForClient();

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      var routesList = apiResponse.data as List;

      routesList.forEach((element) {
        GetRoutesResponse getRoutesResponse =
            GetRoutesResponse.fromMap(element);
        getRoutesResponse.hub.sort((hub1, hub2) {
          return hub1.sequence.compareTo(hub2.sequence);
        });

        this.routesList.add(getRoutesResponse);
      });
    }
    this.routesList.forEach((element) {});
    setBusy(false);
    notifyListeners();
  }
}
