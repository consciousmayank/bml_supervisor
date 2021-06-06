import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/consignmentdetailshubsview/single_hub_grid_view.dart';
import 'package:bml_supervisor/widget/consignmentdetailshubsview/single_hub_list_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'consignment_detials_viewmodel.dart';

class ConsignmentDetailsView extends StatefulWidget {
  final ConsignmentDetailsArgument args;

  const ConsignmentDetailsView({Key key, this.args}) : super(key: key);

  @override
  _ConsignmentDetailsViewState createState() => _ConsignmentDetailsViewState();
}

class _ConsignmentDetailsViewState extends State<ConsignmentDetailsView> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentDetailsViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.setBusy(true);
        Future.delayed(Duration(seconds: 1), () {
          viewModel.getConsignmentWithId(widget.args.consignmentId);
        });
      },
      builder: (context, viewModel, child) => SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: viewModel.consignmentDetailResponse != null
                ? Text(
                    viewModel?.consignmentDetailResponse?.entryDate ?? '',
                    style: AppTextStyles.appBarTitleStyle,
                  )
                : setAppBarTitle(title: 'Consignment'),
            actions: [
              IconButton(
                icon: viewModel.isListViewSelected
                    ? Image.asset(
                        gridViewIcon,
                        height: 13,
                        width: 13,
                      )
                    : Image.asset(
                        listViewIcon,
                        height: 13,
                        width: 13,
                      ),
                onPressed: () {
                  viewModel.isListViewSelected = !viewModel.isListViewSelected;
                },
              )
            ],
          ),
          body: viewModel.isBusy
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ShimmerContainer(
                    itemCount: 20,
                  ),
                )
              : showConsignmentDetails(viewModel: viewModel, context: context),
        ),
      ),
      viewModelBuilder: () => ConsignmentDetailsViewModel(),
    );
  }

  Widget showConsignmentDetails(
      {ConsignmentDetailsViewModel viewModel, BuildContext context}) {
    //viewModel.consignmentDetailResponseNew
    return viewModel.consignmentDetailResponse == null
        ? Container()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorShade5,
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultBorder)),
                  ),
                  height: buttonHeight,
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.args.callingScreen ==
                              CallingScreen.RECENT_DRIVEN_KMS
                          ? Text(
                              // 'C#${viewModel.consignmentId}',
                              'C#${viewModel.consignmentDetailResponse.id}',
                              style: AppTextStyles.latoBold14Black.copyWith(
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'C#${viewModel.consignmentDetailResponse.id}',
                              style: AppTextStyles.latoBold14Black.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                      widget.args.callingScreen ==
                              CallingScreen.RECENT_DRIVEN_KMS
                          ? Text(
                              // '(${widget.args.routeName})',
                              // '(R#${widget.args.routeId} ${widget.args.routeName})',
                              '(R#${viewModel.consignmentDetailResponse.routeId} ${viewModel.consignmentDetailResponse.routeTitle})',
                              style: AppTextStyles.latoBold14Black.copyWith(
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              '(R#${widget.args.routeId} ${widget.args.routeName})',
                              // '(R#${viewModel.consignmentDetailResponse.routeId} ${viewModel.consignmentDetailResponse.routeTitle})',
                              style: AppTextStyles.latoMedium12Black.copyWith(
                                color: AppColors.white,
                              ),
                            )
                    ],
                  ),
                ),
              ),
              AppTiles(
                title: 'Total Payment',
                value: viewModel.consignmentDetailResponse.payment == 0
                    ? viewModel.consignmentDetailResponse.reviewedItems.length >
                            0
                        ? viewModel.consignmentDetailResponse.reviewedItems.last
                                .payment
                                .toString() +
                            '/' +
                            viewModel
                                .consignmentDetailResponse.items.last.payment
                                .toString()
                        : viewModel.consignmentDetailResponse.items.last.payment
                            .toString()
                    : viewModel.consignmentDetailResponse.reviewedItems.length >
                            0
                        ? viewModel.consignmentDetailResponse.reviewedItems.last
                                .payment
                                .toString() +
                            '/' +
                            viewModel.consignmentDetailResponse.payment
                                .toString()
                        : viewModel.consignmentDetailResponse.payment
                            .toString(),
                iconName: rupeesIcon,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppTiles(
                      value: getTotalCollectValue(viewModel),
                      title:
                          'Total Collect (${viewModel.consignmentDetailResponse.itemUnit})',
                      iconName: collectIcon,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: AppTiles(
                      value: geTotalDropValue(viewModel),
                      title:
                          'Total Drop (${viewModel.consignmentDetailResponse.itemUnit})',
                      iconName: dropIcon,
                    ),
                    flex: 1,
                  )
                ],
              ),
              // Text('Show Tiles here'),
              viewModel.consignmentDetailResponse.items.length > 0
                  ? Expanded(
                      child: viewModel.isListViewSelected
                          ? makeListView(viewModel)
                          : makeGridView(
                              viewModel: viewModel, context: context),
                      // : makeStaggeredGridView(
                      //     viewModel: viewModel, context: context),
                    )
                  : Container(),
            ],
          );
  }

  String geTotalDropValue(ConsignmentDetailsViewModel viewModel) {
    return viewModel.consignmentDetailResponse.dropOff == 0
        ? viewModel.consignmentDetailResponse.reviewedItems.length > 0
            ? viewModel.consignmentDetailResponse.reviewedItems.last.dropOff
                    .toString() +
                '/' +
                viewModel.consignmentDetailResponse.items.last.dropOff
                    .toString()
            : viewModel.consignmentDetailResponse.items.last.dropOff.toString()
        : viewModel.consignmentDetailResponse.reviewedItems.length > 0
            ? viewModel.consignmentDetailResponse.reviewedItems.last.dropOff
                    .toString() +
                '/' +
                viewModel.consignmentDetailResponse.dropOff.toString()
            : viewModel.consignmentDetailResponse.dropOff.toString();
  }

  String getTotalCollectValue(ConsignmentDetailsViewModel viewModel) {
    return viewModel.consignmentDetailResponse.collect == 0
        ? viewModel.consignmentDetailResponse.reviewedItems.length > 0
            ? viewModel.consignmentDetailResponse.reviewedItems.first.collect
                    .toString() +
                '/' +
                viewModel.consignmentDetailResponse.items.first.collect
                    .toString()
            : viewModel.consignmentDetailResponse.items.first.collect.toString()
        : viewModel.consignmentDetailResponse.reviewedItems.length > 0
            ? viewModel.consignmentDetailResponse.reviewedItems.first.collect
                    .toString() +
                '/' +
                viewModel.consignmentDetailResponse.collect.toString()
            : viewModel.consignmentDetailResponse.collect.toString();
  }

  GridView makeGridView(
      {ConsignmentDetailsViewModel viewModel, BuildContext context}) {
    // ConsignmentDetailResponseNew gridResponse =
    //     omitHubs(viewModel.consignmentDetailResponse);
    List<ItemForCard> gridResponseNew =
        omitHubsNew(viewModel.newItems, viewModel);

    return GridView.builder(
      controller: _controller,
      // itemCount: gridResponse.items.length,
      itemCount: gridResponseNew.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (MediaQuery.of(context).size.width / 2) /
            (MediaQuery.of(context).size.height / 2),
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: AppColors.appScaffoldColor,
          elevation: defaultElevation,
          shape: getCardShape(),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleHubGridView(
              itemUnit: viewModel.consignmentDetailResponse.itemUnit,
              singleHub: gridResponseNew[index],
              key: Key(gridResponseNew[index].hubId.toString()),
            ),
          ),
        );
      },
    );
  }

  ListView makeListView(ConsignmentDetailsViewModel viewModel) {
    return ListView.builder(
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        return isHubOmitted(
          viewModel: viewModel,
          singleHub: viewModel.newItems[index],
          child: Card(
            color: AppColors.appScaffoldColor,
            elevation: defaultElevation,
            shape: getCardShape(),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SingleHubListView(
                itemUnit: viewModel.consignmentDetailResponse.itemUnit,
                singleHub: viewModel.newItems[index],
                key: UniqueKey(),
              ),
            ),
          ),
        );
      },
      itemCount: viewModel.newItems.length,
    );
  }

  Widget isHubOmitted(
      {ItemForCard singleHub,
      Widget child,
      ConsignmentDetailsViewModel viewModel}) {
    // todo: change hubID to enum
    // removing GoldenHarvest from the items
    if ((singleHub.hubId == 111) ||
        (int.parse(viewModel.consignmentDetailResponse.reviewedItems.length > 0
                    ? singleHub.dropOff.split('/')[1]
                    : singleHub.dropOff) ==
                0 &&
            int.parse(
                    viewModel.consignmentDetailResponse.reviewedItems.length > 0
                        ? singleHub.collect.split('/')[1]
                        : singleHub.collect) ==
                0 &&
            double.parse(
                    viewModel.consignmentDetailResponse.reviewedItems.length > 0
                        ? singleHub.payment.split('/')[1]
                        : singleHub.payment) ==
                0)) {
      return Container();
    } else {
      return child;
    }
  }

  // ConsignmentDetailResponseNew omitHubs(
  //     ConsignmentDetailResponseNew consignmentDetailResponse) {
  //   ConsignmentDetailResponseNew tempObj = consignmentDetailResponse.copyWith(
  //     items: [],
  //   );
  //
  //   consignmentDetailResponse.items.forEach((element) {
  //     if (element.dropOff != 0 ||
  //         element.collect != 0 ||
  //         element.payment != 0) {
  //       // todo: change hubId to enum
  //       // removing GoldenHarvest from the items
  //       if (element.hubId != 111) {
  //         tempObj.items.add(element);
  //       }
  //     }
  //   });
  //   // todo: change hubId to enum
  //   // tempObj.items.removeWhere((element) => element.hubId == 111);
  //   return tempObj;
  // }

  List<ItemForCard> omitHubsNew(List<ItemForCard> gridResponseNew,
      ConsignmentDetailsViewModel viewModel) {
    List<ItemForCard> tempObj = [];

    gridResponseNew.forEach((element) {
      if (int.parse(viewModel.consignmentDetailResponse.reviewedItems.length > 0
                  ? element.dropOff.split('/')[1]
                  : element.dropOff) !=
              0 ||
          int.parse(viewModel.consignmentDetailResponse.reviewedItems.length > 0
                  ? element.collect.split('/')[1]
                  : element.collect) !=
              0 ||
          double.parse(
                  viewModel.consignmentDetailResponse.reviewedItems.length > 0
                      ? element.payment.split('/')[1]
                      : element.payment) !=
              0) {
        // todo: change hubId to enum
        // removing GoldenHarvest from the items
        if (element.hubId != 111) {
          tempObj.add(element);
        }
      }
    });
    // todo: change hubId to enum
    // tempObj.items.removeWhere((element) => element.hubId == 111);
    return tempObj;
  }
}
