import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChartViewModel extends GeneralisedBaseViewModel {
  ChartsApi _chartsApi = locator<ChartsApiImpl>();
  List<RoutesDrivenKmPercentage> routesDrivenKmPercentageList = [];
  List<charts.Series<RoutesDrivenKmPercentage, String>> seriesPieData = [];

  double totalDrivenKmG = 0.0;

  void getRoutesDrivenKmPercentage({String clientId, String period}) async {
    int selectedPeriodValue = period == 'THIS MONTH' ? 1 : 2;
    routesDrivenKmPercentageList.clear();
    setBusy(true);
    notifyListeners();

    List<RoutesDrivenKmPercentage> res =
        await _chartsApi.getRoutesDrivenKmPercentage(
      clientId: clientId,
      period: selectedPeriodValue,
    );

    routesDrivenKmPercentageList = copyList(res);
    routesDrivenKmPercentageList.forEach((element) {
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
}
