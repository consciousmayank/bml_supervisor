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
import 'package:bml_supervisor/widget/app_dropdown.dart';

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
                  // viewModel.selectedSearchVehicle == null
                  //     ? Container()
                  //     : dateSelector(context: context, viewModel: viewModel),
                  // hSizedBox(20),
                  selectDuration(viewModel: viewModel),
                ],
              ),
              getExpenseListButton(
                viewModel: viewModel,
              ),
              // viewModel.selectedSearchVehicle == null
              //     ? Container()
              //     : searchButton(
              //         viewModel: viewModel,
              //       ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ViewExpensesViewModel(),
    );
  }

  Widget selectDuration({ViewExpensesViewModel viewModel}) {
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

  Widget registrationSelector(
      {BuildContext context, ViewExpensesViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
      ],
    );
  }

  Widget registrationNumberTextField(ViewExpensesViewModel viewModel) {
    viewModel.selectedSearchVehicle != null
        ? selectedRegNoController.text =
            viewModel.selectedSearchVehicle.registrationNumber
        : selectedRegNoController.text = "";
    return appTextFormField(
      enabled: true,
      controller: selectedRegNoController,
      // focusNode: selectedRegNoFocusNode,
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

  Widget getExpenseListButton({ViewExpensesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("Get Expenses List"),
          onPressed: () {
            if (viewModel.selectedDuration.length == 0) {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please select Duration');
            } else {
              if (selectedRegNoController.text.length != 0) {
                viewModel.vehicleRegNumber = selectedRegNoController.text;
              }
              viewModel.getExpensesList();

              // getExpensesList(selectedRegNoController.text,
              //     selectedDateController.text, viewModel);
            }
          },
        ),
      ),
    );
  }
}
