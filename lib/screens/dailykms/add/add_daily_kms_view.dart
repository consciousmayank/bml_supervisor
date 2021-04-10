import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'add_daily_kms_viewmodel.dart';

class AddVehicleEntryView extends StatefulWidget {
  @override
  _AddVehicleEntryViewState createState() => _AddVehicleEntryViewState();
}

class _AddVehicleEntryViewState extends State<AddVehicleEntryView> {
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
          title: Text(
              "Add Daily Kms - ${MyPreferences().getSelectedClient().clientId}",
              style: AppTextStyles.appBarTitleStyle),
        ),
        body: viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: getSidePadding(context: context),
                child: ListView(
                  children: [
                    dateSelector(context: context, viewModel: viewModel),

                    // viewModel.clientsList.length == 0
                    //     ? Container()
                    //     : selectClient(viewModel: viewModel),

                    viewModel.routesList.length == 0
                        ? Container()
                        : RoutesDropDown(
                            optionList: viewModel.routesList,
                            hint: "Select Routes",
                            onOptionSelect:
                                (RoutesForSelectedClientAndDateResponse
                                    selectedValue) {
                              viewModel.selectedRoute = selectedValue;
                              viewModel.vehicleLog = null;
                            },
                            selectedValue: viewModel.selectedRoute == null
                                ? null
                                : viewModel.selectedRoute,
                          ),

                    viewModel.selectedRoute == null
                        ? Container()
                        : registrationSelector(
                            context: context, viewModel: viewModel),

                    viewModel.vehicleLog != null
                        ? loadLastEntry(viewModel: viewModel)
                        : Container(),
                    //
                    // // viewModel.vehicleLog .endReading == null ? :

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
        padding: const EdgeInsets.only(top: 8),
        child: AppButton(
          background: AppColors.primaryColorShade5,
          buttonText: "Submit",
          borderColor: AppColors.primaryColorShade4,
          onTap: () {
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

  // Widget selectClient({AddVehicleEntryViewModel viewModel}) {
  //   return ClientsDropDown(
  //     optionList: viewModel.clientsList,
  //     hint: "Select Client",
  //     onOptionSelect: (GetClientsResponse selectedValue) {
  //       viewModel.selectedRoute = null;
  //       selectedRegNoController.clear();
  //       viewModel.vehicleLog = null;
  //       viewModel.selectedClient = selectedValue;
  //       viewModel.getRoutesForSelectedClientAndDate(selectedValue.clientId);
  //     },
  //     selectedClient:
  //         viewModel.selectedClient == null ? null : viewModel.selectedClient,
  //   );
  // }

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
            viewModel.selectedRoute = null;
            viewModel.vehicleLog = null;

            selectedDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
            viewModel.entryDate = selectedDate;
            viewModel.getRoutesForSelectedClientAndDate(
                viewModel.selectedClient.clientId);
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
      helpText: 'Select Date',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Expiration Date',
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: DateTime.now(),
      firstDate: viewModel.datePickerEntryDate ?? DateTime(1990),
      //! assignThisIfNotNull ?? OtherWiseAssignThis
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
          child: registrationNumberTextField(viewModel: viewModel),
        ),
        // int.parse(viewModel.selectedClient.clientId) == 0
        //     ? selectRegButton(context, viewModel)
        //     : Container(),
      ],
    );
  }

  registrationNumberTextField({@required AddVehicleEntryViewModel viewModel}) {
    if (viewModel.selectedRoute != null) {
      selectedRegNoController.text = viewModel.selectedRoute.vehicleId;

      // if (viewModel.vehicleLog == null) {
      //   viewModel.getEntryLogForLastDate(selectedRegNoController.text);
      // }
    }

    return appTextFormField(
      enabled: false,
      controller: selectedRegNoController,
      focusNode: selectedRegNoFocusNode,
      hintText: drRegNoHint,
      keyboardType: TextInputType.text,
      onTextChange: (_) {
        selectedDateController.text = '';
        viewModel.vehicleLog = null;
      },
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

  Widget showLastEntry({EntryLog entryLog}) {
    return ClipRRect(
      borderRadius: getBorderRadius(),
      child: Card(
        elevation: 4,
        shape: getCardShape(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeConfiguration.primaryBackground,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entryLog.vehicleId ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    entryLog.entryDate.toString() ?? "",
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Start Reading : "),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(entryLog.startReading.toString() ?? ""),
                      )
                    ],
                  ),
                  hSizedBox(5),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("End Reading : "),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(entryLog.endReading.toString() ?? ""),
                      )
                    ],
                  ),
                  hSizedBox(5),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Login Time : "),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          entryLog.loginTime == null
                              ? ""
                              : convertFrom24HoursTime(
                                  entryLog.loginTime.toString(),
                                ),
                        ),
                      )
                    ],
                  ),
                  hSizedBox(5),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Logout Time : "),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          entryLog.logoutTime != null
                              ? convertFrom24HoursTime(
                                  entryLog.logoutTime.toString(),
                                )
                              : "",
                        ),
                      )
                    ],
                  ),
                  hSizedBox(5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showInitialReadingText({int startReading}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.latoMedium14Black,
          children: <TextSpan>[
            TextSpan(text: 'No Last Entry for '),
            TextSpan(
              text: '${selectedRegNoController.text.toUpperCase()} ',
              style: AppTextStyles.latoBold14Black,
            ),
            TextSpan(
              text: 'Initial Entry is ',
              style: AppTextStyles.latoMedium14Black,
            ),
            TextSpan(
              text: '$startReading',
              style: AppTextStyles.latoBold14Black,
            ),
          ],
        ),
      ),
    );
  }

  showLastEntryText({AddVehicleEntryViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.latoMedium14Black,
          children: <TextSpan>[
            TextSpan(text: "Last Entry in the system for "),
            TextSpan(
              text: '${selectedRegNoController.text.toUpperCase()} ',
              style: AppTextStyles.latoBold14Black,
            ),
            // TextSpan(
            //   text: 'is ',
            //   style: AppTextStyles.latoMedium14Black,
            // ),
            // TextSpan(
            //   text: '${viewModel.vehicleLog.startReading}',
            //   style: AppTextStyles.latoBold14Black,
            // ),
          ],
        ),
      ),
    );
  }

  Widget loadLastEntry({AddVehicleEntryViewModel viewModel}) {
    return Column(
      children: [
        viewModel.vehicleLog.endReading == null
            ? showInitialReadingText(
                startReading: viewModel.vehicleLog.startReading ?? 0)
            : showLastEntryText(viewModel: viewModel),
        viewModel.vehicleLog.endReading == null
            ? Container()
            : showLastEntry(entryLog: viewModel.vehicleLog)
      ],
    );
  }
}

class RoutesDropDown extends StatefulWidget {
  final List<RoutesForSelectedClientAndDateResponse> optionList;
  final RoutesForSelectedClientAndDateResponse selectedValue;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  RoutesDropDown(
      {@required this.optionList,
      this.selectedValue,
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _RoutesDropDownState createState() => _RoutesDropDownState();
}

class _RoutesDropDownState extends State<RoutesDropDown> {
  List<DropdownMenuItem<RoutesForSelectedClientAndDateResponse>> dropdown = [];

  List<DropdownMenuItem<RoutesForSelectedClientAndDateResponse>>
      getDropDownItems() {
    List<DropdownMenuItem<RoutesForSelectedClientAndDateResponse>> dropdown =
        <DropdownMenuItem<RoutesForSelectedClientAndDateResponse>>[];

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].routeName}  (${widget.optionList[i].routeId}/${widget.optionList[i].vehicleId})",
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
