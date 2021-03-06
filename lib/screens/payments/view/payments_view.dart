import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

import 'payment_args.dart';
import 'payments_viewmodel.dart';

class PaymentsView extends StatefulWidget {
  const PaymentsView({Key key, this.args}) : super(key: key);

  final PaymentArgs args;

  @override
  _PaymentsViewState createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  final TextEditingController remarksController = TextEditingController();
  final FocusNode remarksFocusNode = FocusNode();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();
  final TextEditingController totalAmountController = TextEditingController();
  final FocusNode totalAmountFocusNode = FocusNode();
  final TextEditingController totalKmController = TextEditingController();
  final FocusNode totalKmFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  Widget buildChip({String title, String value}) {
    return Card(
      shape: getCardShape(),
      elevation: defaultElevation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(title, style: AppTextStyles.latoMedium12Black),
            wSizedBox(10),
            Text(value, style: AppTextStyles.latoBold16Black),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionsTableData(
      BuildContext context, PaymentsViewModel viewModel) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        if (viewModel.paymentListAggregate.paymentCount >
            viewModel.paymentHistoryResponseList.length) {
          viewModel.getPaymentHistory();
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildHeaderTiles(viewModel);
          }
          index -= 1;
          return Column(
            children: [
              ClipRRect(
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
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
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
                              viewModel.paymentDates.elementAt(index),
                              style: AppTextStyles.latoBold16White,
                            ),
                          ],
                        ),
                      ),
                      if (viewModel.paymentHistoryResponseList.length > 0)
                        ...makePaymentsBody(
                          outerListIndex: index,
                          viewModel: viewModel,
                        )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: viewModel.paymentDates.length + 1,
      ),
    );
  }

  Widget buildHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 8,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(('Date'), style: TextStyle(fontWeight: FontWeight.bold)),
          Text(('KMs'), style: TextStyle(fontWeight: FontWeight.bold)),
          Text(('Payment'), style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildHeaderTiles(PaymentsViewModel viewModel) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: AppTiles(
                title: 'Total Amount',
                value: viewModel.paymentListAggregate.paymentTotal.toString(),
                iconName: rupeesIcon,
              ),
            ),
            // wSizedBox(5),
            Expanded(
              flex: 1,
              child: AppTiles(
                title: 'Payment Count',
                value: viewModel.paymentListAggregate.paymentCount.toString(),
                iconName: paymentsIcon,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: AppTiles(
                title: 'Total Kilometer',
                value: viewModel.paymentListAggregate.totalKm.toString() ?? "",
                iconName: totalKmIcon,
              ),
            ),
            // wSizedBox(5),
            Expanded(
              flex: 1,
              child: AppTiles(
                title: 'Due Kilometer',
                value: viewModel.paymentListAggregate.dueKm.toString() ?? "",
                iconName: paymentsIcon,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentsViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.getPaymentListAggregate();
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: setAppBarTitle(title: 'Transaction History'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CreateNewButtonWidget(
                        title: 'Add New Payment',
                        onTap: () {
                          viewModel.onAddPaymentClicked();
                        }),
                    hSizedBox(5),
                    // viewModel.paymentHistoryResponseList.length == 0
                    //     ? NoDataWidget(
                    //         label: 'No payments yet',
                    //       )
                    //     :
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Transactions List',
                        style: AppTextStyles.latoBold14primaryColorShade6,
                      ),
                    ),
                    // viewModel.paymentHistoryResponseList.length == 0
                    //     ? Container()
                    //     :
                    SearchWidget(
                      onClearTextClicked: () {
                        // selectedRegNoController.clear();
                        // viewModel.selectedVehicleId = '';
                        // viewModel.getExpenses(
                        //   showLoader: false,
                        // );
                        hideKeyboard(context: context);
                      },
                      hintTitle: 'Search for transaction',
                      onTextChange: (String value) {
                        // viewModel.selectedVehicleId = value;
                        // viewModel.notifyListeners();
                      },
                      onEditingComplete: () {
                        // viewModel.getExpenses(
                        //   showLoader: true,
                        // );
                      },
                      formatter: <TextInputFormatter>[
                        TextFieldInputFormatter().alphaNumericFormatter,
                      ],
                      controller: TextEditingController(),
                      // focusNode: selectedRegNoFocusNode,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (String value) {
                        // viewModel.getExpenses(
                        //   showLoader: true,
                        // );
                      },
                    ),
                    hSizedBox(8),
                    Expanded(
                      child: buildTransactionsTableData(context, viewModel),
                    ),
                    // : Container(),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => PaymentsViewModel(),
    );
  }

  makePaymentsBody(
      {@required int outerListIndex, @required PaymentsViewModel viewModel}) {
    List<dynamic> subList = viewModel.getConsolidatedList(outerListIndex);

    return List.generate(
        subList.length,
        (index) => Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("Driven Km"),
                      Expanded(
                        flex: 1,
                        child: AppTextView(
                          hintText: "Transaction ID",
                          value: subList[index].transactionId.toString(),
                        ),
                      ),
                      wSizedBox(8),
                      Expanded(
                        flex: 1,
                        child: AppTextView(
                          hintText: "Kilometers",
                          value: subList[index].kilometers.toString(),
                        ),
                      ),
                      wSizedBox(8),
                      Expanded(
                        flex: 1,
                        child: AppTextView(
                          hintText: "Amount (INR)",
                          value: subList[index].amount.toString(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )).toList();
  }
}
