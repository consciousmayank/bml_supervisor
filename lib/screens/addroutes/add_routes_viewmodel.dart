import '../../app_level/generalised_base_view_model.dart';
import '../../app_level/locator.dart';
import '../../models/secured_get_clients_response.dart';
import '../../utils/widget_utils.dart';
import '../dashboard/dashboard_apis.dart';

class AddRoutesViewModel extends GeneralisedBaseViewModel{
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }
  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }


  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    List<GetClientsResponse> responseList =
    await _dashBoardApis.getClientList();
    this.clientsList = copyList(responseList);

    setBusy(false);
    notifyListeners();
  }
}