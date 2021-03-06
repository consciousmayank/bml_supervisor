import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/delivery_route/add/pick_hubs/pick_hubs_arguments.dart';

// import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AddRoutesViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  List<GetDistributorsResponse> newHubsList = [];

  // List<GetDistributorsResponse> get newHubsList => _newHubsList;
  //
  // set newHubsList(List<GetDistributorsResponse> value) {
  //   _newHubsList = value;
  //   notifyListeners();
  // }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  List<GetDistributorsResponse> get hubsList => _hubsList;

  set hubsList(List<GetDistributorsResponse> value) {
    _hubsList = value;
    notifyListeners();
  }

  List<GetDistributorsResponse> _hubsList = [];

  // List<CitiesResponse> _cityList = [];
  // List<CitiesResponse> get cityList => _cityList;
  // set cityList(List<CitiesResponse> value) {
  //   _cityList = value;
  //   notifyListeners();
  // }
  //
  // CitiesResponse _selectedCity;
  //
  // CitiesResponse get selectedCity => _selectedCity;
  //
  // set selectedCity(CitiesResponse value) {
  //   _selectedCity = value;
  //   notifyListeners();
  //   // getPinCodeState();
  // }

  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    List<GetClientsResponse> responseList =
        await _dashBoardApis.getClientList(pageNumber: 1);
    this.clientsList = copyList(responseList);

    setBusy(false);
    notifyListeners();
  }

  Future getHubsForSelectedClient(
      {@required GetClientsResponse selectedClient}) async {
    hubsList.clear();
    setBusy(true);
    notifyListeners();
    var response =
        await _dashBoardApis.getDistributors(clientId: selectedClient.clientId);
    hubsList = copyList(response);
    notifyListeners();
    setBusy(false);
  }

  void takeToPickHubsPage({String routeTitle, String remarks}) {
    navigationService.navigateTo(pickHubsPageRoute,
        arguments: PickHubsArguments(
          hubsList: hubsList,
          routeTitle: routeTitle,
          remarks: remarks,
        ));
  }

// getCities() async {
//   var citiesList = await _driverApis.getCities();
//   cityList = copyList(citiesList);
// }
}
