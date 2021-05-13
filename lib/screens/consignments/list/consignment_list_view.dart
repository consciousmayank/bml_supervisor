import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConsignmentListView extends StatefulWidget {
  final bool isFulPageView;

  const ConsignmentListView({
    Key key,
    this.isFulPageView = false,
  }) : super(key: key);

  @override
  _ConsignmentListViewState createState() => _ConsignmentListViewState();
}

class _ConsignmentListViewState extends State<ConsignmentListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentListViewModel>.reactive(
      onModelReady: (viewModel) {
        //todo: put new api for last seven entries here
        // viewModel.getRecentConsignments();
        viewModel.getRecentDrivenKm(
            clientId: MyPreferences().getSelectedClient().clientId,
            isFullScreen: widget.isFulPageView);
      },
      builder: (context, viewModel, child) => SafeArea(
        left: true,
        right: true,
        bottom: true,
        child: getRootWidget(
          context: context,
          viewModel: viewModel,
          child: getBody(context: context, viewModel: viewModel),
        ),
      ),
      viewModelBuilder: () => ConsignmentListViewModel(),
    );
  }

  Widget getRootWidget({
    @required BuildContext context,
    @required ConsignmentListViewModel viewModel,
    @required Widget child,
  }) {
    if (widget.isFulPageView) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text("All Consignments", style: AppTextStyles.appBarTitleStyle),
        ),
        body: child,
      );
    } else {
      return Container(
        child: child,
      );
    }
  }

  Widget getBody({BuildContext context, ConsignmentListViewModel viewModel}) {
    return viewModel.recentConsignmentList.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: buildChartTitle(title: "Recent Driven Kilometers"),
              ),
              NoDataWidget(),
            ],
          )
        : SizedBox(
            child: makeConsignmentList(context: context, viewModel: viewModel),
            height: widget.isFulPageView
                ? double.infinity
                : viewModel.recentConsignmentList.length <= 7
                    ? 400
                    : 400,
          );
  }

  Widget makeConsignmentList({
    BuildContext context,
    ConsignmentListViewModel viewModel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: AppColors.primaryColorShade5,
          padding: EdgeInsets.all(15),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  ('Date'),
                  style: AppTextStyles.whiteRegular,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ('Driven Km.'),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.whiteRegular,
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    ('Trips'),
                    textAlign: TextAlign.left,
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Consg.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.whiteRegular,
                ),
              ),
            ],
          ),
        ),
        hSizedBox(8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return RecentDrivenSingleItem(
                  viewModel: viewModel,
                  index: index,
                );
              },
              itemCount: viewModel.recentConsignmentList.length >= 7
                  ? 7
                  : viewModel.recentConsignmentList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 1,
                  color: AppColors.primaryColorShade3,
                );
              },
            ),
          ),
        ),
        widget.isFulPageView
            ? Container()
            : InkWell(
                onTap: () {
                  viewModel.takeToDailyKilometersPage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: AppColors.primaryColorShade5,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    "View More",
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
              ),
        hSizedBox(5),
      ],
    );
  }

  // void showConsignmentDetailsBottomSheet({
  //   BuildContext context,
  //   ConsignmentListViewModel viewModel,
  //   RecentConginmentResponse clickedConsignmentDetails,
  // }) async {
  //   await showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(defaultBorder),
  //           topRight: Radius.circular(defaultBorder),
  //         ),
  //       ),
  //       // isScrollControlled: true,
  //       context: context,
  //       builder: (_) {
  //         return SizedBox(
  //           height: MediaQuery
  //               .of(context)
  //               .size
  //               .height * 0.75,
  //           child: ConsignmentDetailsView(
  //             : clickedConsignmentDetails.consgId,
  //           ),
  //         );
  //       });
  // }
}

class RecentDrivenSingleItem extends StatelessWidget {
  final ConsignmentListViewModel viewModel;
  final int index;

  const RecentDrivenSingleItem({
    Key key,
    this.viewModel,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          viewModel.recentConsignmentList[index].entryDate,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColorShade5,
            borderRadius: getBorderRadius(),
          ),
          child: Text(
            viewModel.recentConsignmentList[index].drivenKmG.toString(),
            style: AppTextStyles.whiteRegular.copyWith(fontSize: 10),
          ),
        ),
        Text(
          viewModel.recentConsignmentList[index].trips.toString(),
        ),
        SizedBox(
          height: 25,
          width: 100,
          child: AppButton(
            borderColor: viewModel.recentConsignmentList[index].routeId == 0
                ? Colors.transparent
                : AppColors.primaryColorShade11,
            onTap: viewModel.recentConsignmentList[index].routeId == 0
                ? null
                : () {
                    // call getConsignment by Id
                    viewModel.takeToConsignmentDetailsRoute(
                      args: ConsignmentDetailsArgument(
                        callingScreen: CallingScreen.RECENT_DRIVEN_KMS,
                        consignmentId: viewModel
                            .recentConsignmentList[index].consgId
                            .toString(),
                        routeId: viewModel.recentConsignmentList[index].routeId
                            .toString(),
                        routeName: viewModel
                            .recentConsignmentList[index].routeTitle
                            .toString(),
                        entryDate:
                            viewModel.recentConsignmentList[index].entryDate,
                        vehicleId:
                            viewModel.recentConsignmentList[index].vehicleId,
                      ),
                    );
                  },
            background: AppColors.primaryColorShade5,
            fontSize: 9,
            buttonText: '#' +
                viewModel.recentConsignmentList[index].routeId.toString() +
                '-' +
                viewModel.recentConsignmentList[index].routeTitle,
          ),
        )
      ],
    );
  }
}
