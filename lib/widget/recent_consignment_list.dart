import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/recent_consignment_list_viewmodel.dart';
import 'package:bml_supervisor/widget/single_consignment_item_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RecentConsignmentList extends StatefulWidget {
  @override
  _RecentConsignmentListState createState() => _RecentConsignmentListState();
}

class _RecentConsignmentListState extends State<RecentConsignmentList> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecentConsignmentListViewModel>.reactive(
        onModelReady: (viewModel) {
          // viewModel.getClients();
          print('on recent consign list');
          viewModel.getRecentConsignmentsForCreateConsignment();
        },
        builder: (context, viewModel, child) {
          return viewModel.recentConsignmentsList.length > 0
              ? ListView.builder(
                  // shrinkWrap: true,
                  // physics:  AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: getBorderRadius(),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryColorShade5, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ThemeConfiguration.primaryBackground,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                height: 50.0,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date',
                                      style: AppTextStyles.latoBold16White,
                                    ),
                                    Text(
                                      viewModel.recentConsignmentsDateList
                                          .elementAt(index),
                                      style: AppTextStyles.latoBold16White,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children:
                                    buildSingleConsignment(viewModel, index),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: viewModel.recentConsignmentsDateList.length,
                )
              : Container();
        },
        viewModelBuilder: () => RecentConsignmentListViewModel());
  }

  List<Widget> buildSingleConsignment(
      RecentConsignmentListViewModel viewModel, int outerIndex) {
    return List.generate(
      viewModel.getConsolidatedData(outerIndex).length,
      (index) => SingleConsignmentItem(
        args: SingleConsignmentItemArguments(
          onTap: (){},
          vehicleId: viewModel
              .getConsolidatedData(outerIndex)[index]
              .vehicleId
              .toString(),
          drop: viewModel
              .getConsolidatedData(outerIndex)[index]
              .dropOff
              .toString(),
          routeTitle: viewModel
              .getConsolidatedData(outerIndex)[index]
              .routeTitle
              .toString(),
          collect: viewModel
              .getConsolidatedData(outerIndex)[index]
              .collect
              .toString(),
          payment: viewModel
              .getConsolidatedData(outerIndex)[index]
              .payment
              .toString(),
          routeId: viewModel
              .getConsolidatedData(outerIndex)[index]
              .routeId
              .toString(),
          consignmentId: viewModel
              .getConsolidatedData(outerIndex)[index]
              .consigmentId
              .toString(),
          // onTap: () {
          //   viewModel.takeToConsignmentDetailPage(
          //     args: ConsignmentDetailsArgument(
          //       vehicleId:
          //       viewModel.getConsolidatedData(outerIndex)[index].vehicleId,
          //       callingScreen: CallingScreen.CONSIGNMENT_LIST,
          //       consignmentId: viewModel
          //           .getConsolidatedData(outerIndex)[index]
          //           .consigmentId
          //           .toString(),
          //       routeId: viewModel
          //           .getConsolidatedData(outerIndex)[index]
          //           .routeId
          //           .toString(),
          //       routeName:
          //       viewModel.getConsolidatedData(outerIndex)[index].routeTitle,
          //       entryDate:
          //       viewModel.getConsolidatedData(outerIndex)[index].entryDate,
          //     ),
          //   );
          // },
        ),
      ),
    ).toList();
  }
}
