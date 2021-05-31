import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/expense_response.dart';
import 'package:bml_supervisor/models/get_daily_kilometers_info.dart';
import 'package:bml_supervisor/screens/expenses/add/add_expense_arguments.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'expenses_viewmodel.dart';

class ExpensesMobileView extends StatefulWidget {
  final AddExpenseArguments args;

  const ExpensesMobileView({Key key, @required this.args}) : super(key: key);
  @override
  _ExpensesMobileViewState createState() => _ExpensesMobileViewState();
}

class _ExpensesMobileViewState extends State<ExpensesMobileView> {
  final FocusNode selectedRegNoFocusNode = FocusNode();
  final FocusNode selectedDateFocusNode = FocusNode();
  TextEditingController selectedRegNoController = TextEditingController();
  TextEditingController selectedDateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  FocusNode fuelLitreFocusNode = FocusNode();
  FocusNode fuelReadingFocusNode = FocusNode();
  FocusNode fuelRateFocusNode = FocusNode();
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
    widget.args.expensesTypes.removeAt(0);
    return ViewModelBuilder<ExpensesViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: setAppBarTitle(title: 'Add Expense'),
        ),
        body: viewModel.isBusy
            ? ShimmerContainer(
                itemCount: 10,
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
    return ListView(
      children: [
        appTextFormField(
          errorText: viewModel.entryDateError.length > 0
              ? viewModel.entryDateError
              : '',
          hintText: "Select Entry Date",
          buttonType: ButtonType.FULL,
          buttonIcon: Icon(Icons.calendar_today_outlined),
          onButtonPressed: (() async {
            selectDateFunction(viewModel: viewModel);
          }),
          enabled: false,
          controller: selectedDateController,
          focusNode: selectedDateFocusNode,
          keyboardType: TextInputType.text,
        ),
        // if (viewModel.entryDate != null)
        appTextFormField(
            errorText: viewModel.vehicleIdError.length > 0
                ? viewModel.vehicleIdError
                : '',
            hintText: 'Search for Vechicle',
            vehicleOwnerName: viewModel.validatedRegistrationNumber == null
                ? null
                : "(${viewModel.validatedRegistrationNumber.ownerName}, ${viewModel.validatedRegistrationNumber.model})",
            enabled: true,
            controller: selectedRegNoController,
            focusNode: selectedRegNoFocusNode,
            onTextChange: (String value) {
              viewModel.selectedDailyKmInfo =
                  viewModel.selectedDailyKmInfo.copyWith(vehicleId: value);
              viewModel.vehicleIdError = '';
              viewModel.notifyListeners();
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
        // if (viewModel.entryDate != null)
        BottomSheetDropDown<String>(
          errorText: viewModel.expenseTypeError.length > 0
              ? viewModel.expenseTypeError
              : '',
          allowedValue: widget.args.expensesTypes,
          selectedValue:
              viewModel.expenseType == null ? '' : viewModel.expenseType,
          hintText: 'Select Expense Type',
          onValueSelected: (String selectedValue, int index) {
            viewModel.expenseType = selectedValue;
            viewModel.expenseTypeError = '';
            viewModel.notifyListeners();
          },
        ),
        if (viewModel.expenseType == "FUEL")
          getFuelDetailsRow(
            context: context,
            viewModel: viewModel,
          ),
        // if (viewModel.entryDate != null)
        getAmount(context: context, viewModel: viewModel),
        // if (viewModel.entryDate != null)
        getDescription(context: context, viewModel: viewModel),
        // if (viewModel.entryDate != null)
        Padding(
          padding: const EdgeInsets.all(4),
          child: saveExpenseButton(context: context, viewModel: viewModel),
        )
      ],
    );
  }

  getAmount({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      onTextChange: (String value) {
        viewModel.expenseAmount = double.parse(value.length > 0 ? value : 0);
        viewModel.totalAmountError = '';
        viewModel.notifyListeners();
      },
      errorText: viewModel.totalAmountError.length > 0
          ? viewModel.totalAmountError
          : '',
      hintText: fuelAmountHint,
      showRupeesSymbol: false,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      controller: amountController,
      focusNode: amountFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, amountFocusNode, descriptionFocusNode);
      },
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          viewModel.totalAmountError = textRequired;
        } else if (double.parse(value) == 0) {
          viewModel.totalAmountError = "cannot be 0";
        }
        viewModel.notifyListeners();
        return null;
      },
    );
  }

  getDescription({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      onTextChange: (String value) {
        viewModel.expenseDescription = value;
        viewModel.descriptionError = '';
        viewModel.notifyListeners();
      },
      inputDecoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
      ),
      hintText: 'Description',
      maxLines: 6,
      enabled: true,
      controller: descriptionController,
      focusNode: descriptionFocusNode,
      onFieldSubmitted: (_) {
        descriptionFocusNode.unfocus();
      },
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      validator: (value) {
        if (value.isEmpty) {
          viewModel.descriptionError = textRequired;
        }
        viewModel.notifyListeners();
        return null;
      },
    );
  }

  selectDateFunction({@required ExpensesViewModel viewModel}) async {
    DateTime selectedDate = await selectDate();
    if (selectedDate != null) {
      selectedDateController.text = getDateString(selectedDate);
      viewModel.entryDate = selectedDate;
      viewModel.entryDateError = '';
      viewModel.notifyListeners();
    }
  }

  onErrorOccured({
    @required WidgetType widgetType,
    @required ExpensesViewModel viewModel,
  }) {
    switch (widgetType) {
      case WidgetType.VEHICLE_SEARCH_WIDGET:
        selectedRegNoFocusNode.requestFocus();
        break;
      case WidgetType.SELECTE_EXPENSE_WIDGET:
        break;
      case WidgetType.AMOUNT_WIDGET:
        amountFocusNode.requestFocus();
        break;
      case WidgetType.DESCRIPTION_WIDGET:
        descriptionFocusNode.requestFocus();
        break;
      case WidgetType.FUEL_METER_READING:
        fuelReadingFocusNode.requestFocus();
        break;
      case WidgetType.FUEL_LITERS:
        fuelLitreFocusNode.requestFocus();
        break;
      case WidgetType.FUEL_RATE:
        fuelRateFocusNode.requestFocus();
        break;
      case WidgetType.ENTRY_DATE_WIDGET:
        selectDateFunction(
          viewModel: viewModel,
        );
        break;
    }
  }

  saveExpenseButton({
    BuildContext context,
    ExpensesViewModel viewModel,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          // ! Validation Code Below
          if (viewModel.validateViews(
              onErrorOccured: (widgetType) => onErrorOccured(
                  widgetType: widgetType, viewModel: viewModel))) {
            viewModel.saveExpense();
          }
        },
        child: Text("Submit"),
      ),
    );
  }

  getFuelDetailsRow({BuildContext context, ExpensesViewModel viewModel}) {
    return Row(
      children: [
        Expanded(
          child: getFuelMeterReading(
            context: context,
            viewModel: viewModel,
          ),
          flex: 1,
        ),
        Expanded(
          child: getFuelLitre(
            context: context,
            viewModel: viewModel,
          ),
          flex: 1,
        ),
        Expanded(
          child: getFuelRate(
            context: context,
            viewModel: viewModel,
          ),
          flex: 1,
        ),
      ],
    );
  }

  getFuelLitre({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      onTextChange: (String value) {
        viewModel.fuelLitre = double.parse(value.length > 0 ? value : 0);
        viewModel.fuelLitreError = '';
        viewModel.notifyListeners();
      },
      errorText:
          viewModel.fuelLitreError.length > 0 ? viewModel.fuelLitreError : '',
      hintText: fuelLitreHint,
      enabled: true,
      focusNode: fuelLitreFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, fuelLitreFocusNode, fuelRateFocusNode);
      },
      keyboardType: TextInputType.number,
    );
  }

  getFuelMeterReading({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      onTextChange: (String value) {
        viewModel.fuelMeterReading = int.parse(value.length > 0 ? value : 0);
        viewModel.fuelMeterReadingError = '';
        viewModel.notifyListeners();
      },
      errorText: viewModel.fuelMeterReadingError.length > 0
          ? viewModel.fuelMeterReadingError
          : '',
      hintText: fuelMeterReadingHint,
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().numericFormatter,
      ],
      focusNode: fuelReadingFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, fuelReadingFocusNode, fuelLitreFocusNode);
      },
      keyboardType: TextInputType.number,
    );
  }

  getFuelRate({BuildContext context, ExpensesViewModel viewModel}) {
    return appTextFormField(
      onTextChange: (String value) {
        viewModel.fuelRate = double.parse(value.length > 0 ? value : 0);
        viewModel.fuelRateError = '';
        viewModel.notifyListeners();
      },
      errorText:
          viewModel.fuelRateError.length > 0 ? viewModel.fuelRateError : '',
      hintText: fuelRateHint,
      enabled: true,
      focusNode: fuelRateFocusNode,
      onFieldSubmitted: (_) {
        viewModel.expenseAmount = viewModel.fuelRate * viewModel.fuelLitre;
        amountController.text = viewModel.expenseAmount.toStringAsFixed(2);
        fieldFocusChange(context, fuelRateFocusNode, descriptionFocusNode);
      },
      keyboardType: TextInputType.number,
    );
  }
}

enum WidgetType {
  ENTRY_DATE_WIDGET,
  VEHICLE_SEARCH_WIDGET,
  SELECTE_EXPENSE_WIDGET,
  AMOUNT_WIDGET,
  DESCRIPTION_WIDGET,
  FUEL_METER_READING,
  FUEL_LITERS,
  FUEL_RATE,
}
