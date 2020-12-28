import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:dio/dio.dart';

class HubViewModel extends GeneralisedBaseViewModel {
  HubResponse _hubResponse;

  HubResponse get hubResponse => _hubResponse;

  set hubResponse(HubResponse value) {
    _hubResponse = value;
    notifyListeners();
  }

  getHubData(Hub hub) async {
    setBusy(true);
    var response = await apiService.getHubData(hub.hub);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      hubResponse = HubResponse.fromMap(apiResponse.data);
    }
    setBusy(false);
  }
}
