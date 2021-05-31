import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/expense_aggregate.dart';
import 'package:bml_supervisor/models/expense_period_response.dart';
import 'package:bml_supervisor/models/expense_pie_chart_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/single_expense.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';

abstract class ExpensesApi {
  Future<List<ExpenseListResponse>> getExpensesList({@required Map body});

  Future<ApiResponse> addExpense(
      {@required SaveExpenseRequest saveExpenseRequest});

  Future<List<ExpensePeriodResponse>> getExpensePeriod(
      {@required int clientId});
  Future<List<String>> getExpensesTypes();

  Future<ExpenseAggregate> getExpenseAggregate({@required Map body}) {}
}

class ExpensesApisImpl extends BaseApi implements ExpensesApi {
  @override
  Future<List<ExpenseListResponse>> getExpensesList(
      {@required Map body}) async {
    List<ExpenseListResponse> _response = [];
    final res = await apiService.getExpensesList(
      body: body,
    );

    if (filterResponse(res) != null) {
      var list = res.response.data as List;
      for (Map singleItem in list) {
        ExpenseListResponse singleSearchResult =
            ExpenseListResponse.fromMap(singleItem);
        _response.add(singleSearchResult);
      }
    }
    return _response;
  }

  @override
  Future<ApiResponse> addExpense({saveExpenseRequest}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);

    ParentApiResponse apiResponse =
        await apiService.addExpense(request: saveExpenseRequest);

    if (filterResponse(apiResponse) != null) {
      response = ApiResponse.fromMap(apiResponse.response.data);
    }

    return response;
  }

  @override
  Future<List<ExpensePeriodResponse>> getExpensePeriod({int clientId}) async {
    List<ExpensePeriodResponse> periodList = [];
    ParentApiResponse apiResponse =
        await apiService.getExpensePeriod(clientId: clientId);

    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var list = apiResponse.response.data as List;
      for (Map singleItem in list) {
        ExpensePeriodResponse singlePeriod =
            ExpensePeriodResponse.fromMap(singleItem);
        periodList.add(
          ExpensePeriodResponse(
              month: singlePeriod.month, year: singlePeriod.year),
        );
      }
    }

    return periodList;
  }

  @override
  Future<List<String>> getExpensesTypes() async {
    List<String> expensesTypes = [];
    ParentApiResponse apiResponse = await apiService.getExpensesTypes();
    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var list = apiResponse.response.data as List;
      list.forEach((element) {
        expensesTypes.add(element);
      });
    }

    return expensesTypes;
  }

  @override
  Future<ExpenseAggregate> getExpenseAggregate({@required Map body}) async {
    ExpenseAggregate response =
        ExpenseAggregate(totalAmount: 0, recordCount: 0);

    ParentApiResponse apiResponse =
        await apiService.getExpenseAggregate(body: body);
    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      response = ExpenseAggregate.fromMap(apiResponse.response.data);
    }

    return response;
  }
}
