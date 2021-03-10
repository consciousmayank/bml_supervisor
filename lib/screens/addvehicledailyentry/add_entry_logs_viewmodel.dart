import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_arguments.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/daily_entry_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AddVehicleEntryViewModel extends GeneralisedBaseViewModel {
  DashBoardApisImpl _dashBoardApis = locator<DashBoardApisImpl>();
  DailyEntryApisImpl _dailyEntryApis = locator<DailyEntryApisImpl>();

  RoutesForSelectedClientAndDateResponse _selectedRoute;

  RoutesForSelectedClientAndDateResponse get selectedRoute => _selectedRoute;

  set selectedRoute(RoutesForSelectedClientAndDateResponse value) {
    _selectedRoute = value;
    if (value != null) getEntryLogForLastDate(value.vehicleId);
    notifyListeners();
  }

  List<RoutesForSelectedClientAndDateResponse> _routesList = [];

  List<RoutesForSelectedClientAndDateResponse> get routesList => _routesList;

  set routesList(List<RoutesForSelectedClientAndDateResponse> value) {
    _routesList = value;
    notifyListeners();
  }

  bool _startEntryEdited = false;

  bool get startEntryEdited => _startEntryEdited;

  set startEntryEdited(bool value) {
    _startEntryEdited = value;
    notifyListeners();
  }

  int _flagForSearch = 0; // [0-Search Via LastEntryDate, 1-Search Via Reg Num ]
//  int _flagForSearch;
  int get flagForSearch => _flagForSearch;

  set flagForSearch(int flagForSearch) {
    _flagForSearch = flagForSearch;
    notifyListeners();
  }

  DateTime _datePickerEntryDate;

  DateTime get datePickerEntryDate => _datePickerEntryDate;

  set datePickerEntryDate(DateTime value) {
    _datePickerEntryDate = value;
    notifyListeners();
  }

  // String _lastEntryDate = '';
  // String get lastEntryDate => _lastEntryDate;
  // set lastEntryDate(String lastEntryDate) {
  //   _lastEntryDate = lastEntryDate;
  //   notifyListeners();
  // }

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

  String _registrationNumber;
  List<SearchByRegNoResponse> searchResponse = [];

  SearchByRegNoResponse _selectedVehicle;

  SearchByRegNoResponse get selectedVehicle => _selectedVehicle;

  set selectedVehicle(SearchByRegNoResponse selectedVehicle) {
    _selectedVehicle = selectedVehicle;
    notifyListeners();
  }

  ApiResponse _entyLogSubmitResponse;

  ApiResponse get entyLogSubmitResponse => _entyLogSubmitResponse;

  set entyLogSubmitResponse(ApiResponse entyLogSubmitResponse) {
    _entyLogSubmitResponse = entyLogSubmitResponse;
    notifyListeners();
  }

  bool _isFuelEntryAdded = false;

  bool get isFuelEntryAdded => _isFuelEntryAdded;

  set isFuelEntryAdded(bool isFuelEntryAdded) {
    _isFuelEntryAdded = isFuelEntryAdded;
    notifyListeners();
  }

  int _undertakenTrips = 1;

  int get undertakenTrips => _undertakenTrips;

  set undertakenTrips(int undertakenTrips) {
    _undertakenTrips = undertakenTrips;
    notifyListeners();
  }

  DateTime _entryDate;

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime registrationDate) {
    _entryDate = registrationDate;
    notifyListeners();
  }

  bool _emptyDateSelector = false;

  bool get emptyDateSelector => _emptyDateSelector;

  set emptyDateSelector(bool emptyDateSelector) {
    _emptyDateSelector = emptyDateSelector;
    notifyListeners();
  }

  TimeOfDay _loginTime;
  TimeOfDay _logoutTime;

  TimeOfDay get logoutTime => _logoutTime;

  set logoutTime(TimeOfDay logoutTime) {
    _logoutTime = logoutTime;
  }

  TimeOfDay get loginTime => _loginTime;

  set loginTime(TimeOfDay loginTime) {
    _loginTime = loginTime;
  }

  EntryLog _vehicleLog;

  EntryLog get vehicleLog => _vehicleLog;

  set vehicleLog(EntryLog vehicleLog) {
    _vehicleLog = vehicleLog;
    notifyListeners();
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    List<GetClientsResponse> responseList =
        await _dashBoardApis.getClientList();
    this.clientsList = copyList(responseList);
    setBusy(false);
    notifyListeners();
  }

  void getEntryLogForLastDate(String registrationNumber) async {
    setBusy(true);
    _registrationNumber = registrationNumber;
    EntryLog entryLog = await _dailyEntryApis.getLatestDailyEntry(
        registrationNumber: registrationNumber);

    if (entryLog == null) {
      searchByRegistrationNumber(registrationNumber);
    } else {
      vehicleLog = entryLog;
      setAddEntryDate(vehicleLog.entryDate);
    }
    setBusy(false);
  }

  setAddEntryDate(String entryDate) {
    var dateAsList = entryDate.split('-');
    var reversedDateList = dateAsList.reversed;
    var joinedReversedDate = reversedDateList.join('-');
    DateTime time = DateTime.parse(joinedReversedDate);
    if (DateTime.now().difference(time).inDays == 0) {
      print('same date entry');
      print(datePickerEntryDate);
      datePickerEntryDate = DateTime.now();
    } else {
      print('not same date entry');
      print(time);
      datePickerEntryDate = time.add(Duration(days: 1));
      print(datePickerEntryDate);
    }
  }

  void searchByRegistrationNumber(String regNum) async {
    print('searchByRegistrationNumber - new api');
    setBusy(true);

    var entryLog = await apiService.searchByRegistrationNumber(regNum);

    if (entryLog is String) {
      snackBarService.showSnackbar(message: entryLog);
    } else if (entryLog.data['status'].toString() == 'failed') {
      setBusy(false);
      snackBarService.showSnackbar(message: "No Results found for \"$regNum\"");
    } else {
      SearchByRegNoResponse singleSearchResult =
          SearchByRegNoResponse.fromMap(entryLog.data);
      // print(singleSearchResult.)
      vehicleLog = EntryLog(
          clientId: null,
          vehicleId: null,
          entryDate: null,
          startReading: singleSearchResult.initReading,
          endReading: null,
          drivenKm: null,
          fuelLtr: null,
          fuelMeterReading: null,
          ratePerLtr: null,
          amountPaid: null,
          trips: null,
          loginTime: null,
          logoutTime: null,
          remarks: null,
          startReadingGround: null,
          drivenKmGround: null,
          status: null,
          routeId: null);
      flagForSearch = 1;

      // vehicleLog = EntryLog.fromMap(entryLog.data);
      setBusy(false);
    }
  }

  submitVehicleEntry(EntryLog entryLogRequest) async {
    setBusy(true);
    bool apiResponse = await _dailyEntryApis.submitVehicleEntry(
        entryLogRequest: entryLogRequest);

    if (apiResponse) {
      navigationService.back();
    } else {
      selectedVehicle = null;
      entryDate = null;
      vehicleLog = null;
      undertakenTrips = 1;
      isFuelEntryAdded = false;
    }
    setBusy(false);
  }

  void takeToAddEntry2PointOFormViewPage() {
    if (selectedVehicle == null) {
      print('selectedvehicle is null- search via last entry');
    }
    print('flag before sending' + flagForSearch.toString());
    navigationService
        .navigateTo(
      addEntry2PointOFormViewPageRoute,
      arguments: AddEntryArguments(
          entryDate: entryDate,
          vehicleLog: vehicleLog,
          flagForSearch: flagForSearch,
          registrationNumber: _registrationNumber,
          selectedClientId: selectedClient.clientId,
          selectedRoute: selectedRoute),
      // arguments: {
      //   'entryDateArg': entryDate,
      //   'vehicleLogArg': vehicleLog,
      //   'regNumArg': _registrationNumber,
      //   'flagForSearchArg': flagForSearch,
      //   'selectedClientId': selectedClient.id,
      //   '': ''
      // },
    )
        .then((value) {
      // _registrationNumber = '';
      flagForSearch = 0;
      selectedClient = null;
      vehicleLog = null;
    });
  }

  getRoutesForSelectedClientAndDate(String clientId) async {
    setBusy(true);
    routesList = [];
    List<RoutesForSelectedClientAndDateResponse> response =
        await _dailyEntryApis.getRoutesForSelectedClientAndDate(
      clientId: clientId,
      date: getDateString(entryDate),
    );
    this.routesList = copyList(response);
    setBusy(false);
    notifyListeners();
  }
}
