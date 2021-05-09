import 'dart:async';

import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/screens/charts/barchart/bar_chart_view.dart';
import 'package:bml_supervisor/screens/charts/expensepiechart/expenses_pie_chart_view.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_view.dart';
import 'package:bml_supervisor/screens/charts/piechart/pie_chart_view.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_view.dart';
import 'package:bml_supervisor/screens/dashboard/drawer/dashboard_drawer.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/widget/routes/routes_view.dart';
import 'package:flutter/material.dart';
import 'package:bml/bml.dart';
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
          viewModel.getUserProfile();
          viewModel.selectedClient = viewModel.preferences.getSelectedClient();
          viewModel.getClientDashboardStats();
          viewModel.getConsignmentTrackingStatus();
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
                      'Dashboard - ${StringUtils().capitalizeFirstLetter(word: viewModel.preferences.getSelectedClient().clientId)}',
                      style: AppTextStyles.whiteRegular,
                    ),
                    centerTitle: true,
                    actions: [
                      InkWell(
                        onTap: () {
                          viewModel.showClientSelectBottomSheet();

                          // viewModel.preferences.saveSelectedClient(null);
                          // viewModel.navigationService
                          //     .clearStackAndShow(clientSelectPageRoute);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            changeClient,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
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
                                  Utils().hSizedBox(5),

                                  viewModel.isGettingTripsStatus
                                      ? Container(
                                          height: 50,
                                          child: ShimmerContainer(
                                            itemCount: 1,
                                          ),
                                        )
                                      : NotificationTile(
                                          iconName: consignmentIcon,
                                          notificationTitle: 'Upcoming trips',
                                          taskNumber:
                                              viewModel?.upcomingTrips?.length,
                                          onTap: () {
                                            viewModel
                                                .takeToUpcomingTripsDetailsView(
                                              tripStatus: TripStatus.UPCOMING,
                                            );
                                          },
                                        ),

                                  viewModel.isGettingTripsStatus
                                      ? Container(
                                          height: 50,
                                          child: ShimmerContainer(
                                            itemCount: 1,
                                          ),
                                        )
                                      : NotificationTile(
                                          iconName: blueRouteIcon,
                                          notificationTitle: 'Ongoing Trips',
                                          taskNumber:
                                              viewModel?.ongoingTrips?.length,
                                          onTap: () {
                                            viewModel
                                                .takeToUpcomingTripsDetailsView(
                                              tripStatus: TripStatus.ONGOING,
                                            );
                                          },
                                        ),

                                  viewModel.isGettingTripsStatus
                                      ? Container(
                                          height: 50,
                                          child: ShimmerContainer(
                                            itemCount: 1,
                                          ),
                                        )
                                      : NotificationTile(
                                          iconName: completedTripsIcon,
                                          notificationTitle: 'Completed Trips',
                                          taskNumber:
                                              viewModel?.completedTrips?.length,
                                          onTap: () {
                                            viewModel
                                                .takeToUpcomingTripsDetailsView(
                                              tripStatus: TripStatus.COMPLETED,
                                            );
                                          },
                                        ),

                                  Utils().hSizedBox(3),
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
                                                percentage: viewModel
                                                    .singleClientTileData
                                                    .totalKmVariance,
                                                title: 'Total Kilometer',
                                                value: viewModel
                                                    .singleClientTileData
                                                    .totalKm
                                                    .toString(),
                                                iconName: totalKmIcon,
                                                onTap: () {
                                                  viewModel
                                                      .takeToViewEntryPage();
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: AppTiles(
                                                // percentage: 0,
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
                                                percentage: viewModel
                                                    .singleClientTileData
                                                    .totalExpenseVariance,
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
                                                // percentage: -5,
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

                                  ///Bar chart (Driven Kilometers)
                                  BarChartView(),

                                  ///Recent Driven Km Table
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Card(
                                      elevation: defaultElevation,
                                      child: ConsignmentListView(
                                        isFulPageView: false,
                                      ),
                                    ),
                                  ),

                                  ///line chart (Routes Driven Kilometers)
                                  LineChartView(
                                    clientId: viewModel.preferences
                                        .getSelectedClient()
                                        .clientId,
                                  ),

                                  /// Driven Km % pie chart
                                  PieChartView(
                                    // key: UniqueKey(),
                                    clientId: viewModel.preferences
                                        .getSelectedClient()
                                        .clientId,
                                  ),

                                  /// Expense Pie Chart
                                  ExpensesPieChartView(),

                                  //Route List
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Card(
                                      elevation: defaultElevation,
                                      child: RoutesView(
                                        // selectedClient: viewModel.selectedClient,
                                        onRoutesPageInView:
                                            (FetchRoutesResponse clickedRoute) {
                                          viewModel.takeToHubsView(
                                              clickedRoute: clickedRoute);
                                        },
                                        isInDashBoard: true,
                                        selectedClient: viewModel.preferences
                                            .getSelectedClient(),
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
}
