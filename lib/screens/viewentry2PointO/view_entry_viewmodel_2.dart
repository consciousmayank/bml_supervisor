import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';

class ViewEntryViewModel2PointO extends GeneralisedBaseViewModel {
  int _totalKm = 0;

  int _totalKmGround = 0;

  int _kmDifference = 0;

  double _totalFuelInLtr = 0.0;

  double _avgPerLitre = 0.0;

  double _totalFuelAmt = 0.0;

  String _selectedClient = "";
  String get selectedClient => _selectedClient;

  set selectedClient(String selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<ViewEntryResponse> vehicleEntrySearchResponse = [];

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

  void vehicleEntrySearch(String regNum, String selectedDuration) async {
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    int selectedClientValue = selectedClient == 'ALL' ? 0 : 1;
    vehicleEntrySearchResponse.clear();
    _vehicleLog = null;
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.vehicleEntrySearch(
        registrationNumber: regNum,
        duration: selectedDurationValue,
        clientId: selectedClientValue.toString(),
      );

      if (res.statusCode == 200) {
        print('status code 200');
        // if status failed show snack bar
        // else do your business
        if (res is String) {
          print('res is string');
          snackBarService.showSnackbar(message: res.toString());
        } else if (res.data is List) {
//data is returned

          print('res has data');
          var list = res.data as List;
          print('list length' + list.length.toString());
          if (list.length > 0) {
            for (Map singleItem in list) {
              ViewEntryResponse singleSearchResult =
                  ViewEntryResponse.fromMap(singleItem);
              vehicleEntrySearchResponse.add(singleSearchResult);
              _totalKmGround += singleSearchResult.drivenKmGround;
              _totalFuelInLtr += singleSearchResult.fuelLtr;
              _totalKm += singleSearchResult.drivenKm;
              _totalFuelAmt += singleSearchResult.amountPaid;
            }
            if (!(_totalKm == 0 && _totalKmGround == 0)) {
              _kmDifference = _totalKmGround - _totalKm;
              // print('km Diff' + _kmDifference.toString());
            }
            // print('total fuel in ltr: $_totalFuelInLtr');
            // print('total fuel amt: $_totalFuelAmt');
            if (!(_totalKm == 0 && _totalFuelInLtr == 0)) {
              _avgPerLitre = _totalKm / _totalFuelInLtr;
              // print('avg per litr: ${_avgPerLitre.toStringAsFixed(2)}');
            }
            takeToViewEntryDetailedPage2Point0();
          } else {
            snackBarService.showSnackbar(
                message:
                    "No Results found for \"$selectedRegistrationNumber\"");
          }
        } else if (res.data['status'].toString() == 'failed') {
          print('res status is falied');
          snackBarService.showSnackbar(
              message: 'No Result for $selectedRegistrationNumber');
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
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
      'vehicleEntrySearchResponseList': vehicleEntrySearchResponse,
    });
    _totalFuelAmt = 0;
    _kmDifference = 0;
    _totalFuelInLtr = 0;
    _avgPerLitre = 0;
    _totalKm = 0;
    _totalKmGround = 0;
  }
}
