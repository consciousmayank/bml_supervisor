import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_viewmodel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                height: 500,
                child: Card(
                  color: Colors.red,
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BezierChart(

                      fromDate: viewModel.uniqueDates.first,
                      bezierChartScale: BezierChartScale.WEEKLY,
                      toDate: viewModel.uniqueDates.last,
                      onIndicatorVisible: (val) {
                        print("Indicator Visible :$val");
                      },
                      onDateTimeSelected: (datetime) {
                        print("selected datetime: $datetime");
                      },
                      // selectedDate: toDate,
                      //this is optional
                      footerDateTimeBuilder:
                          (DateTime value, BezierChartScale scaleType) {
                        final newFormat = DateFormat('dd/MMM');
                        return newFormat.format(value);
                      },
                      bubbleLabelDateTimeBuilder:
                          (DateTime value, BezierChartScale scaleType) {
                        final newFormat = DateFormat('EEE d');
                        return "${newFormat.format(value)}\n";
                      },
                      series: viewModel.getBezierData(),
                      config: BezierChartConfig(
                        updatePositionOnTap: true,
                        bubbleIndicatorValueFormat:
                        NumberFormat("###,##0.00", "en_US"),
                        verticalIndicatorStrokeWidth: 1.0,
                        verticalIndicatorColor: Colors.white30,
                        showVerticalIndicator: true,
                        verticalIndicatorFixedPosition: false,
                        backgroundColor: Colors.transparent,
                        footerHeight: 40.0,
                      ),
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
