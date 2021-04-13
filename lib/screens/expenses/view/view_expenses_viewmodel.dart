// Added by Vikas
// Subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/expense_pie_chart_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:stacked_services/stacked_services.dart';

import '../expenses_api.dart';
import 'expenses_filter_bottom_sheet.dart';

class ViewExpensesViewModel extends GeneralisedBaseViewModel {
  ExpensesApi _expensesApi = locator<ExpensesApisImpl>();
  double _totalExpenses = 0.0;

  double get totalExpenses => _totalExpenses;

  set totalExpenses(double value) {
    _totalExpenses = value;
    notifyListeners();
  }

  List<ExpensePieChartResponse> viewExpensesResponse = [];
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

  List<String> _expenseTypes = [];

  List<String> get expenseTypes => _expenseTypes;

  set expenseTypes(List<String> value) {
    _expenseTypes = value;
    notifyListeners();
  }

  String _selectedExpenseType = "All";

  String get selectedExpenseType => _selectedExpenseType;

  set selectedExpenseType(String value) {
    _selectedExpenseType = value;
    notifyListeners();
  }

  List<ExpensePieChartResponse> expensePieChartResponseListAll = [];

  // List<ExpensePieChartResponse> _expensePieChartResponseList = [];
  //
  // List<ExpensePieChartResponse> get expensePieChartResponseList =>
  //     _expensePieChartResponseList;
  //
  // set expensePieChartResponseList(List<ExpensePieChartResponse> value) {
  //   _expensePieChartResponseList = value;
  //   notifyListeners();
  // }

  List<String> uniqueDates = [];

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

  void getExpensesList({String regNum, String clientId}) async {
    expenseCount = 0;
    uniqueDates.clear();
    _expenseTypes.clear();
    totalExpenses = 0.0;
    setBusy(true);
    viewExpensesResponse.clear();
    // int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    notifyListeners();
    setBusy(true);
    final res = await _expensesApi.getExpensesList(
      registrationNumber: regNum,
      clientId: clientId,
    );
    viewExpensesResponse = copyList(res);
    viewExpensesResponse.forEach((element) {
      // expensePieChartResponseList
      //     .add(element);
      expensePieChartResponseListAll.add(element);
      if (!uniqueDates.contains(element.eDate)) {
        uniqueDates.add(element.eDate);
      }
      if (!_expenseTypes.contains(element.eType)) {
        _expenseTypes.add(element.eType);
      }
      totalExpenses += element.eAmount;
      ++expenseCount;
    });
    _expenseTypes.insert(0, "All");
    // takeToViewExpenseDetailedPage();
    notifyListeners();
    setBusy(false);
  }

  List<ExpensePieChartResponse> getConsolidatedData(int index) {
    return viewExpensesResponse
        .where((element) => element.eDate == uniqueDates[index])
        .toList();
  }

  void showFiltersBottomSheet() async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      customData: ExpensesFilterBottomSheetInputArgs(
          expenseTypes: expenseTypes, selectedExpense: selectedExpenseType),
      variant: BottomSheetType.expenseFilters,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        ExpensesFilterBottomSheetOutputArgs args = sheetResponse.responseData;
        selectedExpenseType = args.selectedExpense;
        if (args.index == 0) {
          viewExpensesResponse = copyList(expensePieChartResponseListAll);
        } else {
          filterList(args.index);
        }
        notifyListeners();
        // viewModel.navigationService.back();
      }
    }
  }

  void filterList(int index) {
    List<ExpensePieChartResponse> tempList = [];

    expensePieChartResponseListAll.forEach((element) {
      if (element.eType == expenseTypes[index]) {
        tempList.add(element);
      }
    });

    viewExpensesResponse.clear();
    viewExpensesResponse = copyList(tempList);
  }
}
