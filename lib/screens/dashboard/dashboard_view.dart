import 'dart:async';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/screens/charts/barchart/bar_chart_view.dart';
import 'package:bml_supervisor/screens/charts/expensepiechart/expenses_pie_chart_view.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_view.dart';
import 'package:bml_supervisor/screens/charts/piechart/pie_chart_view.dart';
import 'package:bml_supervisor/screens/dashboard/drawer/dashboard_drawer.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/routes/routes_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashBoardScreenView extends StatefulWidget {
  @override
  _DashBoardScreenViewState createState() => _DashBoardScreenViewState();
}

class _DashBoardScreenViewState extends State<DashBoardScreenView> {
  final UniqueKey scrollKey = UniqueKey();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashBoardScreenViewModel>.reactive(
        onModelReady: (viewModel) async {
          viewModel.selectedClient = MyPreferences().getSelectedClient();
          viewModel.getClientDashboardStats();
          viewModel.selectedDuration = MyPreferences().getSelectedDuration();
          // viewModel.getBarGraphKmReport(
          //   selectedDuration: viewModel.selectedDuration,
          // );
          viewModel.getSavedUser();
        },
        builder: (context, viewModel, child) => SafeArea(
              top: false,
              bottom: true,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Dashboard-${MyPreferences().getSelectedClient().clientId}',
                      style: AppTextStyles.whiteRegular,
                    ),
                    centerTitle: true,
                  ),
                  body: RefreshIndicator(
                    onRefresh: () {
                      final Completer<void> completer = Completer<void>();
                      Timer(const Duration(milliseconds: 200), () {
                        completer.complete();
                      });

                      return completer.future.then<void>((_) {
                        viewModel.reloadPage();
                      });
                    },
                    child: SingleChildScrollView(
                      key: scrollKey,
                      controller: scrollController,
                      child: viewModel.isBusy
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: ShimmerContainer(
                                itemCount: 20,
                              ),
                            )
                          : Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  hSizedBox(3),
                                  viewModel.singleClientTileData != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: AppTiles(
                                                title: 'Distributors',
                                                value: viewModel
                                                    .singleClientTileData
                                                    .hubCount
                                                    .toString(),
                                                iconName: distributorIcon,
                                                onTap: () {
                                                  viewModel
                                                      .takeToDistributorsPage();
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: AppTiles(
                                                title: 'Routes',
                                                value: viewModel
                                                    .singleClientTileData
                                                    .routeCount
                                                    .toString(),
                                                iconName: routesIcon,
                                                onTap: () {
                                                  viewModel
                                                      .takeToViewRoutesPage();
                                                },
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
                                              child: AppTiles(
                                                percentage: 10,
                                                title: 'Total Kilometer',
                                                value: viewModel
                                                    .singleClientTileData
                                                    .totalKm
                                                    .toString(),
                                                iconName: totalKmIcon,
                                                //todo: give percentage from API
                                                // percentage: 88,
                                                onTap: () {
                                                  viewModel
                                                      .takeToViewEntryPage();
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: AppTiles(
                                                percentage: 0,
                                                title: 'Due (km)',
                                                value: viewModel
                                                    .singleClientTileData.dueKm
                                                    .toString(),
                                                iconName: dueKmIcon,
                                                onTap: () {
                                                  viewModel
                                                      .takeToPaymentsPage();
                                                },
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
                                              child: AppTiles(
                                                percentage: 0,
                                                title: 'Total Expense',
                                                value: viewModel
                                                    .singleClientTileData
                                                    .totalExpense
                                                    .toString(),
                                                iconName: rupeesIcon,
                                                // percentage: -1,
                                                onTap: () {
                                                  viewModel
                                                      .takeToViewExpensePage();
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: AppTiles(
                                                percentage: -5,
                                                title: 'Due Expense',
                                                value: viewModel
                                                    .singleClientTileData
                                                    .dueExpense
                                                    .toString(),
                                                iconName: rupeesIcon,
                                                onTap: () {
                                                  viewModel
                                                      .takeToViewExpensePage();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),

                                  selectDuration(viewModel: viewModel),

                                  ///Bar chart
                                  BarChartView(),

                                  ///line chart
                                  LineChartView(
                                    clientId: MyPreferences().getSelectedClient().clientId,
                                    selectedDuration: MyPreferences().getSelectedDuration(),
                                  ),

                                  /// Driven Km pie chart
                                  PieChartView(
                                    // key: UniqueKey(),
                                    selectedDuration:
                                        viewModel.selectedDuration,
                                    clientId: MyPreferences()
                                        .getSelectedClient()
                                        .clientId,
                                  ),

                                  /// Expense Pie Chart
                                  ExpensesPieChartView(),

                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'Route List',
                                      style: AppTextStyles
                                          .latoBold14primaryColorShade6,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Card(
                                      elevation: defaultElevation,
                                      child: SizedBox(
                                        height: 450,
                                        child: RoutesView(
                                          // selectedClient: viewModel.selectedClient,
                                          onRoutesPageInView:
                                              (FetchRoutesResponse
                                                  clickedRoute) {
                                            viewModel.takeToHubsView(
                                                clickedRoute: clickedRoute);
                                          },
                                          isInDashBoard: true,
                                          selectedClient: MyPreferences()
                                              .getSelectedClient(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  drawer: DashBoardDrawer(
                    dashBoardScreenViewModel: viewModel,
                  )),
            ),
        viewModelBuilder: () => DashBoardScreenViewModel());
  }

  Widget selectDuration({DashBoardScreenViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: DefaultTabController(
          length: 2, // length of tabs
          initialIndex:
              viewModel.selectedDuration == selectDurationListDashBoard.first
                  ? 0
                  : 1,
          child: TabBar(
            onTap: (index) {
              String selectedValue = selectDurationListDashBoard[index];
              viewModel.selectedDuration = selectedValue;
              // viewModel.getBarGraphKmReport(selectedDuration: selectedValue);
              MyPreferences().saveSelectedDuration(selectedValue);
              viewModel.selectedDuration = selectedValue;
              viewModel.reloadPage();
            },
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: AppColors.primaryColorShade5,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.primaryColorShade5,
            tabs: [
              Tab(text: selectDurationListDashBoard.first),
              Tab(text: selectDurationListDashBoard.last),
            ],
          ),
        ),
      ),
    );
  }
}
