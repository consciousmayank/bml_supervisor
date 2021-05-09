import 'package:bml_supervisor/screens/charts/piechart/pie_chart_viewmodel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as axisMaterial;
import 'package:stacked/stacked.dart';
import 'package:bml/bml.dart';

class PieChartView extends StatefulWidget {
  final String clientId;

  PieChartView({
    @required this.clientId,
  });

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
                  shape: Utils().getCardShape(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Utils().buildChartTitle(
                            title: 'Route Driven Kilometers (%)'),
                        if (viewModel.routesDrivenKmPercentageList.length > 0)
                          viewModel.buildChartSubTitleNew(),
                        // buildChartSubTitle(time: viewModel?.selectedDate),
                        if (viewModel.routesDrivenKmPercentageList.length > 0)
                          Utils().hSizedBox(5),
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
                          Utils().hSizedBox(10),
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
                Utils().wSizedBox(5),
                Text(
                    '#${viewModel.uniqueRoutes[index]}-${viewModel.getRouteTitle(index)}'),
                Utils().wSizedBox(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
