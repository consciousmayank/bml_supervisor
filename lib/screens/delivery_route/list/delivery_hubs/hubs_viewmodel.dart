import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class HubsViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  List<FetchHubsResponse> _hubsList = [];

  List<FetchHubsResponse> get hubsList => _hubsList;

  set hubsList(List<FetchHubsResponse> value) {
    _hubsList = value;
  }

  getHubs(FetchRoutesResponse selectedRoute) async {
    setBusy(true);
    var apiResponse =
        await _dashBoardApis.getHubs(routeId: selectedRoute.routeId);
    _hubsList = copyList(apiResponse);
    notifyListeners();
    setBusy(false);
  }
}
