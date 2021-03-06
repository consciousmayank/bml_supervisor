import 'package:bml_supervisor/screens/charts/piechart/pie_chart_viewmodel.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dashboard_loading.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as axisMaterial;
import 'package:stacked/stacked.dart';

class PieChartView extends StatefulWidget {
  final int clientId;
  final String selectedDuration;

  const PieChartView({Key key, this.clientId, this.selectedDuration})
      : super(key: key);

  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PieChartViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getRoutesDrivenKmPercentage(
              clientId: widget.clientId,
            ),
        builder: (context, viewModel, child) {
          return viewModel.isBusy
              ? DashBoardLoadingWidget()
              : Card(
                  elevation: defaultElevation,
                  shape: getCardShape(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildChartTitle(title: 'Route Driven Kilometers (%)'),

                        if (viewModel.routesDrivenKmPercentageList.length > 0)

                          hSizedBox(3),
                        if (viewModel.routesDrivenKmPercentageList.length > 0)
                          Row(
                            children: [
                              buildChartBadge(badgeTitle: 'Top 3'),
                              wSizedBox(3),
                              viewModel.buildChartSubTitleNew(),
                            ],
                          ),
                        // buildChartSubTitle(time: viewModel?.selectedDate),
                        if (viewModel.routesDrivenKmPercentageList.length > 0)
                          hSizedBox(5),
                        viewModel.routesDrivenKmPercentageList.length > 0
                            ? SizedBox(
                                height: MediaQuery.of(context).size.width,
                                child: charts.PieChart(
                                  viewModel.seriesPieData,
                                  animate: true,
                                  animationDuration:
                                      Duration(milliseconds: 200),
                                  defaultRenderer: new charts.ArcRendererConfig(
                                    arcWidth: 80,
                                    arcRendererDecorators: [
                                      charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.auto,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : NoDataWidget(),
                        if (viewModel.routesDrivenKmPercentageList.length > 0)
                          hSizedBox(10),
                        // route label bottom positioned
                        if (viewModel.routesDrivenKmPercentageList.length > 0)
                          buildColorLegendListView(viewModel),
                      ],
                    ),
                  ),
                );
        },
        viewModelBuilder: () => PieChartViewModel());
  }

  Widget buildColorLegendListView(PieChartViewModel viewModel) {
    return Center(
      child: Wrap(
        direction: axisMaterial.Axis.horizontal,
        alignment: WrapAlignment.center,
        spacing: 2.0,
        runSpacing: 5.0,
        children: List.generate(
          viewModel.uniqueRoutes.length,
          (index) => Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  color: viewModel.pieChartsColorArray[index],
                ),
                wSizedBox(5),
                Text(
                    '#${viewModel.uniqueRoutes[index]}-${viewModel.getRouteTitle(index)}'),
                wSizedBox(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
