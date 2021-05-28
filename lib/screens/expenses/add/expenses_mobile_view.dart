import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/models/expense_response.dart';
import 'package:bml_supervisor/models/get_daily_kilometers_info.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
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
      // onModelReady: (viewModel) => viewModel.getClients(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: setAppBarTitle(title: 'Add Expense'),
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
    if (viewModel.clearData) clearData(viewModel: viewModel);


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
      helpText: 'Select Date',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Expiration Date',
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: new DateTime.now(),
    );

    return picked;
  }

  submitExpensesForm({BuildContext context, ExpensesViewModel viewModel}) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          appTextFormField(
            buttonType: ButtonType.FULL,
            buttonIcon: Icon(Icons.calendar_today_outlined),
            onButtonPressed: (() async {
              DateTime selectedDate = await selectDate();
              if (selectedDate != null) {
                selectedDateController.text = getDateString(selectedDate);
                viewModel.entryDate = selectedDate;
                viewModel.getInfo();
              }
            }),
            enabled: false,
            controller: selectedDateController,
            focusNode: selectedDateFocusNode,
            hintText: "Select Entry Date",
            labelText: "Entry Date",
            keyboardType: TextInputType.text,
          ),

          if (viewModel.entryDate != null)
            viewModel.dailyKmInfoList.length > 0
                ? BottomSheetDropDown<
                    GetDailyKilometerInfo>.getDailyKilometerInfo(
                    allowedValue: viewModel.dailyKmInfoList,
                    selectedValue: viewModel.selectedDailyKmInfo == null
                        ? null
                        : viewModel.selectedDailyKmInfo,
                    hintText: "Select Client-Vehicle",
                    onValueSelected:
                        (GetDailyKilometerInfo selectedValue, int index) {
                      viewModel.showSubmitForm = true;
                      viewModel.selectedDailyKmInfo = selectedValue;
                    },
                  )
                : appTextFormField(
                    vehicleOwnerName: viewModel.validatedRegistrationNumber ==
                            null
                        ? null
                        : "(${viewModel.validatedRegistrationNumber.ownerName}, ${viewModel.validatedRegistrationNumber.model})",
                    enabled: true,
                    controller: selectedRegNoController,
                    focusNode: selectedRegNoFocusNode,
                    hintText: drRegNoHint,
                    onTextChange: (String value) {
                      viewModel.selectedDailyKmInfo = viewModel
                          .selectedDailyKmInfo
                          .copyWith(vehicleId: value);
                    },
                    keyboardType: TextInputType.text,
                    buttonType: ButtonType.SMALL,
                    buttonIcon: Icon(Icons.search),
                    onButtonPressed: () {
                      viewModel.validateRegistrationNumber(
                          regNum: viewModel.selectedDailyKmInfo.vehicleId);
                    },
                    onFieldSubmitted: (_) {
                      viewModel.validateRegistrationNumber(
                          regNum: viewModel.selectedDailyKmInfo.vehicleId);
                    }),

          /* viewModel.showSubmitForm
              ?  */
          if (viewModel.entryDate != null)
            AppDropDown(
              showUnderLine: true,
              selectedValue:
                  viewModel.expenseType != null ? viewModel.expenseType : null,
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
          // : Container(),
          hSizedBox(10),

          // viewModel.showSubmitForm
          //     ? getAmount(context: context, viewModel: viewModel)
          //     : Container(),
          if (viewModel.entryDate != null)
            getAmount(context: context, viewModel: viewModel),
          hSizedBox(10),
          // viewModel.showSubmitForm
          //     ? getDescription(context: context, viewModel: viewModel)
          //     : Container(),
          if (viewModel.entryDate != null)
            getDescription(context: context, viewModel: viewModel),
          hSizedBox(10),
          if (viewModel.entryDate != null)
            saveExpenseButton(context: context, viewModel: viewModel)
          // viewModel.showSubmitForm
          //     ? saveExpenseButton(context: context, viewModel: viewModel)
          //     : Container(),
        ],
      ),
    );
  }

  // Widget selectClient({ExpensesViewModel viewModel}) {
  //   return ClientsDropDown(
  //     optionList: viewModel.clientsList,
  //     hint: "Select Client",
  //     onOptionSelect: (GetClientsResponse selectedValue) {
  //       viewModel.selectedClient = selectedValue;
  //       // ! use print() it for debugging
  //       // print('selected client id: ${viewModel.selectedClient.id}');
  //       // print('selected client: ${viewModel.selectedClient.title}');
  //     },
  //     selectedClient:
  //         viewModel.selectedClient == null ? null : viewModel.selectedClient,
  //   );
  // }

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
      child: ElevatedButton(
        onPressed: () {
          // ! Validation Code Below
          if (_formKey.currentState.validate()) {
            // ignore: todo
            //TODO: Refactor the if(s) and else(s)
            if (viewModel.expenseType != null) {
              if (viewModel.selectedDailyKmInfo.vehicleId.length > 1) {
                viewModel.saveExpense(
                  SaveExpenseRequest(
                    clientId: viewModel.selectedDailyKmInfo.clientId,
                    vehicleId: viewModel.selectedDailyKmInfo.vehicleId,
                    // viewModel.selectedSearchVehicle.registrationNumber,
                    entryDate:
                        DateFormat('dd-MM-yyyy').format(viewModel.entryDate),
                    expenseType: viewModel.expenseType,
                    expenseAmount: double.parse(amountController.text),
                    expenseDesc: descriptionController.text,
                  ),
                );
              } else if (viewModel.dailyKmInfoList.length == 0) {
                viewModel.snackBarService.showCustomSnackBar(
                  variant: SnackbarType.ERROR,
                  duration: Duration(seconds: 4),
                  message: 'Please Select Vehicle Id',
                  mainButtonTitle: 'Ok',
                  onMainButtonTapped: () {
                    selectedRegNoFocusNode.requestFocus();
                  },
                );
              } else {
                viewModel.snackBarService.showCustomSnackBar(
                  variant: SnackbarType.ERROR,
                  duration: Duration(seconds: 4),
                  message: 'Please Select Client-Vehicle',
                );
              }
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

  void clearData({ExpensesViewModel viewModel}) {
    selectedRegNoController.clear();
    selectedDateController.clear();
    amountController.clear();
    descriptionController.clear();
    viewModel.clearData = false;
  }
}

class DailyKmInfoDropDown extends StatefulWidget {
  final List<GetDailyKilometerInfo> optionList;
  final GetDailyKilometerInfo selectedInfo;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  DailyKmInfoDropDown(
      {@required this.optionList,
      this.selectedInfo,
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _ClientsDropDownState createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<DailyKmInfoDropDown> {
  List<DropdownMenuItem<GetDailyKilometerInfo>> dropdown = [];

  List<DropdownMenuItem<GetDailyKilometerInfo>> getDropDownItems() {
    List<DropdownMenuItem<GetDailyKilometerInfo>> dropdown =
        <DropdownMenuItem<GetDailyKilometerInfo>>[];

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].clientId} - ${widget.optionList[i].vehicleId}(${widget.optionList[i].routeTitle})",
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
                    value: widget.selectedInfo,
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
