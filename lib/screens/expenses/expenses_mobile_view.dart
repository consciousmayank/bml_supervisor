import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/expense_response.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'expenses_viewmodel.dart';

class ExpensesMobileView extends StatefulWidget {
  @override
  _ExpensesMobileViewState createState() => _ExpensesMobileViewState();
}

class _ExpensesMobileViewState extends State<ExpensesMobileView> {
  final FocusNode selectedRegNoFocusNode = FocusNode();
  final FocusNode selectedDateFocusNode = FocusNode();
  TextEditingController selectedRegNoController = TextEditingController();
  TextEditingController selectedDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  ScrollController scrollController;

  TextEditingController descriptionController = TextEditingController();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExpensesViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text("Add Expenses"),
        ),
        body: viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: getSidePadding(context: context),
                child: body(context, viewModel),
              ),
      ),
      viewModelBuilder: () => ExpensesViewModel(),
    );
  }

  body(BuildContext context, ExpensesViewModel viewModel) {
    if (viewModel.selectedSearchVehicle != null) {
      selectedRegNoController = TextEditingController(
          text: viewModel.selectedSearchVehicle.registrationNumber);
    } else {
      selectedRegNoController = TextEditingController();
    }

    return AbsorbPointer(
      absorbing: viewModel.isExpenseListLoading,
      child: submitExpensesForm(context: context, viewModel: viewModel),
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
      helpText: 'Registration Expires on',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Expiration Date',
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: new DateTime(2035),
    );

    return picked;
  }

  submitExpensesForm({BuildContext context, ExpensesViewModel viewModel}) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: headerText("Vehicle Expenses"),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: appTextFormField(
                  enabled: false,
                  controller: selectedRegNoController,
                  focusNode: selectedRegNoFocusNode,
                  hintText: drRegNoHint,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return textRequired;
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, right: 4),
                child: appSuffixIconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    viewModel.entryDate = null;
                    viewModel.takeToSearch();
                  },
                ),
              ),
            ],
          ),
          viewModel.selectedSearchVehicle == null
              ? Container()
              : Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    appTextFormField(
                      enabled: false,
                      controller: selectedDateController,
                      focusNode: selectedDateFocusNode,
                      hintText: "Select Entry Date",
                      labelText: "Entry Date",
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
                      child: appSuffixIconButton(
                        icon: Icon(Icons.calendar_today_outlined),
                        onPressed: (() async {
                          DateTime selectedDate = await selectDate();
                          if (selectedDate != null) {
                            viewModel.entryDate = selectedDate;
                            viewModel.showSubmitForm = true;
                          }
                        }),
                      ),
                    ),
                  ],
                ),
          viewModel.entryDate == null
              ? Container()
              : AppDropDown(
                  showUnderLine: true,
                  selectedValue: viewModel.expenseType != null
                      ? viewModel.expenseType
                      : null,
                  hint: "Select Expense",
                  onOptionSelect: (selectedValue) {
                    viewModel.expenseType = selectedValue;
                    // if (viewModel.selectedSearchVehicle != null &&
                    //     viewModel.entryDate != null) {
                    //   viewModel.getExpensesList();
                    // }
                  },
                  optionList: expenseTypes,
                ),
          hSizedBox(10),
          viewModel.entryDate == null
              ? Container()
              : getAmount(context: context, viewModel: viewModel),
          hSizedBox(10),
          viewModel.entryDate == null
              ? Container()
              : getDescription(context: context, viewModel: viewModel),
          hSizedBox(10),
          viewModel.entryDate == null
              ? Container()
              : saveExpenseButton(context: context, viewModel: viewModel),
        ],
      ),
    );
  }

  getAmount({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      showRupeesSymbol: true,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      controller: amountController,
      focusNode: amountFocusNode,
      hintText: fuelAmountHint,
      labelText: "Amount",
      onFieldSubmitted: (_) {
        fieldFocusChange(context, amountFocusNode, descriptionFocusNode);
      },
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else if (double.parse(value) == 0) {
          return "cannot be 0";
        } else {
          return null;
        }
      },
    );
  }

  getDescription({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      maxLines: 3,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      controller: descriptionController,
      focusNode: descriptionFocusNode,
      onFieldSubmitted: (_) {
        descriptionFocusNode.unfocus();
      },
      hintText: "Description",
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  saveExpenseButton({BuildContext context, ExpensesViewModel viewModel}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: buttonHeight,
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (viewModel.expenseType != null) {
              viewModel.saveExpense(SaveExpenseRequest(
                  vehicleId: viewModel.selectedSearchVehicle.registrationNumber,
                  entryDate:
                      DateFormat('dd-MM-yyyy').format(viewModel.entryDate),
                  expenseType: viewModel.expenseType,
                  expenseAmount: double.parse(amountController.text),
                  expenseDesc: descriptionController.text,
                  status: false));
              descriptionFocusNode.unfocus();
              amountFocusNode.unfocus();
              amountController.clear();
              descriptionController.clear();
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: "Please Select Expense Type");
            }
          }
        },
        child: Text("Submit"),
      ),
    );
  }

  expenseTypeAndAmount(ExpenseResponse singleEntry) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        singleColumn("Expense Type: ", singleEntry.expenseType),
        singleColumn("Amount: ", "$rupeeSymbol${singleEntry.expenseAmount}")
      ]),
    );
  }

  description(ExpenseResponse singleEntry) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        singleColumn("Description: ", singleEntry.expenseDesc),
      ]),
    );
  }
}
