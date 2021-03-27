import '../../app_level/generalised_base_view_model.dart';
import '../../app_level/locator.dart';
import '../../models/cities_response.dart';
import '../../models/secured_get_clients_response.dart';
import '../../utils/widget_utils.dart';
import '../adddriver/driver_apis.dart';
import '../dashboard/dashboard_apis.dart';

class AddRoutesViewModel extends GeneralisedBaseViewModel{
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  DriverApis _driverApis = locator<DriverApisImpl>();
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

  List<CitiesResponse> _cityList = [];
  List<CitiesResponse> get cityList => _cityList;
  set cityList(List<CitiesResponse> value) {
    _cityList = value;
    notifyListeners();
  }

  CitiesResponse _selectedCity;

  CitiesResponse get selectedCity => _selectedCity;

  set selectedCity(CitiesResponse value) {
    _selectedCity = value;
    notifyListeners();
    // getPinCodeState();
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

  getCities() async {
    var citiesList = await _driverApis.getCities();
    cityList = copyList(citiesList);
  }
}