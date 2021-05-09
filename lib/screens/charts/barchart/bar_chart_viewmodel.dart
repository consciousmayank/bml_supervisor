import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';

class BarChartViewModel extends GeneralisedBaseViewModel {
  ChartsApi _chartsApi = locator<ChartsApiImpl>();

  DateTime _selectedDate = DateTime.now();
  List<String> uniqueDates = [];
  List<TickSpec<num>> listOfTicks;

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  int _totalKmG = 0;

  int get totalKmG => _totalKmG;

  set totalKmG(int value) {
    _totalKmG = value;
  }

  String _chartDate;

  String get chartDate => _chartDate;

  set chartDate(String value) {
    _chartDate = value;
    notifyListeners();
  }

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

  Future getBarGraphKmReport({String clientId}) async {
    kmReportListData.clear();
    uniqueDates.clear();
    chartDate = '';

    // int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    notifyListeners();
    List<KilometerReportResponse> res =
        await _chartsApi.getDailyDrivenKm(clientId: clientId);

    kmReportListData = Utils().copyList(res);

    if (kmReportListData.length > 0) {
      kmReportListData.forEach((element) {
        totalKmG += element.drivenKm;
        if (!uniqueDates.contains(element.entryDate)) {
          uniqueDates.add(element.entryDate);
        }
      });
      if (uniqueDates.length > 0) {
        chartDate = uniqueDates.first;
      }

      seriesBarData = [
        charts.Series(
          id: 'Total Kms: ' + totalKmG.toString(),
          data: kmReportListData,
          insideLabelStyleAccessorFn: (KilometerReportResponse series, _) =>
              charts.TextStyleSpec(fontSize: 10, color: charts.Color.white),
          outsideLabelStyleAccessorFn: (KilometerReportResponse series, _) =>
              charts.TextStyleSpec(fontSize: 10, color: charts.Color.black),
          domainFn: (KilometerReportResponse series, _) =>
              series.entryDate.split('-')[0],
          measureFn: (KilometerReportResponse series, _) => series.drivenKm,
          colorFn: (KilometerReportResponse series, _) => series.barColor,
          labelAccessorFn: (KilometerReportResponse series, _) =>
              '${series.drivenKm.toString()}\nkm',
        ),
      ];
    }

    notifyListeners();
  }
}
