import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:dio/dio.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartViewModel extends GeneralisedBaseViewModel {
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

  Future getBarGraphKmReport({int clientId, String selectedDuration}) async {
    kmReportListData.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    notifyListeners();
    try {
      final res = await apiService.getTotalDrivenKmStats(
          client: clientId, period: selectedDurationValue);
      if (res.statusCode == 200) {
        if (res is String) {
          snackBarService.showSnackbar(message: res.toString());
        }
        if (res.data is List) {
          var list = res.data as List;
          if (list.length > 0) {
            for (Map singleDay in list) {
              KilometerReportResponse singleDayReport =
                  KilometerReportResponse.fromJson(singleDay);
              kmReportListData.add(singleDayReport);
              totalKmG += double.parse(singleDayReport.drivenKm);
            }
            // add response list to chart data
            seriesBarData = [
              charts.Series(
                id: 'Total Kms: ' + totalKmG.toString(),
                data: kmReportListData,
                domainFn: (KilometerReportResponse series, _) =>
                    series.entryDate,
                measureFn: (KilometerReportResponse series, _) =>
                    int.parse(series.drivenKm),
                colorFn: (KilometerReportResponse series, _) => series.barColor,
                labelAccessorFn: (KilometerReportResponse series, _) =>
                    '${series.drivenKm.toString()}',
              ),
            ];
            notifyListeners();
          }
        }
      }
      notifyListeners();
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
  }
}
