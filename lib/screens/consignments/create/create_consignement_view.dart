import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/screens/consignments/create/create_consignement_viewmodel.dart';
import 'package:bml_supervisor/screens/consignments/create/create_consignment_textfield.dart';
import 'package:bml_supervisor/screens/consignments/create/driver_list_bottomsheet/driver_list_bottomsheet.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/disabled_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/recent_consignment_list.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app_level/locator.dart';
import 'create_consignment_params.dart';

class CreateConsignmentView extends StatefulWidget {
  @override
  _CreateConsignmentViewState createState() => _CreateConsignmentViewState();
}

class _CreateConsignmentViewState extends State<CreateConsignmentView> {
  bool isEditAllowed = true;
  ScrollController _scrollController = ScrollController();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  TextEditingController selectedDispatchTimeController =
      TextEditingController();
  final FocusNode selectedDispatchTimeFocusNode = FocusNode();

  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();

  final TextEditingController totalWeightController = TextEditingController();
  final FocusNode totalWeightFocusNode = FocusNode();

  final TextEditingController consignmentTitleController =
      TextEditingController();
  final FocusNode consignmentTitleFocusNode = FocusNode();

  final PageController _controller = PageController(
    initialPage: 0,
  )..addListener(() {
      print("The value of listener");
    });

  FocusNode hubTitleFocusNode = FocusNode();

  FocusNode remarksFocusNode = FocusNode();

  FocusNode dropFocusNode = FocusNode();

  FocusNode collectFocusNode = FocusNode();

  FocusNode paymentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateConsignmentModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.getClients();
        // viewModel.getRecentConsignmentsForCreateConsignment();
      },
      builder: (context, viewModel, child) => SafeArea(
        left: false,
        right: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: setAppBarTitle(title: 'Create Consignment'),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : Padding(
                  padding: getSidePadding(context: context),
                  child: body(context, viewModel),
                ),
        ),
      ),
      viewModelBuilder: () => CreateConsignmentModel(),
    );
  }

  Widget body(BuildContext context, CreateConsignmentModel viewModel) {
    return viewModel.entryDate == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // dateSelector(context: context, viewModel: viewModel),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: CreateNewButtonWidget(
                  title: 'Create Consignment',
                  onTap: () => dateSelectListener(viewModel: viewModel),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: DottedDivider(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                child: buildChartTitle(title: "Recently Created Consignments"),
              ),
              Expanded(
                child: RecentConsignmentList(),
              ),
            ],
          )
        : SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                dateSelector(context: context, viewModel: viewModel),
                viewModel.consignmentsList.length > 0
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                viewModel.consignmentsListBottomSheet();
                              },
                              child: Text(
                                'No. of ${getConsignment(viewModel.consignmentsList.length)} (${viewModel.consignmentsList.length}) ',
                                style: AppTextStyles.hyperLinkStyle,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                DisabledWidget(
                  child: dispatchTimeSelectorSelector(
                    context: context,
                    viewModel: viewModel,
                  ),
                  disabled: viewModel.entryDate == null,
                ),
                DisabledWidget(
                  disabled: viewModel.dispatchTime == null,
                  child: appTextFormField(
                    errorText: '',
                    controller: TextEditingController(
                      text: viewModel.selectedRoute == null
                          ? ''
                          : viewModel.selectedRoute.routeTitle,
                    ),
                    enabled: false,
                    hintText: "Select Routes",
                    keyboardType: TextInputType.text,
                    buttonType: ButtonType.FULL,
                    buttonIcon: Icon(Icons.arrow_drop_down_sharp),
                    onButtonPressed: () {
                      viewModel.bottomSheetService
                          .showCustomSheet(
                        isScrollControlled: true,
                        barrierDismissible: true,
                        variant: BottomSheetType.ROUTES_BOTTOM_SHEET,
                      )
                          .then((routesBottomSheetReponse) {
                        if (routesBottomSheetReponse != null) {
                          if (routesBottomSheetReponse.confirmed) {
                            viewModel.selectedRoute =
                                routesBottomSheetReponse.responseData;

                            selectedRegNoController.clear();
                            consignmentTitleController.clear();
                            viewModel.consignmentTitle = '';
                            viewModel.consignmentRequest = null;
                            viewModel.resetControllerBoolValue();
                          }
                        }
                      });
                    },
                  ),
                ),
                DisabledWidget(
                  disabled: viewModel.selectedRoute == null,
                  child: appTextFormField(
                    errorText: '',
                    controller: TextEditingController(
                      text: viewModel.selectedDriver == null
                          ? ''
                          : viewModel.selectedDriver.getCompleteName(),
                    ),
                    enabled: false,
                    hintText: "Select Driver",
                    keyboardType: TextInputType.text,
                    buttonType: ButtonType.FULL,
                    buttonIcon: Icon(Icons.arrow_drop_down_sharp),
                    onButtonPressed: () {
                      viewModel.bottomSheetService
                          .showCustomSheet(
                        isScrollControlled: true,
                        barrierDismissible: true,
                        customData:
                            DriverListBottomSheetBottomSheetInputArgument(
                                bottomSheetTitle: 'Selct Driver'),
                        variant:
                            BottomSheetType.CREATE_CONSIGNMENT_DRIVERS_LIST,
                      )
                          .then((driverListBottomSheetResponse) {
                        if (driverListBottomSheetResponse != null) {
                          if (driverListBottomSheetResponse.confirmed) {
                            DriverListBottomSheetBottomSheetOutputArguments
                                args =
                                driverListBottomSheetResponse.responseData;
                            viewModel.selectedDriver = args.selectedDriver;
                            viewModel.notifyListeners();

                            selectedRegNoController.clear();
                            consignmentTitleController.clear();
                            viewModel.consignmentRequest = null;
                            viewModel.consignmentTitle = '';
                            viewModel.resetControllerBoolValue();
                          }
                        }
                      });
                    },
                  ),
                ),
                DisabledWidget(
                  disabled: viewModel.selectedDriver == null,
                  child: consignmentTextField(viewModel: viewModel),
                ),
                DisabledWidget(
                  disabled: viewModel.selectedDriver == null,
                  child: AppDropDown(
                    showUnderLine: true,
                    selectedValue:
                        viewModel.itemUnit != null ? viewModel.itemUnit : null,
                    hint: "Item Unit",
                    onOptionSelect: (selectedValue) {
                      viewModel.itemUnit = selectedValue;
                      totalWeightFocusNode.requestFocus();
                    },
                    optionList: selectItemUnit,
                  ),
                ),
                DisabledWidget(
                  disabled: viewModel.selectedDriver == null,
                  child: totalWeightTextField(
                    viewModel,
                  ),
                ),
                DisabledWidget(
                  disabled: viewModel.totalWeight == 0,
                  child: createConsignmentButton(
                    viewModel: viewModel,
                  ),
                ),
              ],
            ),
          );
  }

  Widget createConsignmentButton({CreateConsignmentModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      child: AppButton.normal(
          onTap: () {
            if (checkRequiredItems(viewModel: viewModel)) {
              viewModel.takeToAddHubsView();
            }
          },
          buttonText: 'Create Consignment'),
    );
  }

  totalWeightTextField(CreateConsignmentModel viewModel) {
    return appTextFormField(
        enabled: true,
        controller: totalWeightController,
        focusNode: totalWeightFocusNode,
        hintText: 'Total ${viewModel.itemUnit ?? selectItemUnit[1]}',
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onTextChange: (String value) {
          viewModel.totalWeight =
              value.trim().length == 0 ? 0 : double.parse(value);
        });
  }

  consignmentTextField({CreateConsignmentModel viewModel}) {
    return appTextFormField(
        enabled: true,
        onTextChange: (value) {
          viewModel.resetControllerBoolValue();
          viewModel.consignmentTitle = value;
        },
        controller: consignmentTitleController,
        focusNode: consignmentTitleFocusNode,
        hintText: consignmentTitleHint,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) {
          viewModel.consignmentTitle = value;
          consignmentTitleFocusNode.unfocus();
        });
  }

  dateSelector({BuildContext context, CreateConsignmentModel viewModel}) {
    return selectedDateTextField(viewModel);
  }

  dispatchTimeSelectorSelector(
      {BuildContext context, CreateConsignmentModel viewModel}) {
    return selectedDispatchTimeField(viewModel);
  }

  selectedDateTextField(CreateConsignmentModel viewModel) {
    return appTextFormField(
        enabled: false,
        controller: selectedDateController,
        focusNode: selectedDateFocusNode,
        inputDecoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
            hintText: 'Select date to create a new consigment'),
        keyboardType: TextInputType.text,
        buttonType: ButtonType.FULL,
        buttonIcon: Icon(Icons.calendar_today_outlined),
        onButtonPressed: () {
          dateSelectListener(viewModel: viewModel);
        });
  }

  selectedDispatchTimeField(CreateConsignmentModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDispatchTimeController,
      focusNode: selectedDispatchTimeFocusNode,
      inputDecoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
          hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
          hintText: 'Dispatch Time'),
      keyboardType: TextInputType.text,
      buttonType: ButtonType.FULL,
      buttonIcon: Icon(Icons.date_range_outlined),
      onButtonPressed: (() async {
        TimeOfDay selectedDispatchTime = await selectTime(context: context);
        if (selectedDispatchTime != null) {
          selectedDispatchTimeController.text =
              selectedDispatchTime.format(context).toUpperCase();
          viewModel.dispatchTime = selectedDispatchTime;
          viewModel.getConsignmentListWithDate();
          selectedRegNoController.clear();
          consignmentTitleController.clear();
          viewModel.resetControllerBoolValue();
        }
      }),
    );
  }

  dateSelectListener({
    @required CreateConsignmentModel viewModel,
  }) async {
    DateTime selectedDate = await selectDate();
    if (selectedDate != null) {
      selectedDateController.text =
          DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
      viewModel.entryDate = selectedDate;
      viewModel.getConsignmentListWithDate();
      selectedRegNoController.clear();
      consignmentTitleController.clear();
      viewModel.resetControllerBoolValue();
    }
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
      initialDate: DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: DateTime(2500),
    );

    return picked;
  }

  Future<TimeOfDay> selectTime({@required BuildContext context}) async {
    TimeOfDay picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return picked;
  }

  void setCursorAtEndFor({@required TextEditingController controller}) {
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  void setValueAt({TextEditingController textEditingController, value}) {
    textEditingController.text = value;
    setCursorAtEndFor(controller: textEditingController);
  }

  getConsignment(int length) {
    if (length == 1) {
      return 'Consignment';
    } else {
      return 'Consignments';
    }
  }

  ///Check if consignment title, item unit, dispatch time has been selected or not.
  bool checkRequiredItems({@required CreateConsignmentModel viewModel}) {
    bool allRequiredFieldsFilled = true;

    if (consignmentTitleController.text.trim().length == 0) {
      locator<SnackbarService>()
          .showSnackbar(message: "Please Enter Consignment Title");
      consignmentTitleFocusNode.requestFocus();
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      allRequiredFieldsFilled = false;
    } else {
      if (viewModel.itemUnit == null) {
        locator<SnackbarService>()
            .showSnackbar(message: "Please Select Item Unit");
        allRequiredFieldsFilled = false;
      } else if (selectedDispatchTimeController.text.trim().length == 0) {
        locator<SnackbarService>()
            .showSnackbar(message: 'Please Select Dispatch Time.');
        allRequiredFieldsFilled = false;
      }
    }
    return allRequiredFieldsFilled;
  }
}
