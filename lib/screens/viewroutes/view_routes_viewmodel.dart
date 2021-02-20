import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';

class ViewRoutesViewModel extends GeneralisedBaseViewModel {
  FetchRoutesResponse _selectedRoute;
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

  FetchRoutesResponse get selectedRoute => _selectedRoute;

  set selectedRoute(FetchRoutesResponse value) {
    _selectedRoute = value;
    notifyListeners();
  }

  getClientIds() async {
    var clientIdsResponse = await apiService.getClientsList();
  }
}
