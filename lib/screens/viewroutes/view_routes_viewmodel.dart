import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/viewhubs/view_routes_arguments.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class ViewRoutesViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashboardApi = locator<DashBoardApisImpl>();
  GetClientsResponse _selectedClient;

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
    notifyListeners();
  }

  getClientIds() async {
    setBusy(true);
    var res = await _dashboardApi.getClientList();
    _clientsList = copyList(res);
    notifyListeners();
    setBusy(false);
  }

  takeToHubsView({FetchRoutesResponse clickedRoute}) {
    navigationService.navigateTo(hubsViewPageRoute,
        arguments: ViewRoutesArguments(
          clickedRoute: clickedRoute,
        ));
  }
}
