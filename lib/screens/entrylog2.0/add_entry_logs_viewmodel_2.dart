import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEntryLogsViewModel2PointO extends GeneralisedBaseViewModel {
  int _flagForSearch = 0; // [0-Search Via LastEntryDate, 1-Search Via Reg Num ]
//  int _flagForSearch;
  int get flagForSearch => _flagForSearch;
  set flagForSearch(int flagForSearch) {
    _flagForSearch = flagForSearch;
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

  void getEntryLogForLastDate(String registrationNumber) async {
    setBusy(true);
    _registrationNumber = registrationNumber;
    var entryLog = await apiService.getEntryLogForDate(registrationNumber,
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toLowerCase());
    if (entryLog is String) {
      snackBarService.showSnackbar(message: entryLog);
    } else if (entryLog.data['status'].toString() == 'failed') {
      search(registrationNumber);
    } else {
      vehicleLog = EntryLog.fromMap(entryLog.data);
      setBusy(false);
      takeToAddEntry2PointOFormViewPage();
    }
    setBusy(false);
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
        if (list.length > 0) {
          for (Map singleItem in list) {
            SearchByRegNoResponse singleSearchResult =
                SearchByRegNoResponse.fromMap(singleItem);
            searchResponse.add(singleSearchResult);
          }

          setBusy(false);
          vehicleLog = EntryLog(
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
          print('making flag 1');
          flagForSearch = 1;
          takeToAddEntry2PointOFormViewPage();
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
    navigationService.navigateTo(
      addEntry2PointOFormViewPageRoute,
      arguments: {
        'entryDateArg': entryDate,
        'vehicleLogArg': vehicleLog,
        'regNumArg': _registrationNumber,
        'flagForSearchArg': flagForSearch,
      },
    ).then((value) {
      _registrationNumber = '';
      flagForSearch = 0;
    });

    // if (searchResponse.isEmpty) {
    //   // send entry date and vehicle log
    //   print('sending vehicle log');
    //   print('before sending, login time' + vehicleLog.loginTime);
    //   print('before sending - searchResponse: ' + searchResponse.toString());

    //   navigationService.navigateTo(
    //     addEntry2PointOFormViewPageRoute,
    //     arguments: {
    //       'entryDateArg': entryDate,
    //       'vehicleLogArg': vehicleLog,
    //       'regNumArg': _registrationNumber,
    //     },
    //   ).then((value) => _registrationNumber = '');
    // } else {
    //   // send entry date and searchResponse
    //   print('sending searchResponse');
    //   // print('send entry date and search response');;
    //   print('****before sending searchResponse data: ' +
    //       searchResponse.toString());
    //   print('before sending - search response length ' +
    //       searchResponse.length.toString());

    //   navigationService
    //       .navigateTo(addEntry2PointOFormViewPageRoute, arguments: {
    //     'entryDateArg': entryDate,
    //     'searchResponseArg': searchResponse,
    //     'regNumArg': _registrationNumber,
    //   }).then((_) {
    //     searchResponse.clear();
    //     _registrationNumber = '';
    //   });
    //   // searchResponse.clear();
    // }
  }
}
