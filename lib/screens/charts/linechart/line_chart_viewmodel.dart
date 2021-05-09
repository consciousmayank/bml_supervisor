import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:flutter/material.dart';
import 'package:bml/bml.dart';

class LineChartViewModel extends GeneralisedBaseViewModel {
  ChartsApi _chartsApi = locator<ChartsApiImpl>();
  DateTime _selectedDateForLineChart = DateTime.now();

  DateTime get selectedDateForLineChart => _selectedDateForLineChart;

  set selectedDateForLineChart(DateTime value) {
    _selectedDateForLineChart = value;
  }

  String _chartDate;

  String get chartDate => _chartDate;

  set chartDate(String value) {
    _chartDate = value;
    notifyListeners();
  }

  List<RoutesDrivenKm> routesDrivenKmListForLineChart = [];
  List uniqueRoutes = [];
  List<DateTime> uniqueDatesForLineChart = [];
  List<List<RoutesDrivenKm>> dataForLineChart = [];

  // List<charts.Series<RoutesDrivenKm, int>> seriesLineData = [];
  List<BezierLine> bezierLineList = [];
  List<String> uniqueDates = [];

  List<Color> lineChartColorArray = [
    Color(0xff2F4B7C),
    Color(0xff79CBBF),
    Color(0xff2085EC),
    Color(0xffFF7C43),
    Color(0xffEA789A),
    Color(0xff8359A8),
    Color(0xffAD8234),
    Color(0xffE1C303),
    Color(0xff72B4EB),

    // AppColors.primaryColorShade4,
    // AppColors.primaryColorShade7,
    // AppColors.primaryColorShade8,
    // AppColors.primaryColorShade9,
    // AppColors.primaryColorShade10,
  ];

  void getRoutesDrivenKm({
    String clientId,
  }) async {
    chartDate = '';
    routesDrivenKmListForLineChart.clear();
    dataForLineChart = [];

    // int selectedDurationValue =
    //     selectedDuration.contains('THIS MONTH') ? 1 : 2;
    // if (selectedDurationValue == 1) {
    //   selectedDateForLineChart = DateTime.now();
    // } else {
    //   selectedDateForLineChart = DateTime.now().subtract(Duration(days: 30));
    // }

    setBusy(true);
    notifyListeners();
    List<RoutesDrivenKm> res = await _chartsApi.getRoutesDrivenKm(
      clientId: clientId,
    );

    routesDrivenKmListForLineChart = Utils().copyList(res);

    // add distinct routes and dates to uniqueRoutes and uniqueDates
    routesDrivenKmListForLineChart.forEach(
      (routesDrivenKmObject) {
        if (!uniqueRoutes.contains(routesDrivenKmObject.routeId)) {
          uniqueRoutes.add(routesDrivenKmObject.routeId);
        }
        if (!uniqueDates.contains(routesDrivenKmObject.entryDate)) {
          uniqueDates.add(routesDrivenKmObject.entryDate);
        }
        if (!uniqueDatesForLineChart.contains(routesDrivenKmObject.entryDate)) {
          uniqueDatesForLineChart.add(routesDrivenKmObject.entryDateTime);
        }
      },
    );
    if (uniqueDates.length > 0) {
      chartDate = uniqueDates?.first;
    }

    uniqueRoutes.forEach(
      (singleRouteElement) {
        dataForLineChart.add(
          routesDrivenKmListForLineChart
              .where((routeDrivenKmObject) =>
                  routeDrivenKmObject.routeId == singleRouteElement)
              .toList(),
        );
      },
    );

    notifyListeners();
    setBusy(false);
  }

  String getRouteTitle(int index) {
    return routesDrivenKmListForLineChart
        .firstWhere((element) => element.routeId == uniqueRoutes[index])
        .routeTitle;
  }

  getBezierData() {
    bezierLineList = [];
    dataForLineChart.forEach((singleLineData) {
      List<DataPoint<DateTime>> dataList = [];
      // print("Colors :: ${dataForLineChart.indexOf(singleLineData)}");
      singleLineData.forEach((element) {
        dataList.add(DataPoint<DateTime>(
            value: element.drivenKmG.toDouble(), xAxis: element.entryDateTime));
      });

      bezierLineList.add(BezierLine(
        lineColor:
            lineChartColorArray[dataForLineChart.indexOf(singleLineData)],
        // label: "Route# ${data.indexOf(singleLineData)}",
        onMissingValue: (dateTime) {
          return 0;
        },
        data: dataList,
      ));
    });

    return bezierLineList;
  }
}
