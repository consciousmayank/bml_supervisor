// Added by Vikas
// Subject to change

import 'package:bml_supervisor/screens/viewexpenses/view_expenses_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/app_level/themes.dart';

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
          title: Text('View Expenses'),
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
            //!
            // if (viewModel.selectedClient == null) {
            //   viewModel.snackBarService
            //       .showSnackbar(message: 'Please select Client');
            // } else if (viewModel.selectedDuration.length == 0) {
            //   viewModel.snackBarService
            //       .showSnackbar(message: 'Please select Duration');
            // } else {
            //   if (selectedRegNoController.text.length != 0) {
            //     viewModel.vehicleRegNumber =
            //         selectedRegNoController.text.toUpperCase();
            //   }
            //   viewModel.getExpensesList(
            //       selectedRegNoController.text.toUpperCase(),
            //       viewModel.selectedDuration);
            // }
            //!
            if (viewModel.selectedDuration.length != 0) {
              // if (selectedRegNoController.text.length != 0) {
              //   viewModel.vehicleRegNumber = selectedRegNoController.text;
              // }
              viewModel.getExpensesList(
                regNum: selectedRegNoController.text.trim().toUpperCase(),
                selectedDuration: viewModel.selectedDuration,
                clientId: viewModel.selectedClient != null
                    ? viewModel.selectedClient.id.toString()
                    : '',
                // viewModel.selectedClient != null
                //     ? viewModel.selectedClient.id.toString()
                //     : null,
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

class ClientsDropDown extends StatefulWidget {
  final List<GetClientsResponse> optionList;
  final GetClientsResponse selectedClient;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  ClientsDropDown(
      {@required this.optionList,
      this.selectedClient,
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
                    value: widget.selectedClient,
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
