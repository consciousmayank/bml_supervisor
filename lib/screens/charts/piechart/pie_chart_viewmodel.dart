import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieChartViewModel extends GeneralisedBaseViewModel {
  ChartsApi _chartsApi = locator<ChartsApiImpl>();
  List<String> _uniqueRoutes = [];

  List<String> get uniqueRoutes => _uniqueRoutes;

  set uniqueRoutes(List<String> value) {
    _uniqueRoutes = value;
  }

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  List<RoutesDrivenKmPercentage> routesDrivenKmPercentageList = [];
  List<charts.Series<RoutesDrivenKmPercentage, String>> seriesPieData = [];

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
  double totalDrivenKmG = 0.0;

  void getRoutesDrivenKmPercentage({String clientId}) async {
    // int selectedPeriodValue = period.contains('THIS MONTH') ? 1 : 2;

    // if (selectedPeriodValue == 1) {
    //   selectedDate = DateTime.now();
    // } else {
    //   selectedDate = DateTime.now().subtract(Duration(days: 30));
    // }

    routesDrivenKmPercentageList.clear();
    totalDrivenKmG = 0;
    setBusy(true);
    notifyListeners();

    List<RoutesDrivenKmPercentage> res =
        await _chartsApi.getRoutesDrivenKmPercentage(
      clientId: clientId,
    );

    routesDrivenKmPercentageList = copyList(res);

    routesDrivenKmPercentageList.forEach((element) {
      if (!uniqueRoutes.contains(element.routeId)) {
        uniqueRoutes.add(element.routeId.toString());
      }
      totalDrivenKmG += element.drivenKmG;
    });

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

    notifyListeners();
    setBusy(false);
  }

  String getRouteTitle(int index) {
    return routesDrivenKmPercentageList
        .firstWhere(
            (element) => element.routeId.toString() == uniqueRoutes[index])
        .routeTitle;
  }
}
