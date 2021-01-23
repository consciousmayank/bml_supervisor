import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LineChart extends StatefulWidget {
  final List<List<RoutesDrivenKm>> data;
  final List<Color> colorArray;

  const LineChart({this.data, this.colorArray});
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<charts.Series<RoutesDrivenKm, int>> _seriesLineData;

  _generateData() {
    var route_1 = widget.data[0];
    var route_2 = widget.data[1];
    var route_3 = widget.data[2];
    var route_4 = widget.data[3];
    var route_5 = widget.data[4];

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(widget.colorArray[0]),
        id: 'Route 1',
        data: route_1,
        domainFn: (RoutesDrivenKm sales, _) =>
            int.parse(sales.entryDate.split('-')[0]),
        measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(widget.colorArray[1]),
        id: 'Route 2',
        data: route_2,
        domainFn: (RoutesDrivenKm sales, _) =>
            int.parse(sales.entryDate.split('-')[0]),
        measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(widget.colorArray[2]),
        id: 'Route 3',
        data: route_3,
        domainFn: (RoutesDrivenKm sales, _) =>
            int.parse(sales.entryDate.split('-')[0]),
        measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(widget.colorArray[3]),
        id: 'Route 4',
        data: route_4,
        domainFn: (RoutesDrivenKm sales, _) =>
            int.parse(sales.entryDate.split('-')[0]),
        measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(widget.colorArray[4]),
        id: 'Route 5',
        data: route_5,
        domainFn: (RoutesDrivenKm sales, _) =>
            int.parse(sales.entryDate.split('-')[0]),
        measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<RoutesDrivenKm, int>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('sales for 5 years'),
            Expanded(
              // child: charts.Line
              child: charts.LineChart(
                _seriesLineData,
                defaultRenderer: new charts.LineRendererConfig(
                    includeArea: false, stacked: false),
                animate: true,
                animationDuration: Duration(milliseconds: 200),
                behaviors: [
                  new charts.ChartTitle(
                    'Date',
                    behaviorPosition: charts.BehaviorPosition.bottom,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                  ),
                  new charts.ChartTitle(
                    'Driven Km',
                    behaviorPosition: charts.BehaviorPosition.start,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class DrivenKmPerRoute {
//   String date;
//   int drivenKm;

//   DrivenKmPerRoute(this.date, this.drivenKm);
// }
