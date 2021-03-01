import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartViewModel extends GeneralisedBaseViewModel {
  ChartsApi _chartsApi = locator<ChartsApiImpl>();

  double totalKmG = 0.0;
  List<charts.Series<KilometerReportResponse, String>> _seriesBarData;

  List<charts.Series<KilometerReportResponse, String>> get seriesBarData =>
      _seriesBarData;

  set seriesBarData(
      List<charts.Series<KilometerReportResponse, String>> value) {
    _seriesBarData = value;
    notifyListeners();
  }

  List<KilometerReportResponse> _kmReportListData = [];

  List<KilometerReportResponse> get kmReportListData => _kmReportListData;

  set kmReportListData(List<KilometerReportResponse> kmReportListData) {
    _kmReportListData = kmReportListData;
    notifyListeners();
  }

  Future getBarGraphKmReport({String clientId, String selectedDuration}) async {
    kmReportListData.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    notifyListeners();
    List<KilometerReportResponse> res = await _chartsApi.getDailyDrivenKm(
        clientId: clientId, period: selectedDurationValue);

    kmReportListData = copyList(res);

    kmReportListData.forEach((element) {
      totalKmG += element.drivenKm;
    });

    seriesBarData = [
      charts.Series(
        id: 'Total Kms: ' + totalKmG.toString(),
        data: kmReportListData,
        domainFn: (KilometerReportResponse series, _) => series.entryDate,
        measureFn: (KilometerReportResponse series, _) => series.drivenKm,
        colorFn: (KilometerReportResponse series, _) => series.barColor,
        labelAccessorFn: (KilometerReportResponse series, _) =>
            '${series.drivenKm.toString()}',
      ),
    ];

    notifyListeners();
  }
}
