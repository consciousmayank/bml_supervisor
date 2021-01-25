import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class LineChartView extends StatefulWidget {
  final int clientId;
  final String selectedDuration;

  LineChartView({
    @required this.clientId,
    @required this.selectedDuration,
  });

  @override
  _LineChartViewState createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LineChartViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getRoutesDrivenKm(
        clientId: widget.clientId,
        selectedDuration: widget.selectedDuration,
      ),
      builder: (context, viewModel, child) {
        return viewModel.routesDrivenKmList.length > 0
            ? SizedBox(
          height: 300,
              child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Routes Driven Kms.'),
                        Expanded(
                          // child: charts.Line
                          child: charts.LineChart(
                            viewModel.seriesLineData,
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
                ),
            )
            : Container();
      },
      viewModelBuilder: () => LineChartViewModel(),
    );
  }
}

// class DrivenKmPerRoute {
//   String date;
//   int drivenKm;

//   DrivenKmPerRoute(this.date, this.drivenKm);
// }
