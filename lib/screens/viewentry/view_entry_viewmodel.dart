// Added by Vikas
// Module subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';

class ViewEntryViewModel extends GeneralisedBaseViewModel {
  int _totalKm = 0;
  // int get totalKm => _totalKm;
  // set totalKm(int totalKm) {
  //   _totalKm = totalKm;
  //   notifyListeners();
  // }

  int _totalKmGround = 0;
  // int get totalKmGround => _totalKmGround;
  // set totalKmGround(int totalKmGround) {
  //   totalKmGround = totalKmGround;
  //   notifyListeners();
  // }

  int _kmDifference = 0;
  // int get kmDifference => _kmDifference;
  // set kmDifference(int kmDifference) {
  //   _kmDifference = kmDifference;
  //   notifyListeners();
  // }

  double _totalFuelInLtr = 0.0;
  // double get totalFuelInLtr => _totalFuelInLtr;
  // set totalFuelInLtr(double totalFuelInLtr) {
  //   _totalFuelInLtr = totalFuelInLtr;
  //   notifyListeners();
  // }

  double _avgPerLitre = 0.0;
  // double get avgPerLitre => _avgPerLitre;
  // set avgPerLitre(double avgPerLitre) {
  //   _avgPerLitre = avgPerLitre;
  //   notifyListeners();
  // }

  double _totalFuelAmt = 0.0;
  // double get totalFuelAmt => _totalFuelAmt;
  // set totalFuelAmt(double totalFuelAmt) {
  //   _totalFuelAmt = totalFuelAmt;
  //   notifyListeners();
  // }

  String _selectedDuration = "";
  bool _selectedDurationError = false;
  List<ViewEntryResponse> vehicleEntrySearchResponse = [];
  ViewEntryResponse _vehicleLog; // _vehicleLog -> _viewEntryResponse
  SearchByRegNoResponse _selectedSearchVehicle;

  String get selectedDuration => _selectedDuration;

  set selectedDuration(String selectedDuration) {
    _selectedDuration = selectedDuration;
    notifyListeners();
  }

  bool get selectedDurationError => _selectedDurationError;

  set selectedDurationError(bool selectedDurationError) {
    _selectedDurationError = selectedDurationError;
    notifyListeners();
  }

  ViewEntryResponse get vehicleLog => _vehicleLog;
  set vehicleLog(ViewEntryResponse vehicleLog) {
    _vehicleLog = vehicleLog;
    notifyListeners();
  }

  SearchByRegNoResponse get selectedSearchVehicle => _selectedSearchVehicle;
  set selectedSearchVehicle(SearchByRegNoResponse selectedSearchVehicle) {
    _selectedSearchVehicle = selectedSearchVehicle;
    notifyListeners();
  }

  void takeToSearch() async {
    selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  }

  void takeToViewEntryDetailedPage() {
    navigationService.navigateTo(viewEntryDetailedViewPageRoute, arguments: {
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

  void vehicleEntrySearch(
      String registrationNumber, String selectedDuration) async {
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    vehicleEntrySearchResponse.clear();
    _vehicleLog = null;
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.vehicleEntrySearch(
          regNum: registrationNumber, duration: selectedDurationValue);
      if (res.statusCode == 200) {
        var list = res.data as List;
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
          if ((_totalKm != 0 && _totalFuelInLtr != 0)) {
            _avgPerLitre = _totalKm / _totalFuelInLtr;
            // print('avg per litr: ${_avgPerLitre.toStringAsFixed(2)}');
          }
        } else {
          snackBarService.showSnackbar(
              message: "No Results found for \"$registrationNumber\"");
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
    takeToViewEntryDetailedPage();
  }
}
