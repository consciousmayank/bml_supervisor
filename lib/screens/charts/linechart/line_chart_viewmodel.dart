import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LineChartViewModel extends GeneralisedBaseViewModel {
  List<RoutesDrivenKm> routesDrivenKmList = [];
  List uniqueRoutes = [];
  List uniqueDates = [];
  List<List<RoutesDrivenKm>> data = List<List<RoutesDrivenKm>>();
  List<charts.Series<RoutesDrivenKm, int>> seriesLineData = [];

  List<Color> lineChartColorArray = [
    Color(0xff68cfc6),
    Color(0xffd89cb8),
    Color(0xfffcce5e),
    Color(0xfffc8685),
    Color(0xff28a745),
    Color(0xffc3e6cb),
    Color(0xffdc3545),
    Color(0xff6c757d),
  ];

  void getRoutesDrivenKm({
    int clientId,
    String selectedDuration,
  }) async {
    //line chart/graph api
    print('getRoutesDrivenKm');
    routesDrivenKmList.clear();

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
        if (list.length > 0) {
          for (Map value in list) {
            RoutesDrivenKm routesDrivenKmResponse =
                RoutesDrivenKm.fromJson(value);
            routesDrivenKmList.add(routesDrivenKmResponse);
          }
          routesDrivenKmList.forEach(
            (routesDrivenKmObject) {
              if (!uniqueRoutes.contains(routesDrivenKmObject.routeId)) {
                uniqueRoutes.add(routesDrivenKmObject.routeId);
              }

              if (!uniqueDates.contains(routesDrivenKmObject.entryDate)) {
                uniqueDates.add(routesDrivenKmObject.entryDate);
              }
            },
          );

          uniqueRoutes.forEach(
            (singleRouteElement) {
              data.add(routesDrivenKmList
                  .where((routeDrivenKmObject) =>
                      routeDrivenKmObject.routeId == singleRouteElement)
                  .toList());
            },
          );

          var route_1 = data[0];
          var route_2 = data[1];
          var route_3 = data[2];
          var route_4 = data[3];
          var route_5 = data[4];

          seriesLineData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(lineChartColorArray[0]),
              id: 'Route 1',
              data: route_1,
              domainFn: (RoutesDrivenKm sales, _) =>
                  int.parse(sales.entryDate.split('-')[0]),
              measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
            ),
          );
          seriesLineData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(lineChartColorArray[1]),
              id: 'Route 2',
              data: route_2,
              domainFn: (RoutesDrivenKm sales, _) =>
                  int.parse(sales.entryDate.split('-')[0]),
              measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
            ),
          );
          seriesLineData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(lineChartColorArray[2]),
              id: 'Route 3',
              data: route_3,
              domainFn: (RoutesDrivenKm sales, _) =>
                  int.parse(sales.entryDate.split('-')[0]),
              measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
            ),
          );
          seriesLineData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(lineChartColorArray[3]),
              id: 'Route 4',
              data: route_4,
              domainFn: (RoutesDrivenKm sales, _) =>
                  int.parse(sales.entryDate.split('-')[0]),
              measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
            ),
          );
          seriesLineData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(lineChartColorArray[4]),
              id: 'Route 5',
              data: route_5,
              domainFn: (RoutesDrivenKm sales, _) =>
                  int.parse(sales.entryDate.split('-')[0]),
              measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
            ),
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
}
