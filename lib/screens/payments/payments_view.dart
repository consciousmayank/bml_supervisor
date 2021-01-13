import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml_supervisor/screens/payments/payments_viewmodel.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';

class PaymentsView extends StatefulWidget {
  @override
  _PaymentsViewState createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode totalKmFocusNode = FocusNode();
  final TextEditingController totalKmController = TextEditingController();

  final FocusNode totalAmountFocusNode = FocusNode();
  final TextEditingController totalAmountController = TextEditingController();

  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      onModelReady: (viewModel) => viewModel.getClients(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('Payments'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //* open bottom sheet to add the transaction
                  showAddNewPaymentBottomSheet(context, viewModel);
                })
          ],
        ),
        body: Padding(
          padding: getSidePadding(context: context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectClientForTransactionList(viewModel: viewModel),
              selectDuration(viewModel: viewModel),
              hSizedBox(15),
              // ! show heading and list when payment list has data
              // viewModel.paymentHistoryResponseList.length > 0
              //     ? Expanded(child: buildHeading())
              //     : Container(),
              // buildHeading(),
              viewModel.paymentHistoryResponseList.length > 0
                  ? buildHeading()
                  : Container(),
              viewModel.paymentHistoryResponseList.length > 0
                  ? Expanded(
                      child: buildTransactionsTableData(
                          context, viewModel.paymentHistoryResponseList))
                  : Container(),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => PaymentsViewModel(),
    );
  }

  Widget buildTransactionsTableData(BuildContext context,
      List<PaymentHistoryResponse> paymentHistoryResponseList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Scrollbar(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Row(
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
            );
          },
          itemCount: paymentHistoryResponseList.length,
        ),
      ),
    );
  }

  Widget buildHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ('DATE'),
          ),
          Text(
            ('KMs'),
          ),
          Text(
            ('AMOUNT'),
          ),
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
    showModalBottomSheet(
        // isScrollControlled: true,
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: getBorderRadius(),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: ListView(children: [
                      selectClientForNewTransaction(viewModel: viewModel),
                      dateSelector(context: context, viewModel: viewModel),
                      totalKmView(),
                      // totalKmView(),
                      totalPaymentView(),
                      addNewPaymentButton(viewModel: viewModel),
                    ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget addNewPaymentButton({PaymentsViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("Add New Payment"),
          onPressed: () {
            //* hit add transaction api
            if (_formKey.currentState.validate()) {
              if (viewModel.selectedClientForNewTransaction != null) {
                if (viewModel.emptyDateSelector) {
                  viewModel.addNewPayment(
                    SavePaymentRequest(
                      clientId: viewModel.selectedClientForNewTransaction.id,
                      entryDate:
                          DateFormat('dd-MM-yyyy').format(viewModel.entryDate),
                      remarks: null,
                      amount: double.parse(totalAmountController.text),
                      kilometers: double.parse(totalKmController.text),
                    ),
                  );
                  totalAmountController.clear();
                  totalKmController.clear();
                  viewModel.selectedClientForNewTransaction = null;
                  selectedDateController.clear();
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

  Widget totalKmView() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(7)
      ],
      controller: totalKmController,
      focusNode: totalKmFocusNode,
      hintText: enterTotalKmHint,
      keyboardType: TextInputType.number,
      labelText: "Total Km",
      onFieldSubmitted: (_) {
        //! below code - on done, focus goes to next textField
        // fieldFocusChange(
        // context, endReadingFocusNode, vehicleLoadCapacityFocusNode);
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

  Widget totalPaymentView() {
    return appTextFormField(
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
        //! below code - on done, focus goes to next textField
        // fieldFocusChange(
        // context, endReadingFocusNode, vehicleLoadCapacityFocusNode);
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
        viewModel
            .getPaymentHistory(viewModel.selectedClientForTransactionList.id);
      },
      selectedValue: viewModel.selectedClientForTransactionList == null
          ? null
          : viewModel.selectedClientForTransactionList,
    );
  }
}

Widget selectClientForNewTransaction({PaymentsViewModel viewModel}) {
  return ClientsDropDown(
    optionList: viewModel.clientsList,
    hint: "Select Client",
    onOptionSelect: (GetClientsResponse selectedValue) {
      viewModel.selectedClientForNewTransaction = selectedValue;
      print(
          'new transaction: client-${viewModel.selectedClientForNewTransaction.title}');
    },
    selectedValue: viewModel.selectedClientForNewTransaction == null
        ? null
        : viewModel.selectedClientForNewTransaction,
  );
}

class ClientsDropDown extends StatefulWidget {
  final List<GetClientsResponse> optionList;
  final GetClientsResponse selectedValue;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  ClientsDropDown(
      {@required this.optionList,
      this.selectedValue,
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _ClientsDropDownState createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  List<DropdownMenuItem<GetClientsResponse>> dropdown = [];

  List<DropdownMenuItem<GetClientsResponse>> getDropDownItems() {
    List<DropdownMenuItem<GetClientsResponse>> dropdown =
        List<DropdownMenuItem<GetClientsResponse>>();

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].title}",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        value: widget.optionList[i],
      ));
    }
    return dropdown;
  }

  @override
  Widget build(BuildContext context) {
    return widget.optionList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.hint ?? ""),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: DropdownButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: ThemeConfiguration.primaryBackground,
                      ),
                    ),
                    underline: Container(),
                    isExpanded: true,
                    style: textFieldStyle(
                        fontSize: 15.0, textColor: Colors.black54),
                    value: widget.selectedValue,
                    items: getDropDownItems(),
                    onChanged: (value) {
                      widget.onOptionSelect(value);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  TextStyle textFieldStyle({double fontSize, Color textColor}) {
    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal);
  }
}
