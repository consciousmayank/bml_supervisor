import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:flutter/cupertino.dart';

abstract class ExpensesApi {
  Future<List<ViewExpensesResponse>> getExpensesList({
    String registrationNumber,
    String duration,
    String clientId,
  });

  Future<ApiResponse> addExpense(
      {@required SaveExpenseRequest saveExpenseRequest});
}

class ExpensesApisImpl extends BaseApi implements ExpensesApi {
  @override
  Future<List<ViewExpensesResponse>> getExpensesList(
      {String registrationNumber, String duration, String clientId}) async {
    List<ViewExpensesResponse> _response = [];
    final res = await apiService.getExpensesList(
      registrationNumber: registrationNumber,
      clientId: clientId,
      duration: duration,
    );

    if (filterResponse(res) != null) {
      var list = res.response.data as List;
      for (Map singleItem in list) {
        ViewExpensesResponse singleSearchResult =
            ViewExpensesResponse.fromMap(singleItem);
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
