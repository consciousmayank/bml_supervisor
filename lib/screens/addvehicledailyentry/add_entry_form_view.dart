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

class AddVehicleEntryFormView extends StatefulWidget {
  final Map<String, dynamic> arguments;
  AddVehicleEntryFormView({this.arguments});
  @override
  _AddVehicleEntryFormViewState createState() =>
      _AddVehicleEntryFormViewState();
}

class _AddVehicleEntryFormViewState extends State<AddVehicleEntryFormView> {
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

  DialogService endReadingDialog = locator<DialogService>();

  @override
  void initState() {
    // final entryDate = widget.arguments['entryDateArg'];
    // final vehicleLogArg = widget.arguments['vehicleLogArg'];
    // final searchResponseArg = widget.arguments['searchResponseArg'];
    endReadingFocusNode.addListener(endReadingListener);
    fuelReadingFocusNode.addListener(fuelEntryListener);
    fuelRateFocusNode.addListener(fuelRateListener);
    // fuelMeterReadingFocusNode.addListener(fuelMeterReadingListener); //! Fuel meter reading listener
    super.initState();
  }

  void endReadingListener() async {
    if (!endReadingFocusNode.hasFocus) {
      if (int.parse(endReadingController.text) -
              int.parse(initialReadingController.text) <=
          0) {
        await endReadingDialog
            .showConfirmationDialog(
          barrierDismissible: true,
          title: 'Vehicle End Reading Error',
          description: vehicleEntryEndReadingError,
        )
            .then((value) {
          endReadingController.clear();
          endReadingFocusNode.unfocus();
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

  bool isFuelMeterReadingCorrect() {
    if (!(getDoubleValue(initialReadingController.text) <=
            getDoubleValue(fuelMeterReadingController.text.trim()) &&
        getDoubleValue(fuelMeterReadingController.text.trim()) <=
            getDoubleValue(endReadingController.text))) {
      return false;
    } else {
      return true;
    }
  }

  getDoubleValue(String value) {
    return double.parse(value);
  }

  @override
  Widget build(BuildContext context) {
    // final entryDate = widget.arguments['entryDateArg'];
    // print('after reveiving-entryDate' + entryDate.toString());
    return ViewModelBuilder<AddVehicleEntryViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text("Add Entry Form"),
        ),
        body: viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: getSidePadding(context: context),
                child: Column(
                  children: [
                    // Text('Show Form Here'),
                    formView(context: context, viewModel: viewModel),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => AddVehicleEntryViewModel(),
    );
  }

  formView({BuildContext context, AddVehicleEntryViewModel viewModel}) {
    if (viewModel.selectedVehicle == null &&
        viewModel.vehicleLog == null &&
        viewModel.entryDate == null) {
      print('selected vehicle is null');
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
        ),
        tablet: ListView(
          controller: _controller,
        ),
      ),
    );
  }

  List<Widget> mobileFormView(
      {BuildContext context, AddVehicleEntryViewModel viewModel}) {
    setNavigationArguments(viewModel);

    return [
      Column(
        children: [
          getValueForScreenType(
            context: context,
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
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
                  widget.arguments['regNumArg'],
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  DateFormat('dd-MM-yyyy')
                      .format(viewModel.entryDate)
                      .toLowerCase(),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          hSizedBox(10),
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
      viewModel.vehicleLog != null && viewModel.entryDate != null
          ? SizedBox(
              height: buttonHeight,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                onPressed: () {
                  print('submit btn pressed');
                  print(
                      'in form page-selected client id: ${widget.arguments['selectedClientId']}');

                  if (!viewModel.isFuelEntryAdded) {
                    addVehicleEntry(viewModel);
                  } else {
                    if (isFuelMeterReadingCorrect()) {
                      addVehicleEntry(viewModel);
                    } else {
                      viewModel.snackBarService.showSnackbar(
                          message: 'Please enter correct meter reading');
                    }
                  }
                },
                child: Text("Submit"),
              ),
            )
          : Container()
    ];
  }

  void addVehicleEntry(AddVehicleEntryViewModel viewModel) {
    if (_formKey.currentState.validate()) {
      viewModel.submitVehicleEntry(EntryLog(
        clientId: widget.arguments['selectedClientId'],
        vehicleId: widget.arguments['regNumArg'],
        entryDate:
            DateFormat('dd-MM-yyyy').format(viewModel.entryDate).toLowerCase(),
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
            timeToBeConverted: viewModel.loginTime, context: context),
        logoutTime: getTimeIn24Hrs(
            timeToBeConverted: viewModel.logoutTime, context: context),
        remarks: remarksController.text.trim(),
        status: false,
        drivenKmGround: int.parse(distanceDrivenController.text.trim()),
        startReadingGround: int.parse(initialReadingController.text.trim()),
      ));
    }
  }

  void setNavigationArguments(AddVehicleEntryViewModel viewModel) {
    viewModel.vehicleLog = widget.arguments['vehicleLogArg'];
    viewModel.entryDate = widget.arguments['entryDateArg'];
    viewModel.flagForSearch = widget.arguments['flagForSearchArg'];
  }

  Widget startingReadingView(AddVehicleEntryViewModel viewModel) {
    startReadingHidden = viewModel.flagForSearch == 0
        ? viewModel.vehicleLog.endReading
        : viewModel.vehicleLog.startReading;

    if (viewModel.vehicleLog != null) {
      // if (viewModel.vehicleLog.failed != null) {
      if (viewModel.flagForSearch == 0) {
        print('flag is zero');
        initialReadingController = TextEditingController(
            text: viewModel.vehicleLog.endReading.toString());
      } else {
        print('flag is one');
        initialReadingController = TextEditingController(
            text: viewModel.vehicleLog.startReading.toString());
      }
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
                  // viewModel.selectedVehicle.initReading) { // initial statement
                  viewModel.vehicleLog.startReading ??
              viewModel.vehicleLog.endReading) {
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
        // context, endReadingFocusNode, vehicleLoadCapacityFocusNode);
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
      @required AddVehicleEntryViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        loginTimeTextField(viewModel),
        wSizedBox(8),
        selectLoginTimeButton(context, viewModel),
      ],
    );
  }

  logoutTimeSelector(
      {@required BuildContext context,
      @required AddVehicleEntryViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        logoutTimeTextField(viewModel),
        selectLogoutTimeButton(context, viewModel),
      ],
    );
  }

  tripView({BuildContext context, AddVehicleEntryViewModel viewModel}) {
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

  Widget getRemarks(
      {@required BuildContext context,
      @required AddVehicleEntryViewModel viewModel}) {
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

  Widget getFuelEntry(
      {@required BuildContext context,
      @required AddVehicleEntryViewModel viewModel}) {
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

  Widget getFuelRate(
      {@required BuildContext context,
      @required AddVehicleEntryViewModel viewModel}) {
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
      @required AddVehicleEntryViewModel viewModel}) {
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
      @required AddVehicleEntryViewModel viewModel}) {
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

  loginTimeTextField(AddVehicleEntryViewModel viewModel) {
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

  selectLoginTimeButton(
      BuildContext context, AddVehicleEntryViewModel viewModel) {
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

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  logoutTimeTextField(AddVehicleEntryViewModel viewModel) {
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

  selectLogoutTimeButton(
      BuildContext context, AddVehicleEntryViewModel viewModel) {
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

  Future<TimeOfDay> pickTime(
      {@required BuildContext context,
      @required AddVehicleEntryViewModel viewModel,
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

  double comparableTimeOfDay(TimeOfDay myTime) =>
      myTime.hour + myTime.minute / 60.0;

  getCurrentTime(BuildContext context, AddVehicleEntryViewModel viewModel,
      int hoursToAdd) {
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
