import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:dio/dio.dart';

class SearchViewModel extends GeneralisedBaseViewModel {
  String _searchParam = "";

  String get searchParam => _searchParam;

  set searchParam(String searchParam) {
    _searchParam = searchParam;
    notifyListeners();
  }

  List<SearchByRegNoResponse> searchResponse = [];
  SearchByRegNoResponse _selectedVehicle;

  SearchByRegNoResponse get selectedVehicle => _selectedVehicle;

  set selectedVehicle(SearchByRegNoResponse selectedVehicle) {
    _selectedVehicle = selectedVehicle;
    notifyListeners();
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
        } else {
          snackBarService.showSnackbar(
              message: "No Results found for \"$text\"");
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  returnResult(SearchByRegNoResponse selectedSearchResult) {
    navigationService.back(result: selectedSearchResult);
  }

  void showSnackBarError(String errorMsg) {
    snackBarService.showSnackbar(message: errorMsg);
  }
}
