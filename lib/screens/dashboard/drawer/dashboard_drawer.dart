import 'package:bml_supervisor/app_level/shared_prefs.dart';
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
              Row(
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
                  Text(
                    "BookMyLoading",
                    style: AppTextStyles.latoMediumItalics15,
                  ),
                ],
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
                  widget.dashBoardScreenViewModel.takeToAddDailyEntry();
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
                text: "Logout",
                onTap: () {
                  MyPreferences().setLoggedInUser(null);
                  MyPreferences().saveCredentials(null);
                  widget.dashBoardScreenViewModel.navigationService
                      .replaceWith(logInPageRoute);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerList({String text, String imageName, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: ClickableWidget(
        borderRadius: getBorderRadius(),
        onTap: () {
          onTap.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              imageName == null
                  ? Container()
                  : Image.asset(
                      imageName,
                      height: drawerIconsHeight,
                      width: drawerIconsWidth,
                      // color: AppColors.primaryColorShade5,
                    ),
              imageName == null ? Container() : wSizedBox(20),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.latoBold14Black
                      .copyWith(color: AppColors.primaryColorShade5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
