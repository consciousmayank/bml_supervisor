import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
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
      color: ThemeConfiguration.appScaffoldBackgroundColor,
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
                borderRadius: getBorderRadius(),
                onTap: () {
                  widget.dashBoardScreenViewModel.navigationService.back();
                  widget.dashBoardScreenViewModel.navigationService
                      .navigateTo(userProfileRoute);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.primaryColorShade5),
                        child: Image.asset(
                          bmlIcon,
                          height: bmlIconDrawerIconHeight,
                          width: bmlIconDrawerIconWidth,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Welcome,\n${widget.dashBoardScreenViewModel?.savedUser?.userName}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.latoBold18Black,
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
                  widget.dashBoardScreenViewModel.onDashboardTileClick();
                },
              ),
              drawerList(
                imageName: consignmentIcon,
                text: "Add Daily Entry",
                onTap: () {
                  widget.dashBoardScreenViewModel.takeToAddDailyEntry();
                },
              ),
              drawerList(
                imageName: consignmentIcon,
                text: "View Daily Entry",
                onTap: () {
                  widget.dashBoardScreenViewModel.takeToViewEntryPage();
                },
              ),
              drawerList(
                imageName: consignmentIcon,
                text: "Add Expense",
                onTap: () {
                  widget.dashBoardScreenViewModel.takeToAddExpensePage();
                },
              ),
              drawerList(
                imageName: consignmentIcon,
                text: "View Expense",
                onTap: () {
                  widget.dashBoardScreenViewModel.onViewExpensesTileClick();
                },
              ),
              drawerList(
                imageName: consignmentIcon,
                text: "Allot Consignment",
                onTap: () {
                  widget.dashBoardScreenViewModel.takeToAllotConsignmentsPage();
                },
              ),
              drawerList(
                imageName: totalKmIcon,
                text: "Review Consignment",
                onTap: () {
                  widget.dashBoardScreenViewModel
                      .takeToReviewConsignmentsPage();
                },
              ),
              drawerList(
                imageName: routesIcon,
                text: "Route List",
                onTap: () {
                  widget.dashBoardScreenViewModel.onViewRoutesTileClick();
                },
              ),
              drawerList(
                imageName: rupeesIcon,
                text: "Transaction History",
                onTap: () {
                  widget.dashBoardScreenViewModel.onTransactionsTileClick();
                },
              ),
              drawerList(
                imageName: rupeesIcon,
                text: "Pick Image",
                onTap: () {
                  widget.dashBoardScreenViewModel.onPickImageTileClick();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
