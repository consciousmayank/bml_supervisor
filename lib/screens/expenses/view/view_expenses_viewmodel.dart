// Added by Vikas
// Subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

import '../expenses_api.dart';

class ViewExpensesViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  ExpensesApi _expensesApi = locator<ExpensesApisImpl>();
  double _totalExpenses = 0.0;
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

  int _expenseCount = 0;

  int get expenseCount => _expenseCount;

  set expenseCount(int value) {
    _expenseCount = value;
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

  GetClientsResponse _selectedClient;
  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  // void takeToSearch() async {
  //   selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  // }

  getClients() async {
    setBusy(true);
    selectedClient = MyPreferences().getSelectedClient();
    setBusy(false);
    notifyListeners();
  }

  void getExpensesList(
      {String regNum, String selectedDuration, String clientId}) async {
    expenseCount = 0;
    setBusy(true);
    viewExpensesResponse.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    notifyListeners();
    setBusy(true);
    final res = await _expensesApi.getExpensesList(
      registrationNumber: regNum,
      clientId: clientId,
      duration: selectedDurationValue.toString(),
    );
    viewExpensesResponse = copyList(res);
    viewExpensesResponse.forEach((element) {
      _totalExpenses += element.eAmount;
      ++expenseCount;
    });
    // takeToViewExpenseDetailedPage();
    notifyListeners();
    setBusy(false);
  }

  void takeToViewExpenseDetailedPage() {
    print(
        'before sending - expense type: $viewExpensesResponse[0].expenseType');

    navigationService.navigateTo(
      viewExpensesDetailedViewPageRoute,
      arguments: {
        'viewExpensesDetailedList': viewExpensesResponse,
        'totalExpenses': _totalExpenses,
        'selectedClient':
            selectedClient == null ? 'All Clients' : selectedClient.clientId
      },
    ).then((value) {
      vehicleRegNumber = null;
      _totalExpenses = 0.0;
      // selectedDuration = null;
    });
  }

  double get totalExpenses => _totalExpenses;
}