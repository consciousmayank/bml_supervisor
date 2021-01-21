import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DashboardKmBarChart extends StatelessWidget {
  final List<KilometerReportResponse> kmReportListData;

  DashboardKmBarChart({@required this.kmReportListData});
  @override
  Widget build(BuildContext context) {
    print(
        'bar chart class: no. of bars -------------${kmReportListData.length}');
    List<charts.Series<KilometerReportResponse, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: kmReportListData,
          domainFn: (KilometerReportResponse series, _) =>
              series.entryDate.substring(0, 2) + '-Jan',
          measureFn: (KilometerReportResponse series, _) =>
              int.parse(series.drivenKm),
          colorFn: (KilometerReportResponse series, _) => series.barColor,
          labelAccessorFn: (KilometerReportResponse series, _) =>
              '${series.drivenKm.toString()}'),
    ];

    return Container(
      height: 250,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Kilometers Report",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
                  ),
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
