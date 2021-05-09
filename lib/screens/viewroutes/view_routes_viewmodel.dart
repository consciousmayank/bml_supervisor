import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/viewhubs/view_routes_arguments.dart';

class ViewRoutesViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashboardApi = locator<DashBoardApisImpl>();
  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
    notifyListeners();
  }

  getClientIds() async {
    setBusy(true);
    selectedClient = preferences.getSelectedClient();
    setBusy(false);
  }

  takeToHubsView({FetchRoutesResponse clickedRoute}) {
    navigationService.navigateTo(hubsViewPageRoute,
        arguments: ViewRoutesArguments(
          clickedRoute: clickedRoute,
        ));
  }
}
