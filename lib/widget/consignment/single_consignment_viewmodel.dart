import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:dio/dio.dart';

class SingleConsignmentViewModel extends GeneralisedBaseViewModel {
  List<FetchHubsResponse> _hubsList = [];

  List<FetchHubsResponse> get hubsList => _hubsList;

  set hubsList(List<FetchHubsResponse> value) {
    _hubsList = value;
  }

  getHubs(FetchRoutesResponse selectedRoute) async {
    var hubsResponse = await apiService.getHubs(routeId: selectedRoute.id);

    if (hubsResponse is String) {
      snackBarService.showSnackbar(message: hubsResponse);
    } else {
      Response apiResponse = hubsResponse;
      List routesList = apiResponse.data as List;
      routesList.forEach((element) {
        _hubsList.add(FetchHubsResponse.fromMap(element));
      });
    }
    setBusy(false);
    notifyListeners();
  }
}
