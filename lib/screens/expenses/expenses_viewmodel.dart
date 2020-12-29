import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/expense_response.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';

class ExpensesViewModel extends GeneralisedBaseViewModel {
  // DateTime _fromDate;

  DateTime _entryDate;

  DateTime get entryDate => _entryDate;

  ApiResponse _saveExpenseResponse;

  int pageNumber = 1;

  bool _getLastSevenDaysExpenses = false;

  List<ExpenseResponse> _expensesList = [];

  List<ExpenseResponse> get expensesList => _expensesList;

  set expensesList(List<ExpenseResponse> expensesList) {
    _expensesList = expensesList;
    notifyListeners();
  }

  bool _callGetEntriesApi = true;

  bool _isExpenseListLoading = false;

  bool get isExpenseListLoading => _isExpenseListLoading;

  set isExpenseListLoading(bool isExpenseListLoading) {
    _isExpenseListLoading = isExpenseListLoading;
    notifyListeners();
  }

  bool get callGetEntriesApi => _callGetEntriesApi;

  set callGetEntriesApi(bool callGetEntriesApi) {
    _callGetEntriesApi = callGetEntriesApi;
    notifyListeners();
  }

  bool get getLastSevenDaysExpenses => _getLastSevenDaysExpenses;

  // set getLastSevenDaysExpenses(bool getLastSevenDaysExpenses) {
  //   _getLastSevenDaysExpenses = getLastSevenDaysExpenses;
  //   notifyListeners();
  //   if (selectedSearchVehicle.registrationNumber != null && entryDate != null) {
  //     getExpensesList(showLoader: true, increasePageNumber: false);
  //   }
  // }

  ApiResponse get saveExpenseResponse => _saveExpenseResponse;

  set saveExpenseResponse(ApiResponse saveExpenseResponse) {
    _saveExpenseResponse = saveExpenseResponse;
    notifyListeners();
  }

  set entryDate(DateTime entryDate) {
    _entryDate = entryDate;
    // fromDate = entryDate.add(Duration(days: -7));
    pageNumber = 1;
    // getExpensesList();
    notifyListeners();
  }

  String _expenseType;

  bool _showSubmitForm = false;

  bool get showSubmitForm => _showSubmitForm;

  set showSubmitForm(bool showSubmitForm) {
    _showSubmitForm = showSubmitForm;
    notifyListeners();
  }

  // DateTime get fromDate => _fromDate;

  String get expenseType => _expenseType;

  set expenseType(String expenseType) {
    _expenseType = expenseType;
    notifyListeners();
  }

  // set fromDate(DateTime fromDate) {
  //   _fromDate = fromDate;
  //   notifyListeners();
  // }

  SearchByRegNoResponse _selectedSearchVehicle;

  SearchByRegNoResponse get selectedSearchVehicle => _selectedSearchVehicle;

  set selectedSearchVehicle(SearchByRegNoResponse selectedSearchVehicle) {
    _selectedSearchVehicle = selectedSearchVehicle;
    notifyListeners();
  }

  void takeToSearch() async {
    selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  }

  // Future getExpensesList(
  //     {bool showLoader, bool increasePageNumber = false}) async {
  //   if (!increasePageNumber) {
  //     pageNumber = 1;
  //   }
  //   var response = await apiService.getExpensesList(
  //       regNo: selectedSearchVehicle.registrationNumber,
  //       dateFrom: getLastSevenDaysExpenses
  //           ? getDateString(fromDate)
  //           : getDateString(entryDate),
  //       pageNumber: pageNumber,
  //       toDate: getDateString(entryDate));
  //
  //   if (response is String) {
  //     snackBarService.showSnackbar(message: response);
  //   } else {
  //     if (!increasePageNumber) {
  //       expensesList.clear();
  //     }
  //     try {
  //       (response.data as List).forEach((element) async {
  //         expensesList.add(ExpenseResponse.fromMap(element));
  //       });
  //     } catch (e) {
  //       callGetEntriesApi = false;
  //     }
  //   }
  //   notifyListeners();
  //   pageNumber++;
  // }

  void saveExpense(SaveExpenseRequest saveExpenseRequest) async {
    isExpenseListLoading = true;

    var response = await apiService.addExpense(request: saveExpenseRequest);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else if (response is Response) {
      saveExpenseResponse = ApiResponse.fromMap(response.data);

      if (saveExpenseResponse.status == "success") {
        snackBarService.showCustomSnackBar(
            message: "Expense Added Successfully.", title: "Congrats !");
      } else {
        snackBarService.showCustomSnackBar(
            message: "Expense Not Added.", title: "Please Try Again.");
      }
    }

    isExpenseListLoading = false;
  }
}
