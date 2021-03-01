import 'package:bml_supervisor/screens/charts/barchart/bar_chart_viewmodel.dart';
import 'package:bml_supervisor/widget/dashboard_loading.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BarChartView extends StatefulWidget {
  final String clientId;
  final String selectedDuration;

  BarChartView({
    @required this.clientId,
    @required this.selectedDuration,
  });

  @override
  _BarChartViewState createState() => _BarChartViewState();
}

class _BarChartViewState extends State<BarChartView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BarChartViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getBarGraphKmReport(
        clientId: widget.clientId,
        selectedDuration: widget.selectedDuration,
      ),
      builder: (context, viewModel, child) {
        return viewModel.isBusy
            ? DashBoardLoadingWidget()
            : viewModel.kmReportListData.length > 0
                ? Container(
                    height: 250,
                    // width: 200,
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Text(
                            //   "Kilometers Report",
                            //   style: Theme.of(context).textTheme.bodyText1,
                            // ),
                            Expanded(
                              child: viewModel.kmReportListData.length > 0
                                  ? charts.BarChart(
                                      viewModel.seriesBarData,
                                      animate: true,
                                      domainAxis: charts.OrdinalAxisSpec(
                                        renderSpec:
                                            charts.SmallTickRendererSpec(
                                                labelRotation: 60),
                                        viewport: charts.OrdinalViewport(
                                          viewModel
                                              .kmReportListData[0].entryDate,
                                          7,
                                        ),
                                      ),
                                      barRendererDecorator: new charts
                                          .BarLabelDecorator<String>(),
                                      behaviors: [
                                        charts.SeriesLegend(
                                          position: charts.BehaviorPosition.top,
                                        ),
                                        charts.SlidingViewport(),
                                        charts.PanAndZoomBehavior(),
                                      ],
                                    )
                                  : Container(),
                            )
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
