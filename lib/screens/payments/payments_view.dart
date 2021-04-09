import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/screens/payments/payment_args.dart';
import 'package:bml_supervisor/screens/payments/payments_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class PaymentsView extends StatefulWidget {
  final PaymentArgs args;

  const PaymentsView({Key key, this.args}) : super(key: key);

  @override
  _PaymentsViewState createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode totalKmFocusNode = FocusNode();
  final TextEditingController totalKmController = TextEditingController();

  final FocusNode totalAmountFocusNode = FocusNode();
  final TextEditingController totalAmountController = TextEditingController();
  final FocusNode remarksFocusNode = FocusNode();
  final TextEditingController remarksController = TextEditingController();

  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getClients(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('Transaction History',
              style: AppTextStyles.appBarTitleStyle),
        ),
        floatingActionButton: viewModel.paymentHistoryResponseList.length > 0
            ? FloatingActionButton.extended(
                elevation: defaultElevation,
                onPressed: viewModel.paymentHistoryResponseList.length > 0
                    ? () {
                        showAddNewPaymentBottomSheet(context, viewModel);
                      }
                    : null,
                label: Text('Add Payment'),
              )
            : Container(),
        body: viewModel.isBusy
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ShimmerContainer(
                  itemCount: 20,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // selectClientForTransactionList(viewModel: viewModel),
                  // selectDuration(viewModel: viewModel),
                  hSizedBox(5),
                  viewModel.paymentHistoryResponseList.length > 0
                      ? Expanded(
                          child: buildTransactionsTableData(context, viewModel),
                        )
                      : Container(),
                ],
              ),
      ),
      viewModelBuilder: () => PaymentsViewModel(),
    );
  }

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
    return Scrollbar(
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
                              viewModel
                                  .paymentHistoryResponseList[index].entryDate
                                  .toString(),
                              style: AppTextStyles.latoBold16White,
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                                    value: viewModel
                                        .paymentHistoryResponseList[index]
                                        .transactionId
                                        .toString(),
                                  ),
                                ),
                                wSizedBox(8),
                                Expanded(
                                  flex: 1,
                                  child: AppTextView(
                                    hintText: "Kilometers",
                                    value: viewModel
                                        .paymentHistoryResponseList[index]
                                        .kilometers
                                        .toString(),
                                  ),
                                ),
                                wSizedBox(8),
                                Expanded(
                                  flex: 1,
                                  child: AppTextView(
                                    hintText: "Amount (INR)",
                                    value: viewModel
                                        .paymentHistoryResponseList[index]
                                        .amount
                                        .toString(),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              index == viewModel.paymentHistoryResponseList.length - 1
                  ? hSizedBox(80)
                  : Container()
            ],
          );
        },
        itemCount: viewModel.paymentHistoryResponseList.length + 1,
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

  dateSelector({BuildContext context, PaymentsViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectedDateTextField(PaymentsViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Entry Date",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  selectDateButton(BuildContext context, PaymentsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.calendar_today_outlined),
        onPressed: (() async {
          DateTime selectedDate = await selectDate(viewModel);
          if (selectedDate != null) {
            selectedDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
            viewModel.entryDate = selectedDate;
            // viewModel.getEntryForSelectedDate();
            viewModel.emptyDateSelector = true;
          }
        }),
      ),
    );
  }

  Future<DateTime> selectDate(PaymentsViewModel viewModel) async {
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
      helpText: 'Select Date',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Expiration Date',
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  void showAddNewPaymentBottomSheet(
      BuildContext context, PaymentsViewModel viewModel) {
    final node = FocusScope.of(context);
    showModalBottomSheet(
        backgroundColor: AppColors.appScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(defaultBorder),
            topRight: Radius.circular(defaultBorder),
          ),
        ),
        // isScrollControlled: true,
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Scrollbar(
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding: getPaymentScreenSidePadding(),
                      child: dateSelector(viewModel: viewModel),
                    ),
                    Padding(
                      padding: getPaymentScreenSidePadding(),
                      child: totalKmView(context: context, node: node),
                    ),
                    Padding(
                      padding: getPaymentScreenSidePadding(),
                      child: totalPaymentView(context: context, node: node),
                    ),
                    Padding(
                      padding: getPaymentScreenSidePadding(),
                      child: getRemarksView(node: node),
                    ),
                    hSizedBox(10),
                    Padding(
                      padding: getPaymentScreenSidePadding(),
                      child: addNewPaymentButton(viewModel: viewModel),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget getRemarksView({dynamic node}) {
    return appTextFormField(
      onEditingComplete: () => node.unfocus(),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 3,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 , -- /]')),
      ],
      controller: remarksController,
      focusNode: remarksFocusNode,
      hintText: "Remarks",
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        remarksFocusNode.unfocus();
      },
    );
  }

  Widget addNewPaymentButton({PaymentsViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ElevatedButton(
          child: Text("CREATE"),
          onPressed: () {
            //* hit add transaction api
            if (_formKey.currentState.validate()) {
              if (viewModel.selectedClientForNewTransaction != null) {
                if (viewModel.emptyDateSelector) {
                  viewModel
                      .addNewPayment(
                    SavePaymentRequest(
                      clientId:
                          viewModel.selectedClientForNewTransaction.clientId,
                      entryDate:
                          DateFormat('dd-MM-yyyy').format(viewModel.entryDate),
                      remarks: remarksController.text,
                      amount: double.parse(totalAmountController.text),
                      kilometers: double.parse(totalKmController.text),
                    ),
                  )
                      .then((value) {
                    totalAmountController.clear();
                    totalKmController.clear();
                    viewModel.selectedClientForNewTransaction = null;
                    selectedDateController.clear();
                    remarksController.clear();
                    //* call payment history api
                    viewModel.getPaymentHistory(
                        viewModel.selectedClientForTransactionList.clientId);
                    // * update the payment history list with the newly added transaction
                  });
                  Navigator.of(context).pop();
                } else {
                  viewModel.snackBarService
                      .showSnackbar(message: "Please Select Date");
                }
              } else {
                viewModel.snackBarService
                    .showSnackbar(message: "Please Select Client");
              }
            }
          },
        ),
      ),
    );
  }

  Widget totalKmView({BuildContext context, dynamic node}) {
    return appTextFormField(
      onEditingComplete: () => node.nextFocus(),
      enabled: true,
      formatter: [
        twoDigitDecimalPointFormatter(),
      ],
      controller: totalKmController,
      // autoFocus: true,
      focusNode: totalKmFocusNode,

      hintText: enterTotalKmHint,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      labelText: "Total Km",
      onFieldSubmitted: (_) {
        //! below code - on done, focus goes to next textField
        fieldFocusChange(context, totalKmFocusNode, totalAmountFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else if (double.parse(value) == 0) {
          return 'cannot be 0';
        } else {
          return null;
        }
      },
    );
  }

  Widget totalPaymentView({BuildContext context, dynamic node}) {
    return appTextFormField(
      onEditingComplete: () => node.nextFocus(),
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(7)
      ],
      controller: totalAmountController,
      focusNode: totalAmountFocusNode,
      hintText: enterTotalAmountHint,
      keyboardType: TextInputType.number,
      labelText: "Total Amount",
      onFieldSubmitted: (_) {
        //* below code - on done, focus goes to next textField
        // fieldFocusChange(context, totalAmountFocusNode, remarksFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else if (double.parse(value) == 0) {
          return 'cannot be 0';
        } else {
          return null;
        }
      },
    );
  }

  Widget selectDuration({PaymentsViewModel viewModel}) {
    return AppDropDown(
      optionList: selectDurationList,
      hint: "Select Duration",
      onOptionSelect: (selectedValue) {
        viewModel.selectedDuration = selectedValue;
        // print(viewModel.selectedDuration);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
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
                value: viewModel.totalAmt.toString(),
                iconName: rupeesIcon,
              ),
            ),
            // wSizedBox(5),
            Expanded(
              flex: 1,
              child: AppTiles(
                title: 'Payment Count',
                value: viewModel.noOfPayments.toString(),
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
                value: widget?.args?.totalKm?.toString() ?? "",
                iconName: totalKmIcon,
              ),
            ),
            // wSizedBox(5),
            Expanded(
              flex: 1,
              child: AppTiles(
                title: 'Due Kilometer',
                value: widget?.args?.dueKm?.toString() ?? "",
                iconName: paymentsIcon,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDashboradTileCard({
    String title,
    String value,
    PaymentsViewModel viewModel,
    String iconName,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Card(
        // color: color,
        shape: Border(
          left: BorderSide(color: AppColors.primaryColorShade5, width: 4),
        ),
        // shape: RoundedRectangleBorder(borderRadius: getBorderRadius(),),
        elevation: defaultElevation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 13,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.primaryColorShade5,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.primaryColorShade5,
                      fontSize: 20,
                    ),
                  ), //! make it dynamic
                ],
              ),
              // Text('logo'),
              Image.asset(
                iconName,
                height: distributorIconHeight,
                width: distributorIconWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
