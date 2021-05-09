import 'package:bml_supervisor/screens/charts/expensepiechart/expenses_pie_chart_viewmodel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as axisMaterial;
import 'package:bml/bml.dart';

class ExpensesPieChartView extends StatefulWidget {
  final String selectedDuration;

  const ExpensesPieChartView({Key key, this.selectedDuration})
      : super(key: key);

  @override
  _ExpensesPieChartViewState createState() => _ExpensesPieChartViewState();
}

class _ExpensesPieChartViewState extends State<ExpensesPieChartView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExpensesPieChartViewModel>.reactive(
        // createNewModelOnInsert: true,
        onModelReady: (viewModel) {
          viewModel.getExpensesListForPieChart(
            clientId: viewModel.preferences.getSelectedClient().clientId,
          );
        },
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
                        Utils().buildChartTitle(title: 'Expenses'),
                        // buildChartSubTitle(time: viewModel?.selectedDate),
                        if (viewModel.expensePieChartResponseList.length > 0)
                          viewModel.buildChartSubTitleNew(),
                        if (viewModel.expensePieChartResponseList.length > 0)
                          Utils().hSizedBox(5),
                        // Text(viewModel.expensePieChartResponseList[0].vehicleId),
                        viewModel.expensePieChartResponseList.length > 0
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.87,
                                child: charts.PieChart(
                                  viewModel.expenseSeriesPieData,
                                  animate: true,
                                  animationDuration:
                                      Duration(milliseconds: 200),
                                  // behaviors: [
                                  //   charts.DatumLegend(
                                  //     outsideJustification: charts
                                  //         .OutsideJustification.middleDrawArea,
                                  //     horizontalFirst: true,
                                  //     // desiredMaxRows: 2,
                                  //     cellPadding: EdgeInsets.all(2),
                                  //     entryTextStyle: charts.TextStyleSpec(
                                  //         // color: charts.MaterialPalette.blue.shadeDefault,
                                  //         // fontFamily: 'Georgia',
                                  //         fontSize: 14),
                                  //   )
                                  // ],
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
                        if (viewModel.expensePieChartResponseList.length > 0)
                          Utils().hSizedBox(10),
                        // route label bottom positioned
                        if (viewModel.expensePieChartResponseList.length > 0)
                          buildColorLegendListView(viewModel)
                      ],
                    ),
                  ),
                );
        },
        viewModelBuilder: () => ExpensesPieChartViewModel());
  }

  Widget buildColorLegendListView(ExpensesPieChartViewModel viewModel) {
    return Center(
      child: Wrap(
        direction: axisMaterial.Axis.horizontal,
        alignment: WrapAlignment.center,
        spacing: 2.0,
        runSpacing: 5.0,
        children: List.generate(
          viewModel.uniqueExpenseTypes.length,
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
                Text('${viewModel.uniqueExpenseTypes[index]}'),
                Utils().wSizedBox(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
