import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'dashboard_viewmodel.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/screens/charts/dashboradcharts/dashboard_km_bar_chart.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashBoardScreenView extends StatefulWidget {
  @override
  _DashBoardScreenViewState createState() => _DashBoardScreenViewState();
}

class _DashBoardScreenViewState extends State<DashBoardScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashBoardScreenViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getClients(),
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text("Welcome, Rahul Rautela"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: viewModel.isBusy
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          selectClientForDashboardStats(viewModel: viewModel),
                          selectDuration(viewModel: viewModel),
                          viewModel.singleClientTileData != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                          title: 'DISTRIBUTERS',
                                          value: viewModel
                                              .singleClientTileData.hubCount
                                              .toString(),
                                          viewModel: viewModel,
                                          color:
                                              getDashboardDistributerTileBgColor()),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                        title: 'TOTAL KILOMETER',
                                        value: viewModel
                                            .singleClientTileData.kmCount
                                            .toString(),
                                        viewModel: viewModel,
                                        color: getDashboardTotalKmTileBgColor(),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          viewModel.singleClientTileData != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                        title: 'ROUTES',
                                        value: viewModel
                                            .singleClientTileData.routeCount
                                            .toString(),
                                        viewModel: viewModel,
                                        color: getDashboardRoutesTileBgColor(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                        title: 'DUE (KM)',
                                        value: viewModel
                                            .singleClientTileData.dueCount
                                            .toString(),
                                        viewModel: viewModel,
                                        color: getDashboardDueKmTileBgColor(),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          hSizedBox(10),
                          viewModel.kmReportListData.length > 0
                              ? DashboardKmBarChart(
                                  kmReportListData: viewModel.kmReportListData,
                                )
                              : Container(),
                          hSizedBox(10),
                          Container(
                            height: 450,
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: List.generate(7, (index) {
                                return getOptions(
                                    context: context,
                                    position: index,
                                    viewModel: viewModel);
                              }),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
        viewModelBuilder: () => DashBoardScreenViewModel());
  }

  buildBarChart(DashBoardScreenViewModel viewModel) {
    List<charts.Series<KilometerReportResponse, String>> series = [
      charts.Series(
        id: "kilometerReport",
        data: viewModel.kmReportListData,
        domainFn: (KilometerReportResponse series, _) => series.entryDate,
        measureFn: (KilometerReportResponse series, _) =>
            int.parse(series.drivenKm),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      )
    ];
    //!Build Bar Graph
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "kilometers Report",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  domainAxis: charts.OrdinalAxisSpec(
                      renderSpec:
                          charts.SmallTickRendererSpec(labelRotation: 60)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectDuration({DashBoardScreenViewModel viewModel}) {
    return AppDropDown(
      optionList: selectDurationList,
      hint: "Select Duration",
      onOptionSelect: (selectedValue) {
        print('1. duration selected');
        viewModel.selectedDuration = selectedValue;
        // viewModel.isShowBarChart = true;
        viewModel.getBarGraphKmReport(viewModel.selectedDuration);
        print(viewModel.selectedDuration);
        //* call graph
        // buildBarChart(viewModel);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
    );
  }

  Widget buildDashboradTileCard(
      {String title,
      String value,
      DashBoardScreenViewModel viewModel,
      Color color}) {
    return Card(
      color: color,
      elevation: 6,
      child: Padding(
        padding: getDashboradTilesVerticlePadding(),
        child: Column(
          children: [
            Text(
              title,
              style:
                  TextStyle(color: getDashboardTileTextColor(), fontSize: 14),
            ),
            Text(
              value,
              style:
                  TextStyle(color: getDashboardTileTextColor(), fontSize: 20),
            ), //! make it dynamic
          ],
        ),
      ),
    );
  }

  Widget selectClientForDashboardStats({DashBoardScreenViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClientForTiles = selectedValue;

        //* call client tiles data

        viewModel.getDashboardTilesStats(
            viewModel.selectedClientForTiles.id.toString());

        viewModel.getRecentConsignments();
      },
      selectedValue: viewModel.selectedClientForTiles == null
          ? null
          : viewModel.selectedClientForTiles,
    );
  }

  Widget getOptions(
      {BuildContext context,
      int position,
      DashBoardScreenViewModel viewModel}) {
    return Container(
      child: InkWell(
        onTap: () => handleOptionClick(
            context: context, position: position, viewModel: viewModel),
        child: Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                viewModel.optionsIcons[position],
                size: 48,
              ),
              Text(viewModel.optionsTitle[position]),
            ],
          ),
        ),
      ),
    );
  }

  handleOptionClick(
      {BuildContext context,
      int position,
      DashBoardScreenViewModel viewModel}) {
    switch (position) {
      case 0:
        return viewModel.takeToAddEntryPage();
        break;
      case 1:
        return viewModel.takeToViewEntryPage();
        break;
      case 2:
        return viewModel.takeToAddExpensePage();
        break;
      case 3:
        return viewModel.takeToViewExpensePage();
        break;
      case 4:
        return viewModel.takeToAllotConsignmentsPage();
        break;
      case 5:
        return viewModel.takeToViewRoutesPage();
        return viewModel.takeToViewConsignmentsPage();
        break;
      case 6:
        return viewModel.takeToPaymentsPage();
        break;
      // case 6:
      //   return viewModel.takeToAddEntry2PointOPage();
      //   break;
      // case 7:
      //   return viewModel.takeToViewEntry2PointOPage();
      //   break;
      default:
        return viewModel.takeToBlankPage();
    }
  }
}

class ClientsDropDown extends StatefulWidget {
  final List<GetClientsResponse> optionList;
  final GetClientsResponse selectedValue;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  ClientsDropDown({
    @required this.optionList,
    this.selectedValue,
    @required this.hint,
    @required this.onOptionSelect,
    this.showUnderLine = true,
  });

  @override
  _ClientsDropDownState createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  List<DropdownMenuItem<GetClientsResponse>> dropdown = [];

  List<DropdownMenuItem<GetClientsResponse>> getDropDownItems() {
    List<DropdownMenuItem<GetClientsResponse>> dropdown =
        List<DropdownMenuItem<GetClientsResponse>>();

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].title}",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        value: widget.optionList[i],
      ));
    }
    return dropdown;
  }

  @override
  Widget build(BuildContext context) {
    return widget.optionList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.hint ?? ""),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: DropdownButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: ThemeConfiguration.primaryBackground,
                      ),
                    ),
                    underline: Container(),
                    isExpanded: true,
                    style: textFieldStyle(
                        fontSize: 15.0, textColor: Colors.black54),
                    value: widget.selectedValue,
                    items: getDropDownItems(),
                    onChanged: (value) {
                      widget.onOptionSelect(value);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  TextStyle textFieldStyle({double fontSize, Color textColor}) {
    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal);
  }
}
