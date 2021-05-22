import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class RoutesViewModel extends GeneralisedBaseViewModel {
  List<FetchRoutesResponse> _routesList = [];
  DashBoardApisImpl _dashBoardApis = locator<DashBoardApisImpl>();
  List<FetchRoutesResponse> get routesList => _routesList;

  set routesList(List<FetchRoutesResponse> value) {
    _routesList = value;
  }

  Future getRoutesForClient(int selectedClient) async {
    setBusy(true);
    setBusy(true);
    routesList = [];
    List<FetchRoutesResponse> response =
        await _dashBoardApis.getRoutes(clientId: selectedClient);
    this.routesList = copyList(response);
    setBusy(false);
    notifyListeners();
  }

  takeToViewRoutesPage() {
    navigationService.navigateTo(viewRoutesPageRoute);
  }
}
