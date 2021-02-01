import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_view.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConsignmentListView extends StatefulWidget {
  final bool isFulPageView;
  final String duration;
  final int clientId;

  const ConsignmentListView({
    Key key,
    this.isFulPageView = false,
    @required this.duration,
    @required this.clientId,
  }) : super(key: key);

  @override
  _ConsignmentListViewState createState() => _ConsignmentListViewState();
}

class _ConsignmentListViewState extends State<ConsignmentListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentListViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getRecentConsignments(
        clientId: widget.clientId,
        duration: widget.duration,
      ),
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
          title: Text("All Consignments"),
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
        ? Container()
        : SizedBox(
            child: makeConsignmentList(context: context, viewModel: viewModel),
            height: widget.isFulPageView ? double.infinity : 400,
          );
  }

  Widget makeConsignmentList(
      {BuildContext context, ConsignmentListViewModel viewModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          color: AppColors.primaryColorShade5,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  ('Date'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ('Km Driven'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    ('Trips'),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Track',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      viewModel.recentConsignmentList[index].entryDate,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColorShade1,
                        borderRadius: getBorderRadius(),
                      ),
                      child: Text(
                        viewModel.recentConsignmentList[index].drivenKmG
                            .toString(),
                      ),
                    ),
                    Text(
                      viewModel.recentConsignmentList[index].trips.toString(),
                    ),
                    SizedBox(
                      height: 25,
                      width: 100,
                      child: AppButton(
                          borderColor:
                              viewModel.recentConsignmentList[index].routeId ==
                                      0
                                  ? Colors.transparent
                                  : AppColors.primaryColorShade5,
                          onTap:
                              viewModel.recentConsignmentList[index].routeId ==
                                      0
                                  ? null
                                  : () {
                                      showConsignmentDetailsBottomSheet(
                                          clickedConsignmentDetails: viewModel
                                              .recentConsignmentList[index],
                                          context: context,
                                          viewModel: viewModel);
                                    },
                          background: AppColors.primaryColorShade5,
                          buttonText: "Consignment"),
                    )
                  ],
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
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    viewModel.takeToAllConsignmentsPage();
                  },
                  child: Text(
                    "View More",
                    style: AppTextStyles.underLinedText,
                  ),
                ),
              )
      ],
    );
  }

  void showConsignmentDetailsBottomSheet({
    BuildContext context,
    ConsignmentListViewModel viewModel,
    RecentConginmentResponse clickedConsignmentDetails,
  }) async {
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(defaultBorder),
            topRight: Radius.circular(defaultBorder),
          ),
        ),
        // isScrollControlled: true,
        context: context,
        builder: (_) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ConsignmentDetailsView(
              clientId: widget.clientId,
              routeId: clickedConsignmentDetails.routeId,
              entryDate: clickedConsignmentDetails.entryDate,
            ),
          );
        });
  }
}
