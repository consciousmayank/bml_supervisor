// Added by Vikas
// Module subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';

class ViewEntryViewModel extends GeneralisedBaseViewModel {
  int _totalKm = 0;
  int get totalKm => _totalKm;
  set totalKm(int totalKm) {
    _totalKm = totalKm;
    notifyListeners();
  }

  int _totalKmGround = 0;
  int _kmDifference = 0;
  int get kmDifference => _kmDifference;
  set kmDifference(int kmDifference) {
    _kmDifference = kmDifference;
    notifyListeners();
  }

  double _totalFuelInLtr = 0.0;
  double get totalFuelInLtr => _totalFuelInLtr;
  set totalFuelInLtr(double totalFuelInLtr) {
    _totalFuelInLtr = totalFuelInLtr;
    notifyListeners();
  }

  double _avgPerLitre = 0.0;
  double get avgPerLitre => _avgPerLitre;
  set avgPerLitre(double avgPerLitre) {
    _avgPerLitre = avgPerLitre;
    notifyListeners();
  }

  double _totalFuelAmt = 0.0;
  double get totalFuelAmt => _totalFuelAmt;
  set totalFuelAmt(double totalFuelAmt) {
    _totalFuelAmt = totalFuelAmt;
    notifyListeners();
  }

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
    // vehicleEntrySearch(registrationNumber, selectedDuration);
    print('before sending: total km' + _totalKm.toString());
    navigationService.navigateTo(viewEntryDetailedViewPageRoute, arguments: {
      'totalKm': _totalKm,
      'kmDifference': _kmDifference,
      'totalFuelInLtr': _totalFuelInLtr,
      'avgPerLitre': _avgPerLitre,
      'totalFuelAmt': _totalFuelAmt,
      'vehicleEntrySearchResponseList': vehicleEntrySearchResponse,
    });
  }

  void vehicleEntrySearch(
      String registrationNumber, String selectedDuration) async {
    int selectedDurationValue = getSelectedDurationValue(selectedDuration);
    vehicleEntrySearchResponse.clear();
    _vehicleLog = null;
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.vehicleEntrySearch(
          registrationNumber: registrationNumber,
          duration: selectedDurationValue);
      if (res.statusCode == 200) {
        var list = res.data as List;
        if (list.length > 0) {
          for (Map singleItem in list) {
            ViewEntryResponse singleSearchResult =
                ViewEntryResponse.fromMap(singleItem);
            vehicleEntrySearchResponse.add(singleSearchResult);
            totalKm += singleSearchResult.drivenKm;
            _totalKmGround += singleSearchResult.drivenKmGround;
            totalFuelInLtr += singleSearchResult.fuelLtr;
            totalFuelAmt += singleSearchResult.amountPaid;
          }
          if (!(totalKm == 0 && _totalKmGround == 0)) {
            kmDifference = _totalKmGround - totalKm;
            print('km Diff' + kmDifference.toString());
          }
          print('total fuel in ltr: $totalFuelInLtr');
          print('total fuel amt: $totalFuelAmt');
          if (!(totalKm == 0 && totalFuelInLtr == 0)) {
            avgPerLitre = totalKm / totalFuelInLtr;
            print('avg per litr: ${avgPerLitre.toStringAsFixed(2)}');
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

  int getSelectedDurationValue(String selectedDuration) {
    switch (selectedDuration) {
      case 'THIS MONTH':
        return 0;
      case 'LAST MONTH':
        return 1;
      case 'LAST 3 MONTHS':
        return 2;
      default:
        return 1;
    }
  }
}
