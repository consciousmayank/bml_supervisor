import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/expense_pie_chart_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:flutter/cupertino.dart';

abstract class ExpensesApi {
  Future<List<ExpensePieChartResponse>> getExpensesList({
    String registrationNumber,
    int clientId,
  });

  Future<ApiResponse> addExpense(
      {@required SaveExpenseRequest saveExpenseRequest});
}

class ExpensesApisImpl extends BaseApi implements ExpensesApi {
  @override
  Future<List<ExpensePieChartResponse>> getExpensesList(
      {String registrationNumber, int clientId}) async {
    List<ExpensePieChartResponse> _response = [];
    final res = await apiService.getExpensesList(
      registrationNumber: registrationNumber,
      clientId: clientId,
    );

    if (filterResponse(res) != null) {
      var list = res.response.data as List;
      for (Map singleItem in list) {
        ExpensePieChartResponse singleSearchResult =
            ExpensePieChartResponse.fromMap(singleItem);
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
}
