import 'dart:ui';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
import 'package:dio/dio.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChartViewModel extends GeneralisedBaseViewModel {
  List<RoutesDrivenKmPercentage> routesDrivenKmPercentageList = [];
  List<charts.Series<RoutesDrivenKmPercentage, String>> seriesPieData=[];

  List<Color> pieChartsColorArray = [
    Color(0xff2f6497),
    Color(0xffee6868),
    Color(0xff698caf),
    Color(0xffe8743b),
    Color(0xffed4a7b),
    Color(0xff5899da),
    Color(0xff6c757d),
    Color(0xff945ecf),
  ];
  double totalDrivenKmG = 0.0;

  void getRoutesDrivenKmPercentage({int clientId, String period}) async {
    int selectedPeriodValue = period == 'THIS MONTH' ? 1 : 2;
    routesDrivenKmPercentageList.clear();
    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRoutesDrivenKmPercentage(
        clientId: clientId,
        period: selectedPeriodValue,
      );
      if (res.data is List) {
        var list = res.data as List;
        int colorArrayIndex = 0;
        if (list.length > 0) {
          for (Map value in list) {
            RoutesDrivenKmPercentage routesDrivenKmPercentageResponse =
                RoutesDrivenKmPercentage.fromJson(value);
            routesDrivenKmPercentageResponse =
                routesDrivenKmPercentageResponse.copyWith(
              color: pieChartsColorArray[colorArrayIndex],
            );
            ++colorArrayIndex;
            totalDrivenKmG += routesDrivenKmPercentageResponse.drivenKmG;
            routesDrivenKmPercentageList.add(routesDrivenKmPercentageResponse);
          }
          seriesPieData.add(
            charts.Series(
              domainFn: (RoutesDrivenKmPercentage task, _) =>
                  'R' + task.routeId.toString(),
              measureFn: (RoutesDrivenKmPercentage task, _) => task.drivenKmG,
              colorFn: (RoutesDrivenKmPercentage task, _) =>
                  charts.ColorUtil.fromDartColor(task.color),
              id: 'route percentage',
              data: routesDrivenKmPercentageList,
              labelAccessorFn: (RoutesDrivenKmPercentage task, _) =>
                  '${((task.drivenKmG / totalDrivenKmG) * 100).toStringAsFixed(1)}%'
                      .toString(),
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
