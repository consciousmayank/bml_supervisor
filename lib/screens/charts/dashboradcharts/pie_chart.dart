import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatefulWidget {
  final List<RoutesDrivenKmPercentage> routesDrivenKmPercentageList;
  final double totalDrivenKmG;

  PieChart({this.routesDrivenKmPercentageList, this.totalDrivenKmG});

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<RoutesDrivenKmPercentage, String>> _seriesPieData;
  _generateData() {
    _seriesPieData.add(
      charts.Series(
        domainFn: (RoutesDrivenKmPercentage task, _) =>
            'R' + task.routeId.toString(),
        measureFn: (RoutesDrivenKmPercentage task, _) => task.drivenKmG,
        colorFn: (RoutesDrivenKmPercentage task, _) =>
            charts.ColorUtil.fromDartColor(task.color),
        id: 'route percentage',
        data: widget.routesDrivenKmPercentageList,
        labelAccessorFn: (RoutesDrivenKmPercentage task, _) =>
            '${((task.drivenKmG / widget.totalDrivenKmG) * 100).toStringAsFixed(2)}%'
                .toString(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _seriesPieData = List<charts.Series<RoutesDrivenKmPercentage, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Routes Driven Km (%)',
              // style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3.0,
            ),
            Expanded(
              child: charts.PieChart(
                _seriesPieData,
                animate: true,
                animationDuration: Duration(milliseconds: 200),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                    horizontalFirst: true,
                    // desiredMaxRows: 3,
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 11),
                  )
                ],
                defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 50,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
