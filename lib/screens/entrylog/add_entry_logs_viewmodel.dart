import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryLogsViewModel extends GeneralisedBaseViewModel {
  int _undertakenTrips = 1;

  int get undertakenTrips => _undertakenTrips;

  set undertakenTrips(int undertakenTrips) {
    _undertakenTrips = undertakenTrips;
    notifyListeners();
  }

  ApiResponse _entyLogSubmitResponse;

  ApiResponse get entyLogSubmitResponse => _entyLogSubmitResponse;

  set entyLogSubmitResponse(ApiResponse entyLogSubmitResponse) {
    _entyLogSubmitResponse = entyLogSubmitResponse;
    notifyListeners();
  }

  DateTime _entryDate;
  EntryLog _vehicleLog;

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

  bool _isFuelEntryAdded = false;

  bool get isFuelEntryAdded => _isFuelEntryAdded;

  set isFuelEntryAdded(bool isFuelEntryAdded) {
    _isFuelEntryAdded = isFuelEntryAdded;
    notifyListeners();
  }

  bool _emptyDateSelector = false;

  bool get emptyDateSelector => _emptyDateSelector;

  set emptyDateSelector(bool emptyDateSelector) {
    _emptyDateSelector = emptyDateSelector;
  }

  EntryLog get vehicleLog => _vehicleLog;

  set vehicleLog(EntryLog vehicleLog) {
    _vehicleLog = vehicleLog;
    notifyListeners();
  }

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime registrationDate) {
    _entryDate = registrationDate;
    notifyListeners();
  }

  SearchByRegNoResponse _selectedSearchVehicle;

  SearchByRegNoResponse get selectedSearchVehicle => _selectedSearchVehicle;

  set selectedSearchVehicle(SearchByRegNoResponse selectedSearchVehicle) {
    _selectedSearchVehicle = selectedSearchVehicle;
    notifyListeners();
  }

  void takeToSearch() async {
    selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  }

  void getEntryForSelectedDate() async {
    setBusy(true);
    var entryLog = await apiService.getEntryLogForDate(
        selectedSearchVehicle.registrationNumber,
        DateFormat('dd-MM-yyyy').format(entryDate).toLowerCase());

    if (entryLog is String) {
      snackBarService.showSnackbar(message: entryLog);
    } else {
      vehicleLog = EntryLog.fromMap(entryLog.data);
      if (vehicleLog.failed != null) {
        vehicleLog = vehicleLog.copyWith(
            startReading: selectedSearchVehicle.initReading.toDouble());
      }
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
            selectedSearchVehicle = null;
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
}
