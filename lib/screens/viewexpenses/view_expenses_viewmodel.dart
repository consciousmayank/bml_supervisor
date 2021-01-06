// Added by Vikas
// Subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ViewExpensesViewModel extends GeneralisedBaseViewModel {
  List<ViewExpensesResponse> viewExpensesResponse = [];
  SearchByRegNoResponse _selectedSearchVehicle;
  SearchByRegNoResponse get selectedSearchVehicle => _selectedSearchVehicle;
  set selectedSearchVehicle(SearchByRegNoResponse selectedSearchVehicle) {
    _selectedSearchVehicle = selectedSearchVehicle;
    notifyListeners();
  }

  String _selectedDuration = "";
  String get selectedDuration => _selectedDuration;

  set selectedDuration(String selectedDuration) {
    _selectedDuration = selectedDuration;
    notifyListeners();
  }

  String _vehicleRegNumber;
  String get vehicleRegNumber => _vehicleRegNumber;
  set vehicleRegNumber(String vehicleRegNumber) {
    _vehicleRegNumber = vehicleRegNumber;
    notifyListeners();
  }

  String _expenseEntryDate;

  String get expenseEntryDate => _expenseEntryDate;
  set expenseEntryDate(String expenseEntryDate) {
    _expenseEntryDate = expenseEntryDate;
    notifyListeners();
  }

  String _expenseType;
  String get expenseType => _expenseType;
  set expenseType(String expenseType) {
    _expenseType = expenseType;
    notifyListeners();
  }

  String _expenseAmount;
  String get expenseAmount => _expenseAmount;
  set expenseAmount(String expenseAmount) {
    _expenseAmount = expenseAmount;
    notifyListeners();
  }

  String _expenseDesc;
  String get expenseDesc => _expenseDesc;
  set expenseDesc(String expenseDesc) {
    _expenseDesc = expenseDesc;
    notifyListeners();
  }

  DateTime _fromDate;
  DateTime get fromDate => _fromDate;
  set fromDate(DateTime fromDate) {
    _fromDate = fromDate;
    notifyListeners();
  }

  bool _emptyDateSelector = false;
  bool get emptyDateSelector => _emptyDateSelector;

  set emptyDateSelector(bool emptyDateSelector) {
    _emptyDateSelector = emptyDateSelector;
  }

  // void takeToSearch() async {
  //   selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  // }

  void getExpensesList() async {
    viewExpensesResponse.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    print(
        '**selected duration: $selectedDuration, selected reg num $vehicleRegNumber');
    // final uptoDate =
    //     DateFormat('dd-MM-yyyy').format(DateTime.now()).toLowerCase();
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.getExpensesList(
        regNum: vehicleRegNumber,
        duration: selectedDurationValue.toString(),
      );

      if (res.data is! List) {
        print('data is not list');
        snackBarService.showSnackbar(
            message: "No Results found for $vehicleRegNumber");
      } else {
        if (res.statusCode == 200) {
          var list = res.data as List;
          if (list.length > 0) {
            for (Map singleItem in list) {
              ViewExpensesResponse singleSearchResult =
                  ViewExpensesResponse.fromMap(singleItem);
              viewExpensesResponse.add(singleSearchResult);
            }

            takeToViewExpenseDetailedPage();
          } else {
            snackBarService.showSnackbar(
                message: "No Results found for \"$vehicleRegNumber\"");
          }
        }
      }
      // }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  void takeToViewExpenseDetailedPage() {
    print(
        'before sending - expense type: $viewExpensesResponse[0].expenseType');

    navigationService
        .navigateTo(viewExpensesDetailedViewPageRoute,
            arguments: viewExpensesResponse)
        .then((value) {
      vehicleRegNumber = null;
      // selectedDuration = null;
    });
  }
}
