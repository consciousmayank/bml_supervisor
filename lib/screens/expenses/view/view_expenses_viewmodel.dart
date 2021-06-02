// Added by Vikas
// Subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/expense_aggregate.dart';
import 'package:bml_supervisor/models/expense_period_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/single_expense.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/expenses/add/add_expense_arguments.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expense_helper.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/gridViewBottomSheet/grid_view_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../expenses_api.dart';
import 'expenses_filter_bottom_sheet.dart';

class ViewExpensesViewModel extends GeneralisedBaseViewModel {
  ExpenseAggregate expenseAggregate = ExpenseAggregate(
    totalAmount: 0,
    recordCount: 0,
  );

  List<ExpenseListResponse> expenseList = [];
  List<ExpensePeriodResponse> expensePeriodList = [];
  List<String> expensesTypes = [];
  int pageNumber = 1;
  GetClientsResponse selectedClient;
  ExpensePeriodResponse selectedExpensePeriod;
  String selectedExpenseType = '';
  String selectedVehicleId = '';
  Set<String> uniqueDates = Set();
  String vehicleRegNumber;

  ExpensesApi _expensesApi = locator<ExpensesApisImpl>();

  getClients() async {
    setBusy(true);
    selectedClient = MyPreferences().getSelectedClient();
    setBusy(false);
    notifyListeners();
  }

  List<ExpenseListResponse> getConsolidatedData(int index) {
    return expenseList
        .where(
          (element) => element.entryDate == uniqueDates.elementAt(index),
        )
        .toList();
  }

  void showFiltersBottomSheet() async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      customData: ExpensesFilterBottomSheetInputArgs<String>(
          options: expensesTypes, selectedOption: selectedExpenseType),
      variant: BottomSheetType.expenseFilters,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        ExpensesFilterBottomSheetOutputArgs args = sheetResponse.responseData;

        String argument = args.selectedExpense as String;
        if (argument == 'All') {
          selectedExpenseType = '';
        } else {
          selectedExpenseType = argument;
        }

        getExpenses(
          showLoader: true,
          shouldGetExpenseAggregate: true,
        );
      }
    }
  }

  void getExpensesList({
    @required ViewExpensesHelper helper,
    bool showLoader = false,
    shouldGetExpenseAggregate = true,
  }) async {
    if (showLoader) {
      setBusy(true);
      pageNumber = 1;
      expenseList = [];
      uniqueDates = Set();
      expenseAggregate = ExpenseAggregate(
        totalAmount: 0,
        recordCount: 0,
      );
    }

    Map expenseBody = Map<String, dynamic>();
    switch (helper.expenseEnumType) {
      case ViewExpensesType.VIEW_EXPENSE_BY_CLIENT:
        expenseBody = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "page": pageNumber
        };

        if (shouldGetExpenseAggregate) {
          expenseAggregate = await getExpenseAggregate(
            helper: ViewExpensesAggregateHelper.aggregateViewExpensesByClient(
              month: helper.month,
              year: helper.year,
              clientId: helper.clientId,
            ),
          );
        }

        break;
      case ViewExpensesType.VIEW_EXPENSE_BY_CLIENT_AND_TYPE:
        expenseBody = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "page": pageNumber,
          "expenseType": helper.expenseType,
        };

        if (shouldGetExpenseAggregate) {
          expenseAggregate = await getExpenseAggregate(
            helper: ViewExpensesAggregateHelper
                .aggregateViewExpensesByClientAndType(
              month: helper.month,
              year: helper.year,
              clientId: helper.clientId,
              expenseType: helper.expenseType,
            ),
          );
        }
        break;
      case ViewExpensesType.VIEW_EXPENSE_BY_CLIENT_AND_VEHICLE:
        expenseBody = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "page": pageNumber,
          "vehicleId": helper.vehicleId,
        };

        if (shouldGetExpenseAggregate) {
          expenseAggregate = await getExpenseAggregate(
            helper: ViewExpensesAggregateHelper
                .aggregateViewExpensesByClientAndVehicle(
              month: helper.month,
              year: helper.year,
              clientId: helper.clientId,
              vehicleId: helper.vehicleId,
            ),
          );
        }

        break;
      case ViewExpensesType.VIEW_EXPENSE_BY_CLIENT_VEHICLE_AND_TYPE:
        expenseBody = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "page": pageNumber,
          "expenseType": helper.expenseType,
          "vehicleId": helper.vehicleId,
        };

        if (shouldGetExpenseAggregate) {
          expenseAggregate = await getExpenseAggregate(
            helper: ViewExpensesAggregateHelper
                .aggregateViewExpensesByClientVehicleAndType(
              month: helper.month,
              year: helper.year,
              clientId: helper.clientId,
              vehicleId: helper.vehicleId,
              expenseType: helper.expenseType,
            ),
          );
        }
        break;
    }

    if (expenseAggregate.recordCount > expenseList.length) {
      var response = await _expensesApi.getExpensesList(body: expenseBody);

      if (showLoader) {
        expenseList = copyList(response);
      } else {
        expenseList.addAll(
          copyList(response),
        );
      }
      expenseList.forEach((element) {
        uniqueDates.add(element.entryDate);
      });

      pageNumber++;
    }

    notifyListeners();

    setBusy(false);
  }

  Future<ExpenseAggregate> getExpenseAggregate(
      {@required ViewExpensesAggregateHelper helper}) async {
    Map body = Map<String, dynamic>();

    switch (helper.expenseEnumType) {
      case ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT:
        body = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
        };
        break;
      case ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT_AND_TYPE:
        body = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "expenseType": helper.expenseType,
        };
        break;
      case ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT_AND_VEHICLE:
        body = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "vehicleId": helper.vehicleId,
        };
        break;
      case ViewExpensesAggregateType
          .AGGREGATE_EXPENSE_BY_CLIENT_VEHICLE_AND_TYPE:
        body = {
          "clientId": helper.clientId,
          "month": helper.month,
          "year": helper.year,
          "vehicleId": helper.vehicleId,
          "expenseType": helper.expenseType,
        };
        break;
    }

    var response = _expensesApi.getExpenseAggregate(body: body);

    return response;
  }

  void getExpensePeriod() async {
    setBusy(true);
    _expensesApi.getExpensePeriod(clientId: selectedClient.id).then((response) {
      expensePeriodList = copyList(response);
      selectedExpensePeriod = expensePeriodList.first;
      notifyListeners();

      setBusy(false);
      getExpensesList(
        showLoader: true,
        shouldGetExpenseAggregate: true,
        helper: ViewExpensesHelper.viewExpensesByClient(
          month: selectedExpensePeriod.month,
          year: selectedExpensePeriod.year,
          pageNumber: pageNumber,
          clientId: selectedClient.clientId,
        ),
      );
    });
  }

  void getExpensesTypes() async {
    setBusy(true);
    var response = await _expensesApi.getExpensesTypes();
    expensesTypes = copyList(response);
    expensesTypes.insert(0, "All");
    notifyListeners();
  }

  changeExpenePeriod() async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      customData: ExpensesFilterBottomSheetInputArgs<ExpensePeriodResponse>(
          options: expensePeriodList, selectedOption: selectedExpensePeriod),
      variant: BottomSheetType.expenseFilters,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        ExpensesFilterBottomSheetOutputArgs args = sheetResponse.responseData;

        ExpensePeriodResponse argument =
            args.selectedExpense as ExpensePeriodResponse;

        selectedExpensePeriod = ExpensePeriodResponse(
          year: argument.year,
          month: argument.month,
        );
        getExpenses(
          showLoader: true,
          shouldGetExpenseAggregate: true,
        );
      }
    }
  }

  getExpenses({bool showLoader = false, shouldGetExpenseAggregate = true}) {
    if (selectedExpenseType.length > 0 && selectedVehicleId.length > 0) {
      getExpensesList(
        helper: ViewExpensesHelper.viewExpensesByClientVehicleAndType(
          month: selectedExpensePeriod.month,
          year: selectedExpensePeriod.year,
          pageNumber: pageNumber,
          clientId: selectedClient.clientId,
          expenseType: selectedExpenseType,
          vehicleId: selectedVehicleId,
        ),
        showLoader: showLoader,
        shouldGetExpenseAggregate: shouldGetExpenseAggregate,
      );
    } else if (selectedExpenseType.length == 0 &&
        selectedVehicleId.length > 0) {
      getExpensesList(
        helper: ViewExpensesHelper.viewExpensesByClientAndVehicle(
          month: selectedExpensePeriod.month,
          year: selectedExpensePeriod.year,
          pageNumber: pageNumber,
          clientId: selectedClient.clientId,
          vehicleId: selectedVehicleId,
        ),
        showLoader: showLoader,
        shouldGetExpenseAggregate: shouldGetExpenseAggregate,
      );
    } else if (selectedExpenseType.length > 0 &&
        selectedVehicleId.length == 0) {
      getExpensesList(
        helper: ViewExpensesHelper.viewExpensesByClientAndType(
          month: selectedExpensePeriod.month,
          year: selectedExpensePeriod.year,
          pageNumber: pageNumber,
          clientId: selectedClient.clientId,
          expenseType: selectedExpenseType,
        ),
        showLoader: showLoader,
        shouldGetExpenseAggregate: shouldGetExpenseAggregate,
      );
    } else {
      getExpensesList(
        helper: ViewExpensesHelper.viewExpensesByClient(
          month: selectedExpensePeriod.month,
          year: selectedExpensePeriod.year,
          pageNumber: pageNumber,
          clientId: selectedClient.clientId,
        ),
        showLoader: showLoader,
        shouldGetExpenseAggregate: shouldGetExpenseAggregate,
      );
    }
  }

  void takeToAddExpense() {
    List<String> argument = copyList(expensesTypes);
    argument.removeAt(0);
    navigationService
        .navigateTo(
          addExpensesPageRoute,
          arguments: AddExpenseArguments(
            expensesTypes: argument,
          ),
        )
        .then(
          (value) => loadData(),
        );
  }

  void loadData() {
    getExpensesTypes();
    getExpensePeriod();
  }

  void openExpenseDetialsBottomSheet({ExpenseListResponse clickedExpense}) {
    List<GridViewHelper> helperList = [
      GridViewHelper(
        label: 'Vehicle Number',
        value: clickedExpense.vehicleId,
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Entry Date',
        value: clickedExpense.entryDate,
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Expense Amount',
        value: clickedExpense.expenseAmount.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Expense Type',
        value: clickedExpense.expenseType,
        onValueClick: null,
      ),
      if (clickedExpense.fuelLtr > 0)
        GridViewHelper(
          label: 'Fuel Liter',
          value: clickedExpense.fuelLtr.toStringAsFixed(2),
          onValueClick: null,
        ),
      if (clickedExpense.fuelMeterReading > 0)
        GridViewHelper(
          label: 'Fuel Meter Reading',
          value: clickedExpense.fuelMeterReading.toString(),
          onValueClick: null,
        ),
      if (clickedExpense.ratePerLtr > 0)
        GridViewHelper(
          label: 'Fuel Rate',
          value: clickedExpense.ratePerLtr.toStringAsFixed(2),
          onValueClick: null,
        ),
    ];

    List<GridViewHelper> footerListEx = [
      GridViewHelper(
        label: 'Description',
        value: clickedExpense.expenseDesc,
        onValueClick: null,
      ),
    ];

    bottomSheetService.showCustomSheet(
      customData: GridViewBottomSheetInputArgument(
        headerList: [],
        title: 'Expense Details',
        footerList: footerListEx,
        gridList: helperList,
      ),
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.EXPENSE_DETIALS,
    );
  }
}
