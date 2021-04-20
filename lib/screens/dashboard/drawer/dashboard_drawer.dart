import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
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
    return Container(
      height: double.infinity,
      color: AppColors.white,
      width: MediaQuery.of(context).size.width * 0.70,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 10 + MediaQuery.of(context).padding.top,
              left: drawerContentPadding,
              right: drawerContentPadding,
              bottom: drawerContentPadding),
          child: Column(
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
              ExpansionPanelList.radio(
                expandedHeaderPadding: EdgeInsets.all(0),
                elevation: 0,
                children: [
                  ExpansionPanelRadio(
                    value: 1,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return drawerList(
                        imageName: homeIcon,
                        text: "Dashboard",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onDashboardDrawerTileClicked();
                        },
                      );
                    },
                    body: Container(),
                  ),
                  ExpansionPanelRadio(
                    value: 3,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return drawerList(
                        imageName: totalKmIcon,
                        text: "Daily Kilometers",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onDailyKilometersDrawerTileClicked();
                        },
                      );
                    },
                    body: Container(),
                  ),
                  ExpansionPanelRadio(
                    value: 4,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return drawerList(
                        imageName: expensesIcon,
                        text: "Expenses",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onExpensesDrawerTileClicked();
                        },
                      );
                    },
                    body: Container(),
                  ),
                  ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: 5,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            IconBlueBackground(
                              iconName: consignmentIcon,
                            ),
                            wSizedBox(20),
                            Expanded(
                              child: Text(
                                'Consignment',
                                style: AppTextStyles.latoMedium12Black.copyWith(
                                    color: AppColors.primaryColorShade5,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        children: [
                          drawerList(
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
                          drawerList(
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
                          drawerList(
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
                    ),
                  ),
                  ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: 6,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            IconBlueBackground(
                              iconName: consignmentIcon,
                            ),
                            wSizedBox(20),
                            Expanded(
                              child: Text(
                                'Tracking',
                                style: AppTextStyles.latoMedium12Black.copyWith(
                                    color: AppColors.primaryColorShade5,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        children: [
                          drawerList(
                            isSubMenu: true,
                            imageName: consignmentIcon,
                            text: "Upcoming Trips",
                            trailingText: widget
                                .dashBoardScreenViewModel.upcomingTrips.length
                                .toString(),
                            onTap: () {},
                          ),
                          drawerList(
                            trailingText: widget
                                .dashBoardScreenViewModel.ongoingTrips.length
                                .toString(),
                            isSubMenu: true,
                            imageName: consignmentListIcon,
                            text: "OnGoing Trips",
                            onTap: () {},
                          ),
                          drawerList(
                            trailingText: widget
                                .dashBoardScreenViewModel.completedTrips.length
                                .toString(),
                            isSubMenu: true,
                            imageName: review_consig_Icon,
                            text: "Completed Trips",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .takeToCompletedTrips();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: 7,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            IconBlueBackground(
                              iconName: consignmentIcon,
                            ),
                            wSizedBox(20),
                            Expanded(
                              child: Text(
                                'Add',
                                style: AppTextStyles.latoMedium12Black.copyWith(
                                    color: AppColors.primaryColorShade5,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        children: [
                          drawerList(
                            imageName: addDriverIcon,
                            isSubMenu: true,
                            text: "Driver",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddDriverDrawerTileClicked();
                            },
                          ),
                          drawerList(
                            isSubMenu: true,
                            imageName: addHubIcon,
                            text: "Hubs",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddHubTileClick();
                            },
                          ),
                          drawerList(
                            isSubMenu: true,
                            imageName: addRouteIcon,
                            text: "Route",
                            onTap: () {
                              widget.dashBoardScreenViewModel
                                  .onAddRoutesTileClick();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 8,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return drawerList(
                        imageName: routesIcon,
                        text: "Routes List",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onViewRoutesDrawerTileClicked();
                        },
                      );
                    },
                    body: Container(),
                  ),
                  ExpansionPanelRadio(
                    value: 9,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return drawerList(
                        imageName: drawerRupeeIcon,
                        text: "Transaction History",
                        onTap: () {
                          widget.dashBoardScreenViewModel
                              .onTransactionsDrawerTileClicked();
                        },
                      );
                    },
                    body: Container(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
