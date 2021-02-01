import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LineChartViewModel extends GeneralisedBaseViewModel {
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
    int clientId,
    String selectedDuration,
  }) async {
    //line chart/graph api
    routesDrivenKmList.clear();
    data = [];
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;

    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRoutesDrivenKm(
        clientId: clientId,
        period: selectedDurationValue,
      );
      if (res.data is List) {
        var list = res.data as List;
        int colorArrayIndex = 0;
        if (list.length > 0) {
          for (Map value in list) {
            RoutesDrivenKm routesDrivenKmResponse =
                RoutesDrivenKm.fromJson(value);
            routesDrivenKmList.add(routesDrivenKmResponse);
          }
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
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
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
