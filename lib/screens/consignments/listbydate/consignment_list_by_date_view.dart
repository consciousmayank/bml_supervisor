import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:bml_supervisor/screens/consignments/listbydate/consignment_list_by_date_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bml_supervisor/widget/single_consignment_item_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

class ConsignmentListByDateView extends StatefulWidget {
  @override
  _ConsignmentListByDateViewState createState() =>
      _ConsignmentListByDateViewState();
}

class _ConsignmentListByDateViewState extends State<ConsignmentListByDateView> {
  TextEditingController selectedDateController =
      TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentListByDateViewModel>.reactive(
        onModelReady: (viewModel) {
          // viewModel.getConsignmentListWithDate();
          viewModel.getConsignmentListPageWise(showLoading: true);
          // viewModel.setClient();
        },
        builder: (context, viewModel, child) => SafeArea(
              left: false,
              right: false,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  centerTitle: true,
                  title: Text(
                    getTitle(viewModel),
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
                body: viewModel.isBusy
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ShimmerContainer(
                          itemCount: 20,
                        ),
                      )
                    : Padding(
                        padding: getSidePadding(context: context),
                        child: body(context, viewModel),
                      ),
              ),
            ),
        viewModelBuilder: () => ConsignmentListByDateViewModel());
  }

  Widget body(BuildContext context, ConsignmentListByDateViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        dateSelector(context: context, viewModel: viewModel),
        hSizedBox(4),
        // viewModel.consignmentsList.length > 0
        //     ? Row(
        //   children: [
        //     Expanded(
        //       child: AppTiles(
        //         value: viewModel.consignmentsList.length.toString(),
        //         title: 'Total Consignments',
        //         iconName: totalConsignmentIcon,
        //       ),
        //       flex: 1,
        //     ),
        //     Expanded(
        //       child: AppTiles(
        //         value: viewModel.grandPayment.toString(),
        //         title: 'Total Amount',
        //         iconName: rupeesIcon,
        //       ),
        //       flex: 1,
        //     )
        //   ],
        // )
        //     : Container(),
        // hSizedBox(4),
        viewModel.consignmentsList.length == 0
            ?
            /// show recent consignment here in place of Container
            Expanded(child: createPendingConsignmentList(viewModel))
            // Container()
            : Expanded(
                child: createConsignmentList(viewModel),
              ),
      ],
    );
  }

  Widget createPendingConsignmentList(
      ConsignmentListByDateViewModel viewModel) {
    return LazyLoadScrollView(
      scrollOffset: 300,
      onEndOfPage: () =>
          viewModel.getConsignmentListPageWise(showLoading: false),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: getBorderRadius(),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.primaryColorShade5, width: 1),
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
      ConsignmentListByDateViewModel viewModel, int outerIndex) {
    return List.generate(
      viewModel.getConsolidatedData(outerIndex).length,
      (index) => SingleConsignmentItem(
        args: SingleConsignmentItemArguments(
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
          onTap: () {
            viewModel.takeToConsignmentDetailPage(
              args: ConsignmentDetailsArgument(
                vehicleId: viewModel.getConsolidatedData(outerIndex)[index].vehicleId,
                callingScreen: CallingScreen.CONSIGNMENT_LIST,
                consignmentId: viewModel.getConsolidatedData(outerIndex)[index].consigmentId
                    .toString(),
                routeId:
                viewModel.getConsolidatedData(outerIndex)[index].routeId.toString(),
                routeName: viewModel.getConsolidatedData(outerIndex)[index].routeTitle,
                entryDate: viewModel.getConsolidatedData(outerIndex)[index].entryDate,
              ),
            );
          },
        ),
      ),
    ).toList();
  }

  ListView createConsignmentList(ConsignmentListByDateViewModel viewModel) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return singleConsignmentView(viewModel, index);
      },
      itemCount: viewModel.consignmentsList.length,
    );
  }

  Card singleConsignmentView(
      ConsignmentListByDateViewModel viewModel, int index) {
    return Card(
      elevation: defaultElevation,
      shape: getCardShape(),
      child: ClickableWidget(
        borderRadius: getBorderRadius(),
        elevation: defaultElevation,
        onTap: () {
          viewModel.takeToConsignmentDetailPage(
            args: ConsignmentDetailsArgument(
              vehicleId: viewModel.consignmentsList[index].vehicleId,
              callingScreen: CallingScreen.CONSIGNMENT_LIST,
              consignmentId:
                  viewModel.consignmentsList[index].consigmentId.toString(),
              routeId: viewModel.consignmentsList[index].routeId.toString(),
              routeName: viewModel.consignmentsList[index].routeTitle,
              entryDate: null,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      "C#${viewModel.consignmentsList[index].consigmentId}",
                      style: AppTextStyles.latoMedium14Black
                          .copyWith(fontSize: 14, color: AppColors.white),
                    ),
                    backgroundColor: AppColors.primaryColorShade5,
                  ),
                  Text(
                    "(R# ${viewModel.consignmentsList[index].routeId} ${viewModel.consignmentsList[index].routeTitle})",
                    style: AppTextStyles.latoMedium14Black.copyWith(
                        fontSize: 14, color: AppColors.primaryColorShade5),
                  )
                ],
              ),
              hSizedBox(14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppTextView(
                      hintText: 'Collect',
                      value:
                          viewModel.consignmentsList[index].collect.toString(),
                    ),
                  ),
                  wSizedBox(6),
                  Expanded(
                    child: AppTextView(
                      hintText: 'Drop',
                      value:
                          viewModel.consignmentsList[index].dropOff.toString(),
                    ),
                  ),
                ],
              ),
              hSizedBox(14),
              AppTextView(
                hintText: 'Payment',
                value: viewModel.consignmentsList[index].payment.toString(),
              )
            ],
          ),
        ),
      ),
    );
  }

  dateSelector(
      {BuildContext context, ConsignmentListByDateViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectedDateTextField(ConsignmentListByDateViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Entry Date",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  selectDateButton(
      BuildContext context, ConsignmentListByDateViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
      child: appSuffixIconButton(
        icon: Image.asset(
          calendarIcon,
          height: 16,
          width: 16,
        ),
        // Icon(Icons.calendar_today_outlined),
        onPressed: (() async {
          DateTime selectedDate = await selectDate();
          if (selectedDate != null) {
            selectedDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
            viewModel.entryDate = selectedDate;

            // viewModel.getRoutes(viewModel.selectedClient.id);
            viewModel.getConsignmentListWithDate();
          }
        }),
      ),
    );
  }

  Future<DateTime> selectDate() async {
    DateTime picked = await showDatePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: ThemeConfiguration.primaryBackground,
            ),
          ),
          child: child,
        );
      },
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Expiration Date',
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  String getTitle(ConsignmentListByDateViewModel viewModel) {
    // return 'Consignment${viewModel.consignmentsList.length}';

    if (viewModel.consignmentsList.length == 0) {
      return 'Consignment';
    } else {
      return 'Consignment (${viewModel.consignmentsList.length})';
    }
  }
}
