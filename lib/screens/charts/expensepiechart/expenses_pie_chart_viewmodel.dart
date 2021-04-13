// import 'dart:html';
import 'dart:ui';

import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/expense_pie_chart_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ExpensesPieChartViewModel extends GeneralisedBaseViewModel {
  int eMonth;
  int eYear;
  ChartsApi _chartsApi = locator<ChartsApiImpl>();
  List<String> _uniqueExpenseTypes = [];

  List<String> get uniqueExpenseTypes => _uniqueExpenseTypes;

  set uniqueExpenseTypes(List<String> value) {
    _uniqueExpenseTypes = value;
    notifyListeners();
  }

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  String _chartDate;

  String get chartDate => _chartDate;

  set chartDate(String value) {
    _chartDate = value;
    notifyListeners();
  }

  List<ExpensePieChartResponse> expensePieChartResponseList = [];
  List<charts.Series<ExpensePieChartResponse, String>> expenseSeriesPieData =
      [];

  List<Color> pieChartsColorArray = [
// reversed color sequence
    Color(0xff2F4B7C),
    Color(0xffD45087),
    Color(0xff7458AF),
    Color(0xffCEA9BC),
    Color(0xffA05195),
    Color(0xffFF7C43),
    Color(0xff2085EC),
    Color(0xffF95D6A),
    Color(0xffFFA600),
    Color(0xff72B4EB),
  ];
  double totalExpenses = 0.0;

  void getExpensesListForPieChart({String clientId}) async {
    // int selectedPeriodValue = selectedDuration.contains('THIS MONTH') ? 1 : 2;
    //
    // if (selectedPeriodValue == 1) {
    //   selectedDate = DateTime.now();
    // } else {
    //   selectedDate = Jiffy(DateTime.now()).subtract(months: 1);
    // }

    expensePieChartResponseList.clear();
    uniqueExpenseTypes.clear();
    setBusy(true);
    notifyListeners();
    // try {
    ParentApiResponse apiResponse = await _chartsApi
        .getExpensesListForPieChartAggregate(clientId: clientId);
    if (apiResponse.error == null) {
      if (apiResponse.isNoDataFound()) {
        // snackBarService.showSnackbar(message: apiResponse.emptyResult);
      } else {
        if (apiResponse.response.data is List) {
          var list = apiResponse.response.data as List;
          int colorArrayIndex = 0;
          if (list.length > 0) {
            for (Map value in list) {
              ExpensePieChartResponse routesDrivenKmPercentageResponse =
                  ExpensePieChartResponse.fromMap(value);
              routesDrivenKmPercentageResponse =
                  routesDrivenKmPercentageResponse.copyWith(
                color: pieChartsColorArray[colorArrayIndex],
              );
              if (!uniqueExpenseTypes
                  .contains(routesDrivenKmPercentageResponse.eType)) {
                uniqueExpenseTypes.add(routesDrivenKmPercentageResponse.eType);
              }
              eMonth = routesDrivenKmPercentageResponse.eMonth;
              eYear = routesDrivenKmPercentageResponse.eYear;

              ++colorArrayIndex;
              totalExpenses += routesDrivenKmPercentageResponse.eAmount;
              expensePieChartResponseList.add(routesDrivenKmPercentageResponse);
            }

            expenseSeriesPieData.add(
              charts.Series(
                domainFn: (ExpensePieChartResponse task, _) => task.eType,
                measureFn: (ExpensePieChartResponse task, _) => task.eAmount,
                colorFn: (ExpensePieChartResponse task, _) =>
                    charts.ColorUtil.fromDartColor(task.color),
                id: 'Expense Percentage',
                data: expensePieChartResponseList,
                labelAccessorFn: (ExpensePieChartResponse task, _) =>
                    '${((task.eAmount / totalExpenses) * 100).toStringAsFixed(1)}%\n(\u{20B9}${task.eAmount})'
                        .toString(),
              ),
            );
            uniqueExpenseTypes.forEach((element) {
              // print(element);
            });
          }
        }
      }
    } else {
      snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }
    // } on DioError catch (e) {
    //   snackBarService.showSnackbar(message: e.message);
    //   setBusy(false);
    // }
    notifyListeners();
    setBusy(false);
  }

  Text buildChartSubTitleNew() {
    return Text(
      '(' + getMonth(eMonth) + ', ' + eYear.toString() + ')',
      style: AppTextStyles.latoBold12Black,
    );
  }

// String getRouteTitle(int index) {
//   return routesDrivenKmPercentageList
//       .firstWhere((element) => element.routeId.toString() == uniqueRoutes[index])
//       .routeTitle;
// }
}
