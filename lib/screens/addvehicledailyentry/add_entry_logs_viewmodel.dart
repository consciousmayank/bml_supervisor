import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddVehicleEntryViewModel extends GeneralisedBaseViewModel {
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
    // call client api
    // get the data as list
    // add Book my loading at 0
    // pupulate the clients dropdown
    var response = await apiService.getClientsList();

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      var clientsList = apiResponse.data as List;

      clientsList.forEach((element) {
        GetClientsResponse getClientsResponse =
            GetClientsResponse.fromMap(element);
        this.clientsList.add(getClientsResponse);
      });
      this.clientsList.insert(
          0,
          GetClientsResponse(
            id: 0,
            title: 'Book My Loading',
          ));
    }

    setBusy(false);
    notifyListeners();
    print('Number of clients: ${clientsList.length}');
    clientsList.forEach((element) {
      print(element.id);
      print(element.title);
    });
    // print(clientsList);
  }

  void getEntryLogForLastDate(String registrationNumber) async {
    setBusy(true);
    _registrationNumber = registrationNumber;
    var entryLog = await apiService.getEntryLogForDate(registrationNumber,
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toLowerCase());
    if (entryLog is String) {
      snackBarService.showSnackbar(message: entryLog);
    } else if (entryLog.data['status'].toString() == 'failed') {
      searchByRegistrationNumber(registrationNumber);
    } else {
      print('search via last entry');
      vehicleLog = EntryLog.fromMap(entryLog.data);
      //contains date
      print('last entry date: ${vehicleLog.entryDate}');
      setAddEntryDate(vehicleLog.entryDate);
      // setAddEntryDate('22-01-2021');
      setBusy(false);
    }
  }

  setAddEntryDate(String entryDate) {
    var dateAsList = entryDate.split('-');
    var reversedDateList = dateAsList.reversed;
    var joinedReversedDate = reversedDateList.join('-');
    DateTime time = DateTime.parse(joinedReversedDate);
    if (DateTime.now().difference(time).inDays==0) {
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
          drivenKmGround: null);
      flagForSearch = 1;

      // vehicleLog = EntryLog.fromMap(entryLog.data);
      setBusy(false);
    }
  }

  void search(String text) async {
    searchResponse.clear();
    selectedVehicle = null;
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.search(registrationNumber: text);
      if (res.statusCode == 200) {
        var list = res.data as List;
        if (list.length == 1) {
          //for (Map singleItem in list) {
          SearchByRegNoResponse singleSearchResult =
              SearchByRegNoResponse.fromMap(list.first);
          searchResponse.add(singleSearchResult);
          //}

          setBusy(false);
          vehicleLog = EntryLog(
              clientId: null,
              vehicleId: null,
              entryDate: null,
              startReading: searchResponse.first.initReading,
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
              drivenKmGround: null);
          print('search via reg num');
          print('making flag 1');
          flagForSearch = 1;
          print('start reading: ${vehicleLog.startReading}');
          // takeToAddEntry2PointOFormViewPage();
        } else if (list.length > 1) {
          snackBarService.showSnackbar(
              message: "Please enter complete Registration Number");
        } else {
          snackBarService.showSnackbar(
              message: "No Results found for \"$text\"");
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    setBusy(false);
  }

  submitVehicleEntry(EntryLog entryLogRequest) async {
    setBusy(true);
    print('submit vehicle entry method');
    try {
      var response = await apiService.submitVehicleEntry(entryLogRequest);

      if (response is String) {
        snackBarService.showSnackbar(message: response);
      } else {
        Response actualResponse = response;

        if (actualResponse.statusCode == 200) {
          entyLogSubmitResponse = ApiResponse.fromMap(actualResponse.data);
        }

        if (entyLogSubmitResponse.status == "success") {
          var response = await dialogService.showConfirmationDialog(
            title: 'Congratulations...',
            description: entyLogSubmitResponse.message.split("!")[0],
          );

          if (response == null || response.confirmed) {
            navigationService.back();
          }
        } else {
          var response = await dialogService.showConfirmationDialog(
            title: 'Oops...',
            description: entyLogSubmitResponse.message,
          );

          if (response == null || response.confirmed) {
            selectedVehicle = null;
            entryDate = null;
            vehicleLog = null;
            undertakenTrips = 1;
            isFuelEntryAdded = false;
          }
        }
      }
    } catch (e) {
      snackBarService.showSnackbar(
        message: e.toString(),
      );
      setBusy(false);
    }
    setBusy(false);
  }

  void takeToAddEntry2PointOFormViewPage() {
    if (selectedVehicle == null) {
      print('selectedvehicle is null- search via last entry');
    }
    print('flag before sending' + flagForSearch.toString());
    print('navigation client id' + selectedClient.id.toString());
    navigationService.navigateTo(
      addEntry2PointOFormViewPageRoute,
      arguments: {
        'entryDateArg': entryDate,
        'vehicleLogArg': vehicleLog,
        'regNumArg': _registrationNumber,
        'flagForSearchArg': flagForSearch,
        'selectedClientId': selectedClient.id,
      },
    ).then((value) {
      // _registrationNumber = '';
      flagForSearch = 0;
      selectedClient = null;
      vehicleLog = null;
    });
  }
}
