import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LineChartViewModel extends GeneralisedBaseViewModel {
  ChartsApi _chartsApi = locator<ChartsApiImpl>();
  List<RoutesDrivenKm> routesDrivenKmList = [];
  List uniqueRoutes = [];
  List<DateTime> uniqueDates = [];
  List<List<RoutesDrivenKm>> data = [];
  List<charts.Series<RoutesDrivenKm, int>> seriesLineData = [];
  List<BezierLine> bezierLineList = [];

  List<Color> lineChartColorArray = [
    Color(0xff68cfc6),
    Color(0xffd89cb8),
    Color(0xfffcce5e),
    Color(0xfffc8685),
    Color(0xffaa66cc),
    Color(0xff28a745),
    Color(0xffc3e6cb),
    Color(0xffdc3545),
  ];

  void getRoutesDrivenKm({
    String clientId,
    String selectedDuration,
  }) async {
    //line chart/graph api
    routesDrivenKmList.clear();
    data = [];
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;

    setBusy(true);
    notifyListeners();
    List<RoutesDrivenKm> res = await _chartsApi.getRoutesDrivenKm(
      clientId: clientId,
      period: selectedDurationValue,
    );

    routesDrivenKmList = copyList(res);

    // add distinct routes and dates to uniqueRoutes and uniqueDates
    routesDrivenKmList.forEach(
      (routesDrivenKmObject) {
        if (!uniqueRoutes.contains(routesDrivenKmObject.routeId)) {
          uniqueRoutes.add(routesDrivenKmObject.routeId);
        }
        if (!uniqueDates.contains(routesDrivenKmObject.entryDate)) {
          uniqueDates.add(routesDrivenKmObject.entryDateTime);
        }
      },
    );

    uniqueRoutes.forEach(
      (singleRouteElement) {
        data.add(
          routesDrivenKmList
              .where((routeDrivenKmObject) =>
                  routeDrivenKmObject.routeId == singleRouteElement)
              .toList(),
        );
      },
    );

    notifyListeners();
    setBusy(false);
  }

  getBezierData() {
    bezierLineList = [];
    data.forEach((singleLineData) {
      List<DataPoint<DateTime>> dataList = [];
      print("Colors :: ${data.indexOf(singleLineData)}");
      singleLineData.forEach((element) {
        dataList.add(DataPoint<DateTime>(
            value: element.drivenKmG.toDouble(), xAxis: element.entryDateTime));
      });

      bezierLineList.add(BezierLine(
        lineColor: lineChartColorArray[data.indexOf(singleLineData)],
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
