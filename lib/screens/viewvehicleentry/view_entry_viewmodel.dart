import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/view_entry_request.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/daily_entry_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class ViewVehicleEntryViewModel extends GeneralisedBaseViewModel {
  DailyEntryApis _dailyEntryApis = locator<DailyEntryApisImpl>();
  DashBoardApis _dashBoardApi = locator<DashBoardApisImpl>();
  int _totalKm = 0;

  int _totalKmGround = 0;

  int _kmDifference = 0;

  double _totalFuelInLtr = 0.0;

  double _avgPerLitre = 0.0;

  double _totalFuelAmt = 0.0;

  GetClientsResponse _selectedClient;
  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<ViewEntryResponse> vehicleEntrySearchResponseList = [];

  List<SearchByRegNoResponse> searchResponse = [];
  String _selectedDuration = "";
  String get selectedDuration => _selectedDuration;

  set selectedDuration(String selectedDuration) {
    _selectedDuration = selectedDuration;
    notifyListeners();
  }

  String _selectedRegistrationNumber = "";
  String get selectedRegistrationNumber => _selectedRegistrationNumber;

  set selectedRegistrationNumber(String selectedRegistrationNumber) {
    _selectedRegistrationNumber = selectedRegistrationNumber;
    notifyListeners();
  }

  SearchByRegNoResponse _selectedVehicle;
  SearchByRegNoResponse get selectedVehicle => _selectedVehicle;
  set selectedVehicle(SearchByRegNoResponse selectedVehicle) {
    _selectedVehicle = selectedVehicle;
    notifyListeners();
  }

  ViewEntryResponse _vehicleLog; // _vehicleLog -> _viewEntryResponse

  ViewEntryResponse get vehicleLog => _vehicleLog;
  set vehicleLog(ViewEntryResponse vehicleLog) {
    _vehicleLog = vehicleLog;
    notifyListeners();
  }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  int getSelectedDurationValue(String selectedDuration) {
    switch (selectedDuration) {
      case 'THIS MONTH':
        return 1;
      case 'LAST MONTH':
        return 2;
      default:
        return 1;
    }
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    // call client api
    // get the data as list
    // add Book my loading at 0
    // pupulate the clients dropdown
    List<GetClientsResponse> response = await _dashBoardApi.getClientList();
    _clientsList = copyList(response);
    setBusy(false);
    notifyListeners();
  }

  void vehicleEntrySearch(
      {String regNum, String selectedDuration, String clientId}) async {
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    vehicleEntrySearchResponseList.clear();
    _vehicleLog = null;
    notifyListeners();
    setBusy(true);

    final List<ViewEntryResponse> res = await _dailyEntryApis.getDailyEntries(
      viewEntryRequest: ViewEntryRequest(
        clientId: clientId ?? "",
        period: selectedDurationValue.toString(),
        vehicleId: regNum ?? "",
      ),
    );

    vehicleEntrySearchResponseList = copyList(res);
    vehicleEntrySearchResponseList.forEach((element) {
      _totalKmGround += element.drivenKmGround;
      _totalFuelInLtr += element.fuelLtr;
      _totalKm += element.drivenKm;
      _totalFuelAmt += element.amountPaid;
    });
    if (!(_totalKm == 0 && _totalKmGround == 0)) {
      _kmDifference = _totalKmGround - _totalKm;
    }
    if ((_totalKm != 0 && _totalFuelInLtr != 0)) {
      _avgPerLitre = _totalKm / _totalFuelInLtr;
    }
    takeToViewEntryDetailedPage2Point0();

    notifyListeners();
    setBusy(false);
  }

  void takeToViewEntryDetailedPage2Point0() {
    print('taking to detailed page 2.0');
    navigationService
        .navigateTo(viewEntryDetailedView2PointOPageRoute, arguments: {
      'totalKm': _totalKm,
      'kmDifference': _kmDifference.abs(),
      'totalFuelInLtr': _totalFuelInLtr,
      'avgPerLitre': _avgPerLitre,
      'totalFuelAmt': _totalFuelAmt,
      'vehicleEntrySearchResponseList': vehicleEntrySearchResponseList,
      'selectedClient':
          selectedClient == null ? 'All Clients' : selectedClient.clientId,
    });
    _totalFuelAmt = 0;
    _kmDifference = 0;
    _totalFuelInLtr = 0;
    _avgPerLitre = 0;
    _totalKm = 0;
    _totalKmGround = 0;
  }
}
