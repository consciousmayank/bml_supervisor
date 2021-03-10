// Added by Vikas
// Subject to change

import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
      onModelReady: (viewModel) => viewModel.getClients(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('View Expenses', style: AppTextStyles.appBarTitleStyle),
        ),
        body: Padding(
          padding: getSidePadding(context: context),
          child: ListView(
            children: [
              selectClient(viewModel: viewModel),
              registrationSelector(context: context, viewModel: viewModel),
              selectDuration(viewModel: viewModel),
              hSizedBox(15),
              getExpenseListButton(
                viewModel: viewModel,
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ViewExpensesViewModel(),
    );
  }

  Widget selectClient({ViewExpensesViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) =>
          viewModel.selectedClient = selectedValue,
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
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
            if (viewModel.selectedDuration.length != 0) {
              viewModel.getExpensesList(
                regNum: selectedRegNoController.text.trim().toUpperCase(),
                selectedDuration: viewModel.selectedDuration,
                clientId: viewModel.selectedClient != null
                    ? viewModel.selectedClient.clientId
                    : '',
              );
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please select Duration');
            }
          },
        ),
      ),
    );
  }
}
