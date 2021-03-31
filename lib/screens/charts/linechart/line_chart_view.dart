import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_viewmodel.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dashboard_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as axisMaterial;
// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart' as axisTextStyle;
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class LineChartView extends StatefulWidget {
  final String clientId;
  final String selectedDuration;

  LineChartView({
     this.clientId,
     this.selectedDuration,
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
      createNewModelOnInsert: true,
      onModelReady: (viewModel) => viewModel.getRoutesDrivenKm(
        clientId: MyPreferences().getSelectedClient().clientId,
        selectedDuration: MyPreferences().getSelectedDuration(),
      ),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return DashBoardLoadingWidget();
        } else {
          return viewModel.routesDrivenKmListForLineChart.length > 0
              ? SizedBox(
                  height: 350,
                  child: Card(
                    color: AppColors.white,
                    elevation: defaultElevation,
                    shape: getCardShape(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildChartTitle(title: "Routes Driven Kilometers"),
                          // buildChartSubTitle(
                          //     time: viewModel?.selectedDateForLineChart),
                          buildChartSubTitleNew(
                              date: viewModel.chartDate),
                          Expanded(
                            child: BezierChart(
                              fromDate: viewModel.uniqueDatesForLineChart.first,
                              bezierChartScale: BezierChartScale.WEEKLY,
                              toDate: viewModel.uniqueDatesForLineChart.first ==
                                      viewModel.uniqueDatesForLineChart.last
                                  ? viewModel.uniqueDatesForLineChart.first
                                      .add(Duration(days: 1))
                                  : viewModel.uniqueDatesForLineChart.last,
                              onValueSelected: (value) {},
                              onIndicatorVisible: (val) {},
                              onDateTimeSelected: (datetime) {},
                              selectedDate:
                                  viewModel.uniqueDatesForLineChart.last,
                              //this is optional
                              footerDateTimeBuilder:
                                  (DateTime value, BezierChartScale scaleType) {
                                final newFormat = DateFormat('dd');
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
                                      NumberFormat("###,##0.00 kms", "en_US"),
                                  verticalIndicatorStrokeWidth: 1.0,
                                  verticalIndicatorColor: Colors.black,
                                  verticalLineFullHeight: true,
                                  showVerticalIndicator: true,
                                  verticalIndicatorFixedPosition: true,
                                  backgroundColor: Colors.transparent,
                                  footerHeight: 15),
                            ),
                          ),
                          buildChartDateLabel(),
                          hSizedBox(10),
                          Center(child: buildColorLegendListView(viewModel))
                        ],
                      ),
                    ),
                  ),
                )
              : Container();
        }
      },
      viewModelBuilder: () => LineChartViewModel(),
    );
  }
}

Widget buildColorLegendListView(LineChartViewModel viewModel) {
  // return ListView(children: getWidgets(viewModel), scrollDirection: axisMaterial.Axis.horizontal,);
  return Wrap(
    direction: axisMaterial.Axis.horizontal,
    alignment: WrapAlignment.center,
    spacing: 2.0,
    runSpacing: 5.0,
    children: List.generate(
      viewModel.dataForLineChart.length,
      (index) => Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 10,
              width: 10,
              color: viewModel.lineChartColorArray[index],
            ),
            wSizedBox(5),
            InkWell(
              onTap: () {
                // viewModel.snackBarService.showSnackbar(
                //     message: 'Removing route: ${viewModel.uniqueRoutes[index].toString()}');
                // viewModel.removeRoute(viewModel.uniqueRoutes[index], index);
              },
              child: Text(
                  '#${viewModel.uniqueRoutes[index]}-${viewModel.getRouteTitle(index)}'),
            ),
            wSizedBox(10),
          ],
        ),
      ),
    ),
  );
}

// class DrivenKmPerRoute {
//   String date;
//   int drivenKm;

//   DrivenKmPerRoute(this.date, this.drivenKm);
// }
