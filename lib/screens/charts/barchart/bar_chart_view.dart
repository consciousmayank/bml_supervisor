import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/screens/charts/barchart/bar_chart_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dashboard_loading.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BarChartView extends StatefulWidget {
  final String clientId;
  final String selectedDuration;

  BarChartView({
     this.clientId,
     this.selectedDuration,
  });

  @override
  _BarChartViewState createState() => _BarChartViewState();
}

class _BarChartViewState extends State<BarChartView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BarChartViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getBarGraphKmReport(
        clientId: MyPreferences().getSelectedClient().clientId,
      ),
      builder: (context, viewModel, child) {
        return viewModel.isBusy
            ? DashBoardLoadingWidget()
            : viewModel.kmReportListData.length > 0
                ? LimitedBox(
                    maxHeight: 350,
                    child: Card(
                      elevation: defaultElevation,
                      shape: getCardShape(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildChartTitle(title: "Driven Kilometers"),
                            // buildChartSubTitle(time: viewModel?.selectedDate),
                            buildChartSubTitleNew(
                                date: viewModel.chartDate),
                            hSizedBox(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  color: AppColors.primaryColorShade5,
                                ),
                                wSizedBox(10),
                                Text(
                                  "Driven km (Total: ${viewModel.totalKmG}, Avg: ${(viewModel.totalKmG / viewModel.kmReportListData.length).toStringAsFixed(0)})",
                                  style: AppTextStyles.latoBold12Black,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Expanded(
                              child: viewModel.kmReportListData.length > 0
                                  ? charts.BarChart(
                                      viewModel.seriesBarData,
                                      animate: true,
                                      domainAxis: charts.OrdinalAxisSpec(
                                        // renderSpec:
                                        //     charts.SmallTickRendererSpec(
                                        //         labelRotation: 60),
                                        viewport: charts.OrdinalViewport(
                                          widget.selectedDuration ==
                                                  'THIS MONTH REPORT'
                                              ? viewModel.uniqueDates.last
                                                  .split('-')[0]
                                              : '',
                                          7,
                                        ),
                                      ),
                                      barRendererDecorator: new charts
                                          .BarLabelDecorator<String>(),
                                      behaviors: [
                                        charts.ChartTitle('Kilometer',
                                            innerPadding: 1,
                                            outerPadding: 2,
                                            titleStyleSpec:
                                                charts.TextStyleSpec(
                                              fontSize: 14,
                                            ),
                                            behaviorPosition:
                                                charts.BehaviorPosition.start,
                                            titleOutsideJustification: charts
                                                .OutsideJustification.middle),
                                        charts.ChartTitle('Date',
                                            innerPadding: 1,
                                            outerPadding: 2,
                                            titleStyleSpec:
                                                charts.TextStyleSpec(
                                              fontSize: 14,
                                            ),
                                            behaviorPosition:
                                                charts.BehaviorPosition.bottom,
                                            titleOutsideJustification: charts
                                                .OutsideJustification.middle),
                                        charts.SlidingViewport(),
                                        charts.PanAndZoomBehavior(),
                                      ],
                                      primaryMeasureAxis:
                                          new charts.NumericAxisSpec(
                                        tickProviderSpec:
                                            //     StaticNumericTickProviderSpec(
                                            //   viewModel.listOfTicks,
                                            // ),
                                            BasicNumericTickProviderSpec(
                                          zeroBound: true,
                                          // desiredTickCount: 10,
                                          desiredMinTickCount: 10,
                                        ),
                                        //to show axis line
                                        showAxisLine: true,
                                        //to show labels
                                        renderSpec: charts.GridlineRendererSpec(
                                            labelStyle:
                                                new charts.TextStyleSpec(
                                              fontSize: 10,
                                              color:
                                                  charts.MaterialPalette.black,
                                            ),
                                            lineStyle: charts.LineStyleSpec(
                                              color: charts.MaterialPalette.gray
                                                  .shadeDefault,
                                            )),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container();
      },
      viewModelBuilder: () => BarChartViewModel(),
    );
  }
}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//! Custom Horizontal scroll ---
// return Card(
//   elevation: 6,
//   child: SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "Kilometers Report",
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           SizedBox(
//             height: 200,
//             width: MediaQuery.of(context).size.width,
//             child: charts.BarChart(
//               series,
//               animate: true,
//               domainAxis: charts.OrdinalAxisSpec(
//                 renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
//               ),
//               barRendererDecorator: new charts.BarLabelDecorator<String>(),
//             ),
//           )
//         ],
//       ),
//     ),
//   ),
// );
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
