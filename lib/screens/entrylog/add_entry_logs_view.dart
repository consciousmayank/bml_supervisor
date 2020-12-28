import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'add_entry_logs_viewmodel.dart';

class EntryLogsView extends StatefulWidget {
  @override
  _EntryLogsViewState createState() => _EntryLogsViewState();
}

class _EntryLogsViewState extends State<EntryLogsView> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode selectedRegNoFocusNode = FocusNode();
  final TextEditingController selectedRegNoController = TextEditingController();

  final FocusNode loginTimeFocusNode = FocusNode();
  final TextEditingController loginTimeController = TextEditingController();

  final FocusNode logoutTimeFocusNode = FocusNode();
  final TextEditingController logoutTimeController = TextEditingController();

  final TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  final FocusNode initialReadingFocusNode = FocusNode();
  TextEditingController initialReadingController = TextEditingController();

  final FocusNode endReadingFocusNode = FocusNode();
  final TextEditingController endReadingController = TextEditingController();

  final TextEditingController distanceDrivenController =
      TextEditingController();
  final TextEditingController entryDateController = TextEditingController();

  final TextEditingController fuelReadingController = TextEditingController();
  final FocusNode fuelReadingFocusNode = FocusNode();

  final TextEditingController remarksController = TextEditingController();
  final FocusNode remarksFocusNode = FocusNode();

  final FocusNode fuelRateFocusNode = FocusNode();
  final TextEditingController fuelRateController = TextEditingController();

  final FocusNode fuelMeterReadingFocusNode = FocusNode();
  final TextEditingController fuelMeterReadingController =
      TextEditingController();

  final FocusNode fuelAmountFocusNode = FocusNode();
  final TextEditingController fuelAmountController = TextEditingController();
  int startReadingHidden, drivenKmHidden;
  final _controller = ScrollController();

  @override
  void initState() {
    endReadingFocusNode.addListener(endReadingListener);
    fuelReadingFocusNode.addListener(fuelEntryListener);
    fuelRateFocusNode.addListener(fuelRateListener);
    fuelMeterReadingFocusNode.addListener(fuelMeterReadingListener);
    super.initState();
  }

  void endReadingListener() async {
    if (!endReadingFocusNode.hasFocus) {
      if (int.parse(endReadingController.text) -
              int.parse(initialReadingController.text) <=
          0) {
        await locator<DialogService>()
            .showConfirmationDialog(
          title: 'Vehicle End Reading Error',
          description: vehicleEntryEndReadingError,
        )
            .then((value) {
          endReadingController.clear();
        });
      } else {
        distanceDrivenController.text = (int.parse(endReadingController.text) -
                int.parse(initialReadingController.text))
            .toString();
        drivenKmHidden =
            (int.parse(endReadingController.text)) - startReadingHidden;
      }
    }
  }

  void fuelEntryListener() async {
    if (!fuelReadingFocusNode.hasFocus &&
        fuelRateController.text.length > 0 &&
        getDoubleValue(fuelRateController.text.trim()) > 0 &&
        fuelReadingController.text.length > 0 &&
        getDoubleValue(fuelReadingController.text.trim()) > 0) {
      getPaidFuelAmount();
    }
  }

  void fuelRateListener() async {
    if (!fuelRateFocusNode.hasFocus &&
        fuelRateController.text.length > 0 &&
        getDoubleValue(fuelRateController.text.trim()) > 0 &&
        fuelReadingController.text.length > 0 &&
        getDoubleValue(fuelReadingController.text.trim()) > 0) {
      getPaidFuelAmount();
    }
  }

  void getPaidFuelAmount() {
    double fuelAmt = getDoubleValue(fuelRateController.text.trim()) *
        getDoubleValue(fuelReadingController.text.trim());
    fuelAmountController.text = fuelAmt.toString();
  }

  void fuelMeterReadingListener() async {
    if (!fuelRateFocusNode.hasFocus &&
        !(getDoubleValue(initialReadingController.text) <=
                getDoubleValue(fuelMeterReadingController.text.trim()) &&
            getDoubleValue(fuelMeterReadingController.text.trim()) <=
                getDoubleValue(endReadingController.text))) {
      await locator<DialogService>()
          .showConfirmationDialog(
        title: 'Fuel Meter Reading Error',
        description: fuelMeterReadingError,
      )
          .then((value) {
        fuelMeterReadingController.clear();
      });
    }
  }

  getDoubleValue(String value) {
    return double.parse(value);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EntryLogsViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text("Add Entry"),
        ),
        body: viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: getSidePadding(context: context),
                child: Column(
                  children: [
                    formView(context: context, viewModel: viewModel),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => EntryLogsViewModel(),
    );
  }

  registrationSelector({BuildContext context, EntryLogsViewModel viewModel}) {
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

  dateSelector({BuildContext context, EntryLogsViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectRegButton(BuildContext context, EntryLogsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          viewModel.entryDate = null;
          viewModel.takeToSearch();
        },
      ),
    );
  }

  selectDateButton(BuildContext context, EntryLogsViewModel viewModel) {
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
            viewModel.getEntryForSelectedDate();
            viewModel.emptyDateSelector = true;
          }
        }),
      ),
    );
  }

  Future<DateTime> selectDate(EntryLogsViewModel viewModel) async {
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

  registrationNumberTextField(EntryLogsViewModel viewModel) {
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

  selectedDateTextField(EntryLogsViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Select Entry Date",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  formView({BuildContext context, EntryLogsViewModel viewModel}) {
    if (viewModel.selectedSearchVehicle == null &&
        viewModel.vehicleLog == null &&
        viewModel.entryDate == null) {
      selectedRegNoController.clear();
      entryDateController.clear();
      initialReadingController.clear();
      endReadingController.clear();
      distanceDrivenController.clear();
      loginTimeController.clear();
      logoutTimeController.clear();
      remarksController.clear();
      fuelAmountController.clear();
      fuelMeterReadingController.clear();
      fuelRateController.clear();
      fuelReadingController.clear();
      selectedDateController.clear();
    }
    return Form(
      key: _formKey,
      child: getValueForScreenType(
        context: context,
        mobile: Expanded(
          child: ListView(
            controller: _controller,
            children: mobileFormView(context: context, viewModel: viewModel),
          ),
        ),
        desktop: ListView(
          controller: _controller,
          children: tabletFormView(context: context, viewModel: viewModel),
        ),
        tablet: ListView(
          controller: _controller,
          children: tabletFormView(context: context, viewModel: viewModel),
        ),
      ),
    );
  }

  List<Widget> mobileFormView(
      {BuildContext context, EntryLogsViewModel viewModel}) {
    return [
      Column(
        children: [
          getValueForScreenType(
            context: context,
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: headerText("Daily Entry"),
                ),
                registrationSelector(context: context, viewModel: viewModel),
                viewModel.selectedSearchVehicle == null
                    ? Container()
                    : dateSelector(context: context, viewModel: viewModel),
                hSizedBox(20)
              ],
            ),
            tablet: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: registrationSelector(
                      context: context, viewModel: viewModel),
                ),
                wSizedBox(20),
                Expanded(
                  flex: 1,
                  child: viewModel.selectedSearchVehicle == null
                      ? Container()
                      : dateSelector(context: context, viewModel: viewModel),
                )
              ],
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: registrationSelector(
                      context: context, viewModel: viewModel),
                ),
                wSizedBox(20),
                Expanded(
                  flex: 1,
                  child: viewModel.selectedSearchVehicle == null
                      ? Container()
                      : dateSelector(context: context, viewModel: viewModel),
                )
              ],
            ),
          ),
          viewModel.vehicleLog != null
              ? startingReadingView(viewModel)
              : Container(),
          hSizedBox(20),

          viewModel.vehicleLog != null ? endReadingView() : Container(),
          hSizedBox(20),

          viewModel.vehicleLog != null ? distanceDrivenView() : Container(),

          // endReadingView(),
          hSizedBox(20),
          // distanceDrivenView(),
        ],
      ),
      viewModel.vehicleLog != null
          ? Column(
              children: [
                loginTimeSelector(context: context, viewModel: viewModel),
                logoutTimeSelector(context: context, viewModel: viewModel),
                tripView(context: context, viewModel: viewModel),
              ],
            )
          : Container(),
      hSizedBox(20),
      viewModel.vehicleLog != null
          ? getRemarks(context: context, viewModel: viewModel)
          : Container(),
      hSizedBox(20),
      viewModel.vehicleLog != null
          ? Column(
              children: [
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text("Fuel Entry"),
                  subtitle: Text("Enter Fuel reading along with Meter Reading"),
                  value: viewModel.isFuelEntryAdded,
                  onChanged: (value) {
                    viewModel.isFuelEntryAdded = value;
                    Future.delayed(Duration(milliseconds: 200), () {
                      _controller.animateTo(
                        _controller.position.maxScrollExtent,
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 400),
                      );
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: getFuelEntry(context: context, viewModel: viewModel),
                ),
                viewModel.isFuelEntryAdded ? hSizedBox(20) : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: getFuelRate(context: context, viewModel: viewModel),
                ),
                viewModel.isFuelEntryAdded ? hSizedBox(20) : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: getFuelAmount(context: context, viewModel: viewModel),
                ),
                viewModel.isFuelEntryAdded ? hSizedBox(20) : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: getFuelMeterReading(
                      context: context, viewModel: viewModel),
                ),
              ],
            )
          : Container(),
      viewModel.selectedSearchVehicle != null &&
              viewModel.vehicleLog != null &&
              viewModel.entryDate != null
          ? SizedBox(
              height: buttonHeight,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    viewModel.submitVehicleEntry(EntryLog(
                      vehicleId:
                          viewModel.selectedSearchVehicle.registrationNumber,
                      entryDate: selectedDateController.text.trim(),
                      startReading: startReadingHidden,
                      endReading: int.parse(endReadingController.text.trim()),
                      drivenKm: drivenKmHidden,
                      fuelLtr: viewModel.isFuelEntryAdded
                          ? double.parse(fuelReadingController.text.trim())
                          : 0.00,
                      fuelMeterReading: viewModel.isFuelEntryAdded
                          ? int.parse(fuelMeterReadingController.text.trim())
                          : 0,
                      ratePerLtr: viewModel.isFuelEntryAdded
                          ? double.parse(fuelRateController.text.trim())
                          : 0.00,
                      amountPaid: viewModel.isFuelEntryAdded
                          ? double.parse(fuelAmountController.text.trim())
                          : 0.00,
                      trips: viewModel.undertakenTrips,
                      loginTime: getTimeIn24Hrs(
                          timeToBeConverted: viewModel.loginTime,
                          context: context),
                      logoutTime: getTimeIn24Hrs(
                          timeToBeConverted: viewModel.logoutTime,
                          context: context),
                      remarks: remarksController.text.trim(),
                      status: false,
                      drivenKmGround:
                          int.parse(distanceDrivenController.text.trim()),
                      startReadingGround:
                          int.parse(initialReadingController.text.trim()),
                    ));
                  }
                },
                child: Text("Submit"),
              ),
            )
          : Container()
    ];
  }

  List<Widget> tabletFormView(
      {BuildContext context, EntryLogsViewModel viewModel}) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: startingReadingView(viewModel),
          ),
          wSizedBox(20),
          Expanded(
            flex: 1,
            child: endReadingView(),
          ),
          wSizedBox(20),
          Expanded(
            flex: 1,
            child: distanceDrivenView(),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: loginTimeSelector(context: context, viewModel: viewModel),
          ),
          Expanded(
            flex: 2,
            child: logoutTimeSelector(context: context, viewModel: viewModel),
          ),
          Expanded(
            flex: 1,
            child: tripView(context: context, viewModel: viewModel),
          ),
        ],
      ),
      getRemarks(context: context, viewModel: viewModel),
      Column(
        children: [
          CheckboxListTile(
            contentPadding: const EdgeInsets.all(8),
            title: Text("Fuel Entry"),
            subtitle: Text("Enter Fuel reading along with Meter Reading"),
            value: viewModel.isFuelEntryAdded,
            onChanged: (value) {
              viewModel.isFuelEntryAdded = value;
              Future.delayed(Duration(milliseconds: 200), () {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 400),
                );
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: getFuelEntry(context: context, viewModel: viewModel),
          ),
          viewModel.isFuelEntryAdded ? hSizedBox(20) : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: getFuelRate(context: context, viewModel: viewModel),
          ),
          viewModel.isFuelEntryAdded ? hSizedBox(20) : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: getFuelAmount(context: context, viewModel: viewModel),
          ),
          viewModel.isFuelEntryAdded ? hSizedBox(20) : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: getFuelMeterReading(context: context, viewModel: viewModel),
          ),
        ],
      )
    ];
  }

  Widget startingReadingView(EntryLogsViewModel viewModel) {
    startReadingHidden =
        viewModel.vehicleLog == null || viewModel.vehicleLog.endReading == null
            ? viewModel.selectedSearchVehicle == null ||
                    viewModel.selectedSearchVehicle.initReading == null
                ? 0
                : viewModel.selectedSearchVehicle.initReading
            : viewModel.vehicleLog.endReading;

    if (viewModel.vehicleLog != null) {
      if (viewModel.vehicleLog.failed != null) {
        initialReadingController = TextEditingController(
            text: viewModel.vehicleLog.startReading.toString());
      }
      // else {
      //   initialReadingController = TextEditingController(
      //       text: viewModel.vehicleLog.endReading.toString());
      // }
    }

    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(7)
      ],
      controller: initialReadingController,
      labelText: "Start Reading in Km",
      focusNode: initialReadingFocusNode,
      hintText: vehicleInitialReadingHint,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {
        if (viewModel.vehicleLog.failed != null) {
          if (int.parse(initialReadingController.text) <
              viewModel.selectedSearchVehicle.initReading) {
            locator<DialogService>()
                .showConfirmationDialog(
              title: 'Vehicle Start Reading Error',
              description: vehicleEntryStartReadingError,
            )
                .then((value) {
              endReadingController.clear();
            }).then((value) {
              FocusScope.of(context).requestFocus(initialReadingFocusNode);
            });
          }
        } else {
          if (int.parse(initialReadingController.text) <
              viewModel.vehicleLog.startReading) {
            locator<DialogService>()
                .showConfirmationDialog(
              title: 'Vehicle Start Reading Error',
              description: vehicleEntryStartReadingError,
            )
                .then((value) {
              endReadingController.clear();
            }).then((value) {
              FocusScope.of(context).requestFocus(initialReadingFocusNode);
            });
          }
        }

        fieldFocusChange(context, initialReadingFocusNode, endReadingFocusNode);
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

  Widget endReadingView() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(7)
      ],
      controller: endReadingController,
      focusNode: endReadingFocusNode,
      hintText: entryEndReadingHint,
      keyboardType: TextInputType.number,
      labelText: "End Reading in Km",
      onFieldSubmitted: (_) {
        // fieldFocusChange(
        //     context, endReadingFocusNode, vehicleLoadCapacityFocusNode);
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

  Widget distanceDrivenView() {
    return appTextFormField(
      enabled: false,
      controller: distanceDrivenController,
      hintText: "Total Distance Driven",
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  loginTimeSelector(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        loginTimeTextField(viewModel),
        wSizedBox(8),
        selectLoginTimeButton(context, viewModel),
      ],
    );
  }

  selectLoginTimeButton(BuildContext context, EntryLogsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.login),
        onPressed: () async {
          TimeOfDay loginTime = await pickTime(
              context: context, viewModel: viewModel, hoursToAdd: 0);
          if (loginTime != null) {
            loginTimeController.text = "${formatTimeOfDay(loginTime)}";
            viewModel.loginTime = loginTime;
            // viewModel.getEntryForSelectedDate();
          }
        },
      ),
    );
  }

  loginTimeTextField(EntryLogsViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: loginTimeController,
      focusNode: loginTimeFocusNode,
      hintText: "Login Time",
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

  logoutTimeSelector(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        logoutTimeTextField(viewModel),
        selectLogoutTimeButton(context, viewModel),
      ],
    );
  }

  selectLogoutTimeButton(BuildContext context, EntryLogsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.logout),
        onPressed: () async {
          TimeOfDay logoutTime = await pickTime(
              context: context, viewModel: viewModel, hoursToAdd: 8);
          if (comparableTimeOfDay(logoutTime) != null &&
              (comparableTimeOfDay(logoutTime) >=
                  comparableTimeOfDay(viewModel.loginTime))) {
            logoutTimeController.text = "${formatTimeOfDay(logoutTime)}";
            viewModel.logoutTime = logoutTime;
          } else {
            await locator<DialogService>()
                .showConfirmationDialog(
                    title: 'Logout Time Error', description: logoutTimeError)
                .then((value) {
              logoutTimeController.clear();
            });
          }
        },
      ),
    );
  }

  logoutTimeTextField(EntryLogsViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: logoutTimeController,
      focusNode: logoutTimeFocusNode,
      hintText: "Logout Time",
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

  Future<TimeOfDay> pickTime(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel,
      @required int hoursToAdd}) async {
    TimeOfDay t = await showTimePicker(
      initialTime: getCurrentTime(context, viewModel, hoursToAdd),
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: ThemeConfiguration.primaryBackground,
            ),
          ),
          child: child,
        );
      },
    );
    return t;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  double comparableTimeOfDay(TimeOfDay myTime) =>
      myTime.hour + myTime.minute / 60.0;

  Widget getFuelEntry(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return viewModel.isFuelEntryAdded
        ? appTextFormField(
            enabled: true,
            formatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(7)
            ],
            controller: fuelReadingController,
            focusNode: fuelReadingFocusNode,
            hintText: fuelReadingHint,
            labelText: "Fuel (in Litres)",
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              fieldFocusChange(
                  context, fuelReadingFocusNode, fuelRateFocusNode);
            },
            validator: (value) {
              if (viewModel.isFuelEntryAdded) {
                if (value.isEmpty) {
                  return textRequired;
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
          )
        : Container();
  }

  Widget getRemarks(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return appTextFormField(
      textCapitalization: TextCapitalization.sentences,
      maxLines: 5,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 , -- /]')),
      ],
      controller: remarksController,
      focusNode: remarksFocusNode,
      hintText: "Remarks",
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        remarksFocusNode.unfocus();
      },
    );
  }

  Widget getFuelRate(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return viewModel.isFuelEntryAdded
        ? appTextFormField(
            enabled: true,
            formatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(7)
            ],
            controller: fuelRateController,
            focusNode: fuelRateFocusNode,
            hintText: fuelRateHint,
            labelText: "Fuel Rate Rs/Litre",
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              fieldFocusChange(
                  context, fuelRateFocusNode, fuelMeterReadingFocusNode);
            },
            validator: (value) {
              if (viewModel.isFuelEntryAdded) {
                if (value.isEmpty) {
                  return textRequired;
                } else if (double.parse(value) == 0) {
                  return "cannot be 0";
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
          )
        : Container();
  }

  Widget getFuelAmount(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return viewModel.isFuelEntryAdded
        ? appTextFormField(
            showRupeesSymbol: true,
            enabled: false,
            formatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(7)
            ],
            controller: fuelAmountController,
            focusNode: fuelAmountFocusNode,
            hintText: fuelAmountHint,
            labelText: "Amount Paid for Fuel",
            keyboardType: TextInputType.number,
            validator: (value) {
              if (viewModel.isFuelEntryAdded) {
                if (value.isEmpty) {
                  return textRequired;
                } else if (double.parse(value) == 0) {
                  return "cannot be 0";
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
          )
        : Container();
  }

  Widget getFuelMeterReading(
      {@required BuildContext context,
      @required EntryLogsViewModel viewModel}) {
    return viewModel.isFuelEntryAdded
        ? appTextFormField(
            enabled: true,
            formatter: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(7)
            ],
            controller: fuelMeterReadingController,
            focusNode: fuelMeterReadingFocusNode,
            hintText: fuelMeterReadingHint,
            labelText: "Meter Reading in Km",
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              fuelMeterReadingFocusNode.unfocus();
            },
            validator: (value) {
              if (viewModel.isFuelEntryAdded) {
                if (value.isEmpty) {
                  return textRequired;
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
          )
        : Container();
  }

  getCurrentTime(
      BuildContext context, EntryLogsViewModel viewModel, int hoursToAdd) {
    return TimeOfDay.fromDateTime(DateTime(
            viewModel.entryDate.year,
            viewModel.entryDate.month,
            viewModel.entryDate.day,
            viewModel.entryDate.minute,
            viewModel.entryDate.second,
            viewModel.entryDate.millisecond,
            viewModel.entryDate.microsecond)
        .add(Duration(hours: hoursToAdd > 0 ? 10 + hoursToAdd : 10)));
  }

  tripView({BuildContext context, EntryLogsViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("Trip Count"),
          ),
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: RaisedButton(
                      child: Text("-"),
                      onPressed: viewModel.undertakenTrips > 1
                          ? () {
                              viewModel.undertakenTrips =
                                  viewModel.undertakenTrips - 1;
                            }
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      viewModel.undertakenTrips.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: RaisedButton(
                      child: Text(
                        "+",
                      ),
                      onPressed: () {
                        viewModel.undertakenTrips =
                            viewModel.undertakenTrips + 1;
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  String getTimeIn24Hrs({TimeOfDay timeToBeConverted, BuildContext context}) {
    String timeIn24Hrs = "";
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(timeToBeConverted,
        alwaysUse24HourFormat: true);
    if (formattedTime != null) {
      timeIn24Hrs = formattedTime;
    }

    return timeIn24Hrs;
  }
}
