import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'add_entry_logs_viewmodel.dart';

class AddVehicleEntryView extends StatefulWidget {
  @override
  _AddVehicleEntryViewState createState() => _AddVehicleEntryViewState();
}

class _AddVehicleEntryViewState extends State<AddVehicleEntryView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = ScrollController();
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddVehicleEntryViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getClients(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text("Add Entry 2.0"),
        ),
        body: viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: getSidePadding(context: context),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectClient(viewModel: viewModel),
                    registrationSelector(
                        context: context, viewModel: viewModel),
                    viewModel.vehicleLog == null
                        ? Container()
                        : dateSelector(context: context, viewModel: viewModel),
                    hSizedBox(15),
                    viewModel.vehicleLog == null
                        ? Container()
                        : addEntryButton(viewModel: viewModel),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => AddVehicleEntryViewModel(),
    );
  }

  Widget addEntryButton({AddVehicleEntryViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("Add Entry "),
          onPressed: () {
            // go to form page
            if (selectedDateController.text.length > 0) {
              viewModel.takeToAddEntry2PointOFormViewPage();
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: "Please select date");
            }
          },
        ),
      ),
    );
  }

  Widget selectClient({AddVehicleEntryViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClient = selectedValue;
      },
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }

  dateSelector({BuildContext context, AddVehicleEntryViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectDateButton(BuildContext context, AddVehicleEntryViewModel viewModel) {
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

  Future<DateTime> selectDate(AddVehicleEntryViewModel viewModel) async {
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
      firstDate: viewModel.datePickerEntryDate ??
          DateTime(1990), //! assignThisIfNotNull ?? OtherWiseAssignThis
      lastDate: DateTime.now(),
    );

    return picked;
  }

  selectedDateTextField(AddVehicleEntryViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Entry Date",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  registrationSelector(
      {BuildContext context, AddVehicleEntryViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
        selectRegButton(context, viewModel),
      ],
    );
  }

  registrationNumberTextField(AddVehicleEntryViewModel viewModel) {
    // viewModel.selectedVehicle != null
    //     ? selectedRegNoController.text =
    //         viewModel.selectedVehicle.registrationNumber
    //     : selectedRegNoController.text = "";
    return appTextFormField(
      enabled: true,
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

  selectRegButton(BuildContext context, AddVehicleEntryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          if (viewModel.selectedClient == null) {
            viewModel.snackBarService
                .showSnackbar(message: 'Please provide Client');
          } else if (selectedRegNoController.text.length == 0) {
            viewModel.snackBarService
                .showSnackbar(message: 'Please provide Reg no.');
          } else {
            viewModel.getEntryLogForLastDate(
                selectedRegNoController.text.trim().toUpperCase());
          }
        },
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
