import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/screens/consignments/pendinglist/pending_consignments_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bml_supervisor/widget/single_consignment_item_view.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

class PendingConsignmentsListView extends StatefulWidget {
  @override
  _PendingConsignmentsListViewState createState() =>
      _PendingConsignmentsListViewState();
}

class _PendingConsignmentsListViewState
    extends State<PendingConsignmentsListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PendingConsignmentsListViewModel>.reactive(
        onModelReady: (model) =>
            model.getPendingConsignmentsList(showLoading: true),
        builder: (context, viewModel, child) => SafeArea(
              top: true,
              bottom: true,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Pending Consignments - ${MyPreferences().getSelectedClient().clientId}',
                    style: AppTextStyles.appBarTitleStyle,
                  ),
                  centerTitle: true,
                ),
                body: viewModel.isBusy
                    ? ShimmerContainer(
                        itemCount: 10,
                      )
                    : _MainBody(
                        viewModel: viewModel,
                      ),
              ),
            ),
        viewModelBuilder: () => PendingConsignmentsListViewModel());
  }
}

class _MainBody extends StatefulWidget {
  final PendingConsignmentsListViewModel viewModel;

  const _MainBody({Key key, this.viewModel}) : super(key: key);

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  @override
  Widget build(BuildContext context) {
    return widget.viewModel.pendingConsignmentsDateList.length > 0
        ? createPendingConsignmentList(widget.viewModel)
        : Container();
  }

  Widget createPendingConsignmentList(
      PendingConsignmentsListViewModel viewModel) {
    return LazyLoadScrollView(
      scrollOffset: 300,
      onEndOfPage: () =>
          viewModel.getPendingConsignmentsList(showLoading: false),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: getBorderRadius(),
              child: Card(
                color: AppColors.appScaffoldColor,
                elevation: defaultElevation,
                shape: getCardShape(),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ThemeConfiguration.primaryBackground,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(defaultBorder),
                          topRight: Radius.circular(defaultBorder),
                        ),
                      ),
                      height: 50.0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: AppTextStyles.latoBold16White,
                          ),
                          Text(
                            viewModel.pendingConsignmentsDateList
                                .elementAt(index),
                            style: AppTextStyles.latoBold16White,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: buildSinglePendingConsignment(viewModel, index),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: viewModel.pendingConsignmentsDateList.length,
      ),
    );
  }

  List<Widget> buildSinglePendingConsignment(
      PendingConsignmentsListViewModel viewModel, int outerIndex) {
    return List.generate(
      viewModel.getConsolidatedData(outerIndex).length,
      (index) => Column(
        children: [
          index == 0 ? Container() : DottedDivider(),
          SingleConsignmentItem(
            args: SingleConsignmentItemArguments(
              drop: viewModel
                  .getConsolidatedData(outerIndex)[index]
                  .dropOff
                  .toString(),
              vehicleId: viewModel
                  .getConsolidatedData(outerIndex)[index]
                  .vehicleId
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
              onTap: () {
                viewModel.takeToReviewConsignment(
                    selectedConsignment:
                        viewModel.getConsolidatedData(outerIndex)[index]);
              },
            ),
          ),
        ],
      ),
    ).toList();
  }
}
