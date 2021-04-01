import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
// import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/adddriver/driver_apis.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_arguments.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AddRoutesViewModel extends GeneralisedBaseViewModel {
  bool _isReturnList = false;

  int _currentStep = 0;

  int get currentStep => _currentStep;

  set currentStep(int value) {
    _currentStep = value;
    print('Current Step Value :: $value');
    notifyListeners();
  }

  List<GetDistributorsResponse> _selectedHubsList = [];
  List<GetDistributorsResponse> _selectedReturningHubsList = [];

  bool get isReturnList => _isReturnList;

  set isReturnList(bool value) {
    notifyListeners();
    _isReturnList = value;
  }

  List<GetDistributorsResponse> get selectedHubsList => _selectedHubsList;

  set selectedHubsList(List<GetDistributorsResponse> value) {
    _selectedHubsList = value;
    notifyListeners();
  }

  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  DriverApis _driverApis = locator<DriverApisImpl>();
  List<GetDistributorsResponse> newHubsList = [];

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<GetDistributorsResponse> get hubsList => _hubsList;

  set hubsList(List<GetDistributorsResponse> value) {
    _hubsList = value;
    notifyListeners();
  }

  List<GetDistributorsResponse> _hubsList = [];

  getClients() async {
    setBusy(true);
    selectedClient = MyPreferences().getSelectedClient();
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

  void takeToPickHubsPage() {
    navigationService
        .navigateTo(pickHubsPageRoute,
            arguments: PickHubsArguments(hubsList: hubsList))
        .then((value) {
      if (value != null && value is List<GetDistributorsResponse>) {
        newHubsList = value;
        notifyListeners();
      }
    });
  }

  List<String> getHubNameForAutoComplete(
      List<GetDistributorsResponse> hubsList) {
    List<String> hubNames = [];
    hubsList.forEach((element) {
      hubNames.add(element.title);
    });
    return hubNames;
  }

  List<GetDistributorsResponse> get selectedReturningHubsList =>
      _selectedReturningHubsList;

  set selectedReturningHubsList(List<GetDistributorsResponse> value) {
    _selectedReturningHubsList = value;
  }

  void submitRoute({@required String title, @required String remarks}) {
    CreateRouteRequest request = CreateRouteRequest(
        title: title,
        remarks: remarks,
        srcLocation: selectedHubsList.first.id,
        dstLocation: selectedHubsList.last.id,
        clientId: MyPreferences().getSelectedClient().clientId,
        hubs: getHubsList());

    print('Request is ${request.toJson()}');
  }

  List<Hub> getHubsList() {
    List<Hub> listOfHubsToBeAdded = [];

    listOfHubsToBeAdded.addAll(buildHubList(hubsList: selectedHubsList));

    if (selectedReturningHubsList.length > 0) {
      listOfHubsToBeAdded.addAll(buildHubList(
          hubsList: selectedReturningHubsList, isReturningHubsList: true));
    }
    return listOfHubsToBeAdded;
  }

  String getProperFlag(int index) {
    if (index == (selectedHubsList.length - 1)) {
      return 'D';
    } else {
      return 'S';
    }
  }

  List<Hub> buildHubList(
      {@required List<GetDistributorsResponse> hubsList,
      bool isReturningHubsList = false}) {
    List<Hub> listOfHubsToBeAdded = [];
    for (var singleSelectedHub in hubsList) {
      listOfHubsToBeAdded.add(
        Hub(
          hub: singleSelectedHub.id,
          kms: double.parse(singleSelectedHub.kiloMeters.toString()),
          flag: isReturningHubsList
              ? 'R'
              : getProperFlag(hubsList.indexOf(singleSelectedHub)),
          sequence: isReturningHubsList
              ? (hubsList.indexOf(singleSelectedHub) +
                  selectedHubsList.length +
                  1)
              : (hubsList.indexOf(singleSelectedHub) + 1),
        ),
      );
    }

    return listOfHubsToBeAdded;
  }

  void createReturningList() {
    selectedReturningHubsList = copyList(selectedHubsList);

    selectedReturningHubsList = List.from(selectedReturningHubsList.reversed);
    selectedReturningHubsList.removeAt(0);
  }

// getCities() async {
//   var citiesList = await _driverApis.getCities();
//   cityList = copyList(citiesList);
// }
}
