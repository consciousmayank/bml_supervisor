import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
import 'package:bml_supervisor/screens/charts/piechart/pie_chart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:stacked/stacked.dart';

class PieChartView extends StatefulWidget {
  final int clientId;
  final String selectedDuration;

  PieChartView({
    @required this.clientId,
    @required this.selectedDuration,
  });

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  // @override
  // void initState() {
  //  // TODO: implement initState
  //   _seriesPieData = List<charts.Series<RoutesDrivenKmPercentage, String>>();
  //   _generateData();
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PieChartViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getRoutesDrivenKmPercentage(
              clientId: widget.clientId,
              period: widget.selectedDuration,
            ),
        builder: (context, viewModel, child) {
          return viewModel.routesDrivenKmPercentageList.length > 0
              ? SizedBox(
            height: 250,
                child: Card(
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
                              viewModel.seriesPieData,
                              animate: true,
                              animationDuration: Duration(milliseconds: 200),
                              behaviors: [
                                new charts.DatumLegend(
                                  outsideJustification:
                                      charts.OutsideJustification.middleDrawArea,
                                  horizontalFirst: true,
                                  // desiredMaxRows: 3,
                                  cellPadding: new EdgeInsets.only(
                                      right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts
                                          .MaterialPalette.purple.shadeDefault,
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
                  ),
              )
              : Container();
        },
        viewModelBuilder: () => PieChartViewModel());
  }
}
