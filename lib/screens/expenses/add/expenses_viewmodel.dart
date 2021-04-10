import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/expense_response.dart';
import 'package:bml_supervisor/models/get_daily_kilometers_info.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dailykms/daily_entry_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/expenses/expenses_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class ExpensesViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  ExpensesApi _expensesApi = locator<ExpensesApisImpl>();
  DailyEntryApis _dailyEntryApis = locator<DailyEntryApisImpl>();
  bool _clearData = false;
  List<GetDailyKilometerInfo> _dailyKmInfoList = [];

  List<GetDailyKilometerInfo> get dailyKmInfoList => _dailyKmInfoList;

  set dailyKmInfoList(List<GetDailyKilometerInfo> value) {
    _dailyKmInfoList = value;
    notifyListeners();
  }

  GetDailyKilometerInfo _selectedDailyKmInfo;

  GetDailyKilometerInfo get selectedDailyKmInfo => _selectedDailyKmInfo;

  set selectedDailyKmInfo(GetDailyKilometerInfo value) {
    _selectedDailyKmInfo = value;
  }

  bool get clearData => _clearData;

  set clearData(bool value) {
    _clearData = value;
  }

  bool _isRegNumCorrect = false;

  bool get isRegNumCorrect => _isRegNumCorrect;

  set isRegNumCorrect(bool isRegNumCorrect) {
    _isRegNumCorrect = isRegNumCorrect;
    notifyListeners();
  }

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

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  void takeToSearch() async {
    selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    var response = await _dashBoardApis.getClientList();
    _clientsList = copyList(response);
    setBusy(false);
    notifyListeners();
  }

  void saveExpense(SaveExpenseRequest saveExpenseRequest) async {
    isExpenseListLoading = true;
    ApiResponse response =
        await _expensesApi.addExpense(saveExpenseRequest: saveExpenseRequest);

    if (response.isSuccessful()) {
      entryDate = null;
      selectedDailyKmInfo = null;
      expenseType = null;
      clearData = true;
      showSubmitForm = false;
      dailyKmInfoList.clear();
    }
    snackBarService.showSnackbar(message: response.message);
    isExpenseListLoading = false;
  }

  void searchByRegistrationNumber(
      SaveExpenseRequest saveExpenseResponse) async {
    setBusy(true);

    var entryLog = await apiService
        .searchByRegistrationNumber(saveExpenseResponse.vehicleId);
    if (entryLog is String) {
      snackBarService.showSnackbar(message: entryLog);
    } else if (entryLog.data['status'].toString() == 'failed') {
      setBusy(false);
      snackBarService.showSnackbar(
          message: "Enter Correct Registration Number");
    } else {
      SearchByRegNoResponse singleSearchResult =
          SearchByRegNoResponse.fromMap(entryLog.data);
      // print('init reading - ${singleSearchResult.initReading}');
      isRegNumCorrect = true;
      // vehicleLog = EntryLog.fromMap(entryLog.data);

      // *call saveExpense api here
      saveExpense(saveExpenseResponse);
      setBusy(false);
    }
    // return isRegNumCorrect;
  }

  void getInfo() async {
    setBusy(true);
    var response = await _dailyEntryApis.getDailyKmInfo(
      date: getDateString(entryDate),
    );
    dailyKmInfoList = copyList(response);
    setBusy(false);
  }
}
