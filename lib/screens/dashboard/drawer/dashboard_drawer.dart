import 'package:flutter/material.dart';

import '../../../app_level/image_config.dart';
import '../dashboard_viewmodel.dart';
import 'package:bml/bml.dart';

class DashBoardDrawer extends StatefulWidget {
  final DashBoardScreenViewModel dashBoardScreenViewModel;

  const DashBoardDrawer({Key key, @required this.dashBoardScreenViewModel})
      : super(key: key);

  @override
  _DashBoardDrawerState createState() => _DashBoardDrawerState();
}

class _DashBoardDrawerState extends State<DashBoardDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.70,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.only(
              top: 10 + MediaQuery.of(context).padding.top,
              left: drawerContentPadding,
              right: drawerContentPadding,
              bottom: drawerContentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClickableWidget(
                childColor: AppColors.white,
                borderRadius: Utils().getBorderRadius(),
                onTap: () {
                  widget.dashBoardScreenViewModel.onUserProfileTileClicked();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ProfileImageWidget(
                          size: 60,
                          image: widget.dashBoardScreenViewModel.image),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.dashBoardScreenViewModel?.savedUser?.userName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.latoBold18Black.copyWith(
                                  color: AppColors.primaryColorShade5),
                            ),
                            Text(
                              '${widget.dashBoardScreenViewModel?.savedUser?.role}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.latoMedium16Primary5
                                  .copyWith(
                                      color: AppColors.primaryColorShade5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: AppColors.black,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DrawerListItem(
                        imageName: homeIcon,
                        text: "Dashboard",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onDashboardDrawerTileClicked();
                        },
                      ),
                      DrawerListItem(
                        imageName: totalKmIcon,
                        text: "Daily Kilometers",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onDailyKilometersDrawerTileClicked();
                        },
                      ),
                      DrawerListItem(
                        imageName: expensesIcon,
                        text: "Expenses",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onExpensesDrawerTileClicked();
                        },
                      ),
                      DrawerListItem(
                        imageName: expensesIcon,
                        text: "Consignment",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            imageName: consignmentIcon,
                            isSubMenu: true,
                            text: "Create",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAllotConsignmentsDrawerTileClicked();
                              widget.dashBoardScreenViewModel
                                  .changeConsignmentGroupVisibility();
                            },
                          ),
                          DrawerListItem(
                            imageName: consignmentListIcon,
                            isSubMenu: true,
                            text: "List",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onListConsignmentTileClick();
                              widget.dashBoardScreenViewModel
                                  .changeConsignmentGroupVisibility();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: review_consig_Icon,
                            text: "Review",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onPendingConsignmentsListDrawerTileClicked();
                              widget.dashBoardScreenViewModel
                                  .changeConsignmentGroupVisibility();
                            },
                          ),
                        ],
                      ),
                      DrawerListItem(
                        imageName: expensesIcon,
                        text: "Tracking",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: consignmentIcon,
                            text:
                                "Upcoming Trips (${widget?.dashBoardScreenViewModel?.upcomingTrips?.length ?? 0})",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .takeToUpcomingTripsDetailsView(
                                      tripStatus: TripStatus.UPCOMING);
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: consignmentListIcon,
                            text:
                                "OnGoing Trips (${widget?.dashBoardScreenViewModel?.ongoingTrips?.length ?? 0})",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .takeToUpcomingTripsDetailsView(
                                      tripStatus: TripStatus.ONGOING);
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: review_consig_Icon,
                            text:
                                "Completed Trips (${widget?.dashBoardScreenViewModel?.completedTrips?.length ?? 0})",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .takeToUpcomingTripsDetailsView(
                                      tripStatus: TripStatus.COMPLETED);
                            },
                          ),
                        ],
                      ),
                      DrawerListItem(
                        imageName: expensesIcon,
                        text: "Add",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            imageName: addDriverIcon,
                            isSubMenu: true,
                            text: "Driver",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddDriverDrawerTileClicked();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: addHubIcon,
                            text: "Hubs",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddHubTileClick();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: addRouteIcon,
                            text: "Route",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddRoutesTileClick();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: addRouteIcon,
                            text: "Vehicle",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddVehicleTileClick();
                            },
                          ),
                        ],
                      ),
                      DrawerListItem(
                        imageName: routesIcon,
                        text: "Routes List",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onViewRoutesDrawerTileClicked();
                        },
                      ),
                      DrawerListItem(
                        imageName: drawerRupeeIcon,
                        text: "Transaction History",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onTransactionsDrawerTileClicked();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
