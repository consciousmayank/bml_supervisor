import 'package:bml_supervisor/utils/widget_utils.dart';
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
              drawerList(
                imageName: homeIcon,
                text: "Dashboard",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .onDashboardDrawerTileClicked();
                },
              ),
              drawerList(
                imageName: totalKmIcon,
                text: "Daily Kilometers",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .onDailyKilometersDrawerTileClicked();
                },
              ),
              drawerList(
                imageName: expensesIcon,
                text: "Expenses",
                onTap: () {
                  widget.dashBoardScreenViewModel.onExpensesDrawerTileClicked();
                },
              ),
              drawerList(
                imageName: consignmentIcon,
                text: "Consignment",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .changeConsignmentGroupVisibility();
                },
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 800),
                opacity: widget.dashBoardScreenViewModel.openConsignmentGroup
                    ? 1.0
                    : 0.0,
                child: widget.dashBoardScreenViewModel.openConsignmentGroup
                    ? Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Column(
                          children: [
                            drawerList(
                              imageName: consignmentIcon,
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
                              text: "List",
                              onTap: () {
                                widget.dashBoardScreenViewModel
                                    .onListConsignmentTileClick();
                                widget.dashBoardScreenViewModel
                                    .changeConsignmentGroupVisibility();
                              },
                            ),
                            drawerList(
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
                      )
                    : Container(),
              ),
              drawerList(
                imageName: routesIcon,
                text: "Routes List",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .onViewRoutesDrawerTileClicked();
                },
              ),
              drawerList(
                imageName: drawerRupeeIcon,
                text: "Transaction History",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .onTransactionsDrawerTileClicked();
                },
              ),
              drawerList(
                imageName: addDriverIcon,
                text: "Add Driver",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .onAddDriverDrawerTileClicked();
                },
              ),
              drawerList(
                imageName: addHubIcon,
                text: "Add Hubs",
                onTap: () {
                  widget.dashBoardScreenViewModel.onAddHubTileClick();
                },
              ),
              drawerList(
                imageName: addRouteIcon,
                text: "Create Route",
                onTap: () {
                  widget.dashBoardScreenViewModel.onAddRoutesTileClick();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
