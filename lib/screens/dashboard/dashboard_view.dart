import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/charts/barchart/bar_chart_view.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_view.dart';
import 'package:bml_supervisor/screens/charts/piechart/pie_chart_view.dart';
import 'package:bml_supervisor/screens/dashboard/drawer/dashboard_drawer.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:bml_supervisor/widget/routes/routes_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashBoardScreenView extends StatefulWidget {
  @override
  _DashBoardScreenViewState createState() => _DashBoardScreenViewState();
}

class _DashBoardScreenViewState extends State<DashBoardScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashBoardScreenViewModel>.reactive(
        onModelReady: (viewModel) async {
          viewModel.selectedDuration = MyPreferences().getSelectedDuration();
          viewModel.getClients();
          viewModel.getSavedUser();
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "BookMyLoading",
                style: AppTextStyles.appBarTitleStyle,
              ),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: selectClientForDashboardStats(
                                      viewModel: viewModel),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: selectDuration(viewModel: viewModel),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          viewModel.singleClientTileData != null
                              ? makeTiles(viewModel: viewModel)
                              : Container(),
                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? BarChartView(
                                  clientId: viewModel.selectedClient.clientId,
                                  selectedDuration: viewModel.selectedDuration,
                                )
                              : Container(),
                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? LineChartView(
                                  clientId: viewModel.selectedClient.clientId,
                                  selectedDuration: viewModel.selectedDuration,
                                )
                              : Container(),
                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? PieChartView(
                                  clientId: viewModel.selectedClient.clientId,
                                  selectedDuration: viewModel.selectedDuration,
                                )
                              : Container(),
                          viewModel.selectedClient == null
                              ? Container()
                              : Card(
                                  elevation: defaultElevation,
                                  shape: getCardShape(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Routes"),
                                      ),
                                      SizedBox(
                                        height: 450,
                                        child: RoutesView(
                                          selectedClient:
                                              viewModel.selectedClient,
                                          onRoutesPageInView: (clickedRoute) {
                                            // FetchRoutesResponse route = clickedRoute;
                                            // viewModel.selectedRoute = route;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      )),
            drawer: DashBoardDrawer(
              dashBoardScreenViewModel: viewModel,
            ),
          );
        },
        viewModelBuilder: () => DashBoardScreenViewModel());
  }

  Widget selectDuration({DashBoardScreenViewModel viewModel}) {
    return AppDropDown(
      optionList: selectDurationList,
      hint: "Select Duration",
      onOptionSelect: (selectedValue) {
        viewModel.selectedDuration = selectedValue;
        //!call recent consignment api here
        // viewModel.getRecentConsignments(
        //   clientId: viewModel.selectedClient.clientId,
        //   period: viewModel.selectedDuration,
        // );
        viewModel.getClientDashboardStats();
        MyPreferences().saveSelectedDuration(selectedValue);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
    );
  }

  Widget buildDashboradTileCard({
    String title,
    String value,
    DashBoardScreenViewModel viewModel,
    Color color,
  }) {
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
        viewModel.selectedClient = selectedValue;
        print(
          viewModel.clientsList.indexOf(selectedValue),
        );
        MyPreferences().saveSelectedClient(selectedValue);

        //* call client tiles data
        viewModel.getClientDashboardStats();
        // viewModel.getRecentConsignments(
        //   clientId: viewModel.selectedClient.clientId,
        //   period: viewModel.selectedDuration,
        // );
      },
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }

  makeTiles({@required DashBoardScreenViewModel viewModel}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppTiles(
                  onTap: () {
                    viewModel.takeToDistributorsPage();
                  },
                  title: 'Distributors',
                  value: viewModel.singleClientTileData.hubCount.toString(),
                  iconName: distributorIcon),
            ),
            Expanded(
              flex: 1,
              child: AppTiles(
                  onTap: () {
                    viewModel.takeToViewRoutesPage();
                  },
                  title: 'Routes',
                  value: viewModel.singleClientTileData.routeCount.toString(),
                  iconName: routesIcon),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppTiles(
                  onTap: () {
                    viewModel.takeToViewEntryPage();
                  },
                  title: 'Total Kilometer',
                  value: viewModel.singleClientTileData.totalKm.toString(),
                  iconName: totalKmIcon),
            ),
            Expanded(
              flex: 1,
              child: AppTiles(
                  title: 'Due(Km)',
                  value: viewModel.singleClientTileData.dueKm.toString(),
                  iconName: dueKmIcon),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppTiles(
                  title: 'Total Expense',
                  value: viewModel.singleClientTileData.totalExpense.toString(),
                  iconName: expensesIcon),
            ),
            Expanded(
              flex: 1,
              child: AppTiles(
                  onTap: () {
                    viewModel.takeToPaymentsPage();
                  },
                  title: 'Due Expense',
                  value: viewModel.singleClientTileData.dueExpense.toString(),
                  iconName: rupeesIcon),
            ),
          ],
        )
      ],
    );
  }
}
