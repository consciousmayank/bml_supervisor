// Added by Vikas
// Subject to change

import 'package:bml_supervisor/screens/viewexpenses/view_expenses_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:intl/intl.dart';

class ViewExpensesView extends StatefulWidget {
  @override
  _ViewExpensesViewState createState() => _ViewExpensesViewState();
}

class _ViewExpensesViewState extends State<ViewExpensesView> {
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewExpensesViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('View Expenses'),
        ),
        body: Padding(
          padding: getSidePadding(context: context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  registrationSelector(context: context, viewModel: viewModel),
                  viewModel.selectedSearchVehicle == null
                      ? Container()
                      : dateSelector(context: context, viewModel: viewModel),
                  hSizedBox(20),
                ],
              ),
              viewModel.selectedSearchVehicle == null
                  ? Container()
                  : searchButton(
                      viewModel: viewModel,
                    ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ViewExpensesViewModel(),
    );
  }

  dateSelector({BuildContext context, ViewExpensesViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectedDateTextField(ViewExpensesViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Show Expenses From",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  selectDateButton(BuildContext context, ViewExpensesViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.calendar_today_outlined),
        onPressed: (() async {
          DateTime selectedDate = await selectDate(viewModel);
          if (selectedDate != null) {
            selectedDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
            viewModel.fromDate = selectedDate;
            // viewModel.getEntryForSelectedDate();
            viewModel.emptyDateSelector = true;
          }
        }),
      ),
    );
  }

  Future<DateTime> selectDate(ViewExpensesViewModel viewModel) async {
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
      lastDate: new DateTime.now(),
    );

    return picked;
  }

  Widget registrationSelector(
      {BuildContext context, ViewExpensesViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            selectRegButton(context, viewModel),
          ],
        ))
      ],
    );
  }

  Widget registrationNumberTextField(ViewExpensesViewModel viewModel) {
    viewModel.selectedSearchVehicle != null
        ? selectedRegNoController.text =
            viewModel.selectedSearchVehicle.registrationNumber
        : selectedRegNoController.text = "";
    return appTextFormField(
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
    );
  }

  Widget searchButton({ViewExpensesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("Get Expenses List"),
          onPressed: () {
            if (selectedDateController.text.length == 0) {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please select a date');
            } else {
              print(DateFormat('dd-MM-yyyy')
                  .format(DateTime.now())
                  .toLowerCase());
              print(selectedDateController.text);
              print(selectedRegNoController.text);
              viewModel.vehicleRegNumber = selectedRegNoController.text;
              getExpensesList(selectedRegNoController.text,
                  selectedDateController.text, viewModel);
            }
            // vehicleEntrySearch(
            //   context,
            //   viewModel,
            //   viewModel.selectedDuration,
            // );
          },
        ),
      ),
    );
  }

  void getExpensesList(
    String vehicleRegNumber,
    String fromDate,
    ViewExpensesViewModel viewModel,
  ) {
    viewModel.getExpensesList(vehicleRegNumber, fromDate);
  }

  Widget selectRegButton(
      BuildContext context, ViewExpensesViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          viewModel.takeToSearch();
        },
      ),
    );
  }
}
