import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/delivery_route/list/delivery_hubs/view_routes_arguments.dart';

class ViewRoutesViewModel extends GeneralisedBaseViewModel {
  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
    notifyListeners();
  }

  getClientIds() async {
    setBusy(true);
    selectedClient = MyPreferences().getSelectedClient();
    setBusy(false);
  }

  takeToHubsView({FetchRoutesResponse clickedRoute}) {
    navigationService.navigateTo(hubsViewPageRoute,
        arguments: ViewRoutesArguments(
          clickedRoute: clickedRoute,
        ));
  }
}
