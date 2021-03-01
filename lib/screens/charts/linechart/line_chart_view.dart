import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_viewmodel.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dashboard_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/basic_types.dart' as scrollDirection;
import 'package:flutter/src/painting/text_style.dart' as axisTextStyle;
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class LineChartView extends StatefulWidget {
  final String clientId;
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
        if (viewModel.isBusy) {
          return DashBoardLoadingWidget();
        } else {
          return viewModel.routesDrivenKmList.length > 0
              ? SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      Card(
                        color: AppColors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BezierChart(
                            fromDate: viewModel.uniqueDates.first,
                            bezierChartScale: BezierChartScale.WEEKLY,
                            toDate: viewModel.uniqueDates.first ==
                                    viewModel.uniqueDates.last
                                ? viewModel.uniqueDates.first
                                    .add(Duration(days: 1))
                                : viewModel.uniqueDates.last,
                            onValueSelected: (value) {
                              print("Indicator Visible :$value");
                            },
                            onIndicatorVisible: (val) {
                              print("Indicator Visible :$val");
                            },
                            onDateTimeSelected: (datetime) {
                              print("selected datetime: $datetime");
                            },
                            selectedDate: viewModel.uniqueDates.last,
                            //this is optional
                            footerDateTimeBuilder:
                                (DateTime value, BezierChartScale scaleType) {
                              final newFormat = DateFormat('dd/MM/yy');
                              return newFormat.format(value);
                            },
                            bubbleLabelDateTimeBuilder:
                                (DateTime value, BezierChartScale scaleType) {
                              final newFormat = DateFormat('EEE d');
                              return "${newFormat.format(value)}\n";
                            },
                            series: viewModel.getBezierData(),
                            config: BezierChartConfig(
                              xLinesColor: Colors.red,
                              pinchZoom: false,
                              showDataPoints: true,
                              displayYAxis: true,
                              yAxisTextStyle: axisTextStyle.TextStyle(
                                  fontSize: 12, color: Colors.black),
                              xAxisTextStyle: axisTextStyle.TextStyle(
                                  fontSize: 10, color: Colors.black),
                              displayLinesXAxis: true,
                              stepsYAxis: 50,
                              startYAxisFromNonZeroValue: false,
                              updatePositionOnTap: true,
                              bubbleIndicatorValueFormat:
                                  NumberFormat("###,##0.00", "en_US"),
                              verticalIndicatorStrokeWidth: 1.0,
                              verticalIndicatorColor: Colors.black,
                              verticalLineFullHeight: true,
                              showVerticalIndicator: true,
                              verticalIndicatorFixedPosition: true,
                              backgroundColor: Colors.transparent,
                              footerHeight: 10.0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 1,
                        right: 1,
                        child: SizedBox(
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                              itemCount: viewModel.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 20,
                                        color: viewModel
                                            .lineChartColorArray[index],
                                      ),
                                      wSizedBox(2),
                                      Text(
                                          'Route#${viewModel.uniqueRoutes[index]}'),
                                      wSizedBox(10),
                                    ],
                                  ),
                                );
                              },
                              scrollDirection: scrollDirection.Axis.horizontal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container();
        }
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
