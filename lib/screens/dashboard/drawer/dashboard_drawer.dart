import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/drawerlistitem/drawer_list_item.dart';
import 'package:bml_supervisor/widget/user_profile_image.dart';
import 'package:flutter/material.dart';

import '../../../app_level/colors.dart';
import '../../../app_level/image_config.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/dimens.dart';
import '../dashboard_viewmodel.dart';

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
                borderRadius: getBorderRadius(),
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
                              '${widget.dashBoardScreenViewModel?.savedUser?.designation}',
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
                        text: "Daily Kilometer",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onDailyKilometersDrawerTileClicked();
                        },
                      ),
                      DrawerListItem(
                        imageName: expensesIcon,
                        text: "Expense",
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
                            imageName: reviewConsigIcon,
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
                      if (widget.dashBoardScreenViewModel
                              .consignmentTrackingStatistics !=
                          null)
                        DrawerListItem(
                          imageName: expensesIcon,
                          text: "Tracking",
                          onTap: () {},
                          children: [
                            DrawerListItem(
                              isSubMenu: true,
                              imageName: consignmentIcon,
                              text:
                                  "Upcoming Trips (${widget.dashBoardScreenViewModel.consignmentTrackingStatistics.created})",
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
                                  "OnGoing Trips (${widget.dashBoardScreenViewModel.consignmentTrackingStatistics.ongoing})",
                              onTap: () {
                                widget.dashBoardScreenViewModel
                                    .takeToUpcomingTripsDetailsView(
                                        tripStatus: TripStatus.ONGOING);
                              },
                            ),
                            DrawerListItem(
                              isSubMenu: true,
                              imageName: reviewConsigIcon,
                              text:
                                  "Completed Trips (${widget.dashBoardScreenViewModel.consignmentTrackingStatistics.completed + widget.dashBoardScreenViewModel.consignmentTrackingStatistics.approved})",
                              onTap: () {
                                widget.dashBoardScreenViewModel
                                    .takeToUpcomingTripsDetailsView(
                                        tripStatus: TripStatus.COMPLETED);
                              },
                            ),
                          ],
                        ),
                      DrawerListItem(
                        imageName: vehicleIcon,
                        text: "Vehicle",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            imageName: addIcon,
                            isSubMenu: true,
                            text: "Add",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddVehicleTileClick();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: viewIcon,
                            text: "List",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onViewVehicleTileClick();
                            },
                          ),
                        ],
                      ),
                      DrawerListItem(
                        imageName: driverIcon,
                        text: "Driver",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            imageName: addIcon,
                            isSubMenu: true,
                            text: "Add",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddDriverDrawerTileClicked();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: viewIcon,
                            text: "List",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onViewDriverTileClick();
                            },
                          ),
                        ],
                      ),
                      DrawerListItem(
                        imageName: routesIcon,
                        text: "Route",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: addIcon,
                            text: "Add",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddRoutesTileClick();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: viewIcon,
                            text: "List",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onViewRoutesDrawerTileClicked();
                            },
                          ),
                        ],
                      ),
                      DrawerListItem(
                        imageName: addHubIcon,
                        text: "Hub",
                        onTap: () {},
                        children: [
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: addIcon,
                            text: "Add",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddHubTileClick();
                            },
                          ),
                          DrawerListItem(
                            isSubMenu: true,
                            imageName: viewIcon,
                            text: "List",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onViewHubsListDrawerTileClicked();
                            },
                          ),
                        ],
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
