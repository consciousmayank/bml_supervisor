import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/payments/payments_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class PaymentsView extends StatefulWidget {
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
          title: Text('Payments', style: AppTextStyles.appBarTitleStyle),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: getPaymentScreenSidePadding(),
              child: selectClientForTransactionList(viewModel: viewModel),
            ),
            // Padding(
            //   padding: getPaymentScreenSidePadding(),
            //   child: selectDuration(viewModel: viewModel),
            // ),
            // hSizedBox(15),
            viewModel.paymentHistoryResponseList.length > 0
                ? Padding(
                    padding: getPaymentScreenSidePadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: buildChip(
                            title: 'Total Amt',
                            value: viewModel.totalAmt.toString(),
                          ),
                        ),
                        wSizedBox(5),
                        Expanded(
                          flex: 1,
                          child: buildChip(
                            title: 'Payments',
                            value: viewModel.noOfPayments.toString(),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            viewModel.paymentHistoryResponseList.length > 0
                ? Expanded(
                    child: Padding(
                      padding: getPaymentScreenSidePadding(),
                      child: Card(
                        shape: getCardShape(),
                        child: Column(
                          // !Refer this if listview is troubling

                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            buildHeading(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Container(
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 60),
                                child: buildTransactionsTableData(context,
                                    viewModel.paymentHistoryResponseList),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget buildTransactionsTableData(BuildContext context,
      List<PaymentHistoryResponse> paymentHistoryResponseList) {
    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      paymentHistoryResponseList[index].entryDate,
                    ),
                    Text(
                      paymentHistoryResponseList[index].kilometers.toString(),
                    ),
                    Text(
                      paymentHistoryResponseList[index].amount.toString(),
                    ),
                  ],
                ),
              ),
              index + 1 != paymentHistoryResponseList.length
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    )
                  : Container(),
              // Divider(
              //   color: Colors.black,
              // ),
            ],
          );
        },
        itemCount: paymentHistoryResponseList.length,
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
      helpText: 'Registration Expires on',
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(defaultBorder),
            topRight: Radius.circular(defaultBorder),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: Scrollbar(
                controller: _scrollController,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Padding(
                        padding: getPaymentScreenSidePadding(),
                        child:
                            selectClientForNewTransaction(viewModel: viewModel),
                      ),
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
        // remarksFocusNode.unfocus();
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
        // fieldFocusChange(context, totalKmFocusNode, totalAmountFocusNode);
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
        print(viewModel.selectedDuration);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
    );
  }

  Widget selectClientForTransactionList({PaymentsViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClientForTransactionList = selectedValue;
        print(
            'transaction list: client - ${viewModel.selectedClientForTransactionList.title}');
        //* call client specific payment history
        viewModel.getPaymentHistory(
            viewModel.selectedClientForTransactionList.clientId);
      },
      selectedClient: viewModel.selectedClientForTransactionList == null
          ? null
          : viewModel.selectedClientForTransactionList,
    );
  }
}

Widget selectClientForNewTransaction({PaymentsViewModel viewModel}) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return ClientsDropDown(
        optionList: viewModel.clientsList,
        hint: "Select Client",
        onOptionSelect: (GetClientsResponse selectedValue) {
          setState(
              () => viewModel.selectedClientForNewTransaction = selectedValue);

          print(
              'new transaction: client-${viewModel.selectedClientForNewTransaction.title}');
        },
        selectedClient: viewModel.selectedClientForNewTransaction == null
            ? null
            : viewModel.selectedClientForNewTransaction,
      );
    },
  );
}
