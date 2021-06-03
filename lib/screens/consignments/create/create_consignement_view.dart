import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/screens/consignments/create/create_consignement_viewmodel.dart';
import 'package:bml_supervisor/screens/consignments/create/create_consignment_textfield.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/recent_consignment_list.dart';
import 'package:flutter/material.dart';
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
              ? Center(
                  child: CircularProgressIndicator(),
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
                dispatchTimeSelectorSelector(
                    context: context, viewModel: viewModel),
                viewModel.entryDate == null
                    ? Container()
                    : RoutesDropDown(
                        optionList: viewModel.routesList,
                        hint: "Select Routes",
                        onOptionSelect: (FetchRoutesResponse selectedValue) {
                          viewModel.selectedRoute = selectedValue;

                          selectedRegNoController.clear();
                          consignmentTitleController.clear();
                          viewModel.validatedRegistrationNumber = null;
                          viewModel.consignmentRequest = null;

                          viewModel.getHubs();
                          consignmentTitleController.clear();
                          // hubTitleController.clear();
                          // dropController.clear();
                          // collectController.clear();
                          // paymentController.clear();
                          // remarksController.clear();
                          viewModel.resetControllerBoolValue();
                        },
                        selectedValue: viewModel.selectedRoute == null
                            ? null
                            : viewModel.selectedRoute,
                      ),
                viewModel.hubsList.length < 1
                    ? Container()
                    : registrationSelector(viewModel: viewModel),
                viewModel.hubsList.length < 1
                    ? Container()
                    : consignmentTextField(viewModel: viewModel),
                viewModel.validatedRegistrationNumber == null
                    ? Container()
                    : AppDropDown(
                        showUnderLine: true,
                        selectedValue: viewModel.itemUnit != null
                            ? viewModel.itemUnit
                            : null,
                        hint: "Item Unit",
                        onOptionSelect: (selectedValue) {
                          viewModel.itemUnit = selectedValue;
                          totalWeightFocusNode.requestFocus();
                        },
                        optionList: selectItemUnit,
                      ),
                viewModel.validatedRegistrationNumber != null
                    ? totalWeightTextField(viewModel)
                    : Container(),
                viewModel.validatedRegistrationNumber == null
                    ? Container()
                    : SizedBox(
                        height: createConsignmentCardHeight,
                        child: _hubsPageView(viewModel),
                      ),
              ],
            ),
          );
  }

  PageView _hubsPageView(CreateConsignmentModel viewModel) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: AppColors.appScaffoldColor,
          // color: Colors.white,
          elevation: defaultElevation,
          shape: getCardShape(),
          child: Container(
            // padding: EdgeInsets.all(8),
            child: Form(
              key: viewModel.formKeyList[index],
              child: Stack(
                children: [
                  // Image.asset(
                  //   semiCircles,
                  // ),
                  // Container(
                  //     height: double.infinity,
                  //     width: double.infinity,
                  //     color: AppColors.primaryColorShade4
                  //         .withOpacity(0.5)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Chip(
                          label: Text(
                            "# ${index + 1}",
                            style: AppTextStyles.lato20PrimaryShade5
                                .copyWith(fontSize: 14, color: AppColors.white),
                          ),
                          backgroundColor: AppColors.primaryColorShade5,
                        ),
                        hSizedBox(10),
                        Text(
                          viewModel.hubsList[index].title.toUpperCase(),
                          style: AppTextStyles.latoBold16White.copyWith(
                            fontSize: 18,
                            color: AppColors.primaryColorShade5,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        hSizedBox(10),
                        Text(
                          "( ${viewModel.hubsList[index].contactPerson} )",
                          style: AppTextStyles.latoMedium14Black.copyWith(
                              color: AppColors.primaryColorShade5,
                              fontSize: 15),
                        ),
                        hSizedBox(10),
                        Text(
                          viewModel.hubsList[index].city,
                          style: AppTextStyles.latoMedium14Black
                              .copyWith(color: AppColors.primaryColorShade5),
                        ),
                        hSizedBox(25),
                        hubTitle(
                            context: context,
                            viewModel: viewModel,
                            index: index),
                        hSizedBox(25),
                        dropInput(
                          context: context,
                          viewModel: viewModel,
                          index: index,
                        ),
                        hSizedBox(25),
                        collectInput(
                          context: context,
                          viewModel: viewModel,
                          index: index,
                        ),
                        hSizedBox(25),
                        paymentInput(
                          context: context,
                          viewModel: viewModel,
                          enabled: index == viewModel.hubsList.length - 1,
                          index: index,
                        ),
                        hSizedBox(25),
                        remarksInput(
                          context: context,
                          viewModel: viewModel,
                          index: index,
                        ),
                        hSizedBox(25),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: index == 0
                                    ? Container()
                                    : SizedBox(
                                        height: buttonHeight,
                                        child: AppButton(
                                          onTap: () {
                                            hideKeyboard(context: context);
                                            updateData(
                                                viewModel: viewModel,
                                                index: index,
                                                goForward: false);
                                          },
                                          background:
                                              AppColors.primaryColorShade5,
                                          buttonText: "Previous",
                                          borderColor:
                                              AppColors.primaryColorShade1,
                                        ),
                                      ),
                              ),
                              wSizedBox(20),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: buttonHeight,
                                    child: AppButton(
                                      buttonText:
                                          index == viewModel.hubsList.length - 1
                                              ? "Finish"
                                              : "Next",
                                      onTap: index ==
                                              viewModel.hubsList.length - 1
                                          ? () {
                                              hideKeyboard(context: context);
                                              updateData(
                                                  viewModel: viewModel,
                                                  index: index);
                                              if (checkRequiredItems(
                                                  viewModel: viewModel)) {
                                                showSummaryBottomSheet(
                                                        viewModel: viewModel)
                                                    .then((value) {
                                                  viewModel.createConsignment(
                                                      consignmentTitle:
                                                          consignmentTitleController
                                                              .text);
                                                });

                                                // viewModel.createConsignment();
                                              }
                                            }
                                          : () {
                                              hideKeyboard(context: context);
                                              updateData(
                                                  viewModel: viewModel,
                                                  index: index);
                                            },
                                      borderColor: AppColors.primaryColorShade1,
                                      background: AppColors.primaryColorShade5,
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: viewModel.hubsList.length,
    );
  }

  Widget createConsignmentButton({CreateConsignmentModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, top: 10),
        child: ElevatedButton(
          child: Text("Create Consignment"),
          onPressed: () {
            if (consignmentTitleController.text.trim().length == 0) {
              locator<SnackbarService>()
                  .showSnackbar(message: "Please Enter Consignment Title");
              consignmentTitleFocusNode.requestFocus();
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            } else {
              locator<BottomSheetService>()
                  .showCustomSheet(
                customData: ConfirmationBottomSheetInputArgs(
                  title: 'Create Consignment?',
                  description:
                      "Are you sure that you want to create a consignment? You can still update it afterwards.",
                ),
                barrierDismissible: false,
                isScrollControlled: true,
                variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
              )
                  .then((value) {
                if (value != null) {
                  if (value.confirmed) {
                    viewModel.createConsignment(
                        consignmentTitle: consignmentTitleController.text);
                  } else {
                    locator<SnackbarService>()
                        .showSnackbar(message: "Not Confirmed");
                  }
                } else {
                  locator<SnackbarService>()
                      .showSnackbar(message: "Not Confirmed");
                }
              });
            }
          },
        ),
      ),
    );
  }

  // Widget submitConsignmentDetailsButton(
  //     {ConsignmentAllotmentViewModel viewModel,
  //     GlobalKey<FormState> formKey,
  //     FetchHubsResponse hubDetail}) {
  //   return SizedBox(
  //     height: buttonHeight,
  //     width: double.infinity,
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 4.0),
  //       child: OutlineButton(
  //         shape: new RoundedRectangleBorder(
  //           borderRadius: new BorderRadius.circular(30.0),
  //         ),
  //         borderSide: BorderSide(color: Colors.black),
  //         child: Text(hubDetail.isSubmitted ? "Update" : "Submit"),
  //         onPressed: () {
  //           if (formKey.currentState.validate()) {
  //             viewModel.hubsList.forEach((element) {
  //               if (element.sequence == hubDetail.sequence) {
  //                 element = element.copyWith(isSubmitted: true);
  //                 viewModel.notifyListeners();
  //               }
  //             });
  //             locator<SnackbarService>().showSnackbar(message: "Submitted");
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  registrationSelector({CreateConsignmentModel viewModel}) {
    return registrationNumberTextField(viewModel);
  }

  registrationNumberTextField(CreateConsignmentModel viewModel) {
    return appTextFormField(
        vehicleOwnerName: viewModel.validatedRegistrationNumber == null
            ? null
            : "(${viewModel.validatedRegistrationNumber.ownerName}, ${viewModel.validatedRegistrationNumber.model})",
        enabled: true,
        controller: selectedRegNoController,
        focusNode: selectedRegNoFocusNode,
        hintText: drRegNoHint,
        keyboardType: TextInputType.text,
        buttonType: ButtonType.SMALL,
        buttonIcon: Icon(Icons.search),
        onButtonPressed: () {
          validateRegistrationNumber(viewModel: viewModel);
        },
        onFieldSubmitted: (_) {
          validateRegistrationNumber(viewModel: viewModel);
        });
  }

  totalWeightTextField(CreateConsignmentModel viewModel) {
    return appTextFormField(
        enabled: true,
        controller: totalWeightController,
        focusNode: totalWeightFocusNode,
        hintText: 'Total ${viewModel.itemUnit ?? selectItemUnit[1]}',
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onTextChange: (String value) {
          viewModel.totalWeight = double.parse(value);
        });
  }

  consignmentTextField({CreateConsignmentModel viewModel}) {
    return appTextFormField(
        enabled: true,
        onTextChange: (_) {
          viewModel.resetControllerBoolValue();
        },
        controller: consignmentTitleController,
        focusNode: consignmentTitleFocusNode,
        hintText: consignmentTitleHint,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) => consignmentTitleFocusNode.unfocus());
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
              selectedDispatchTime.format(context).toLowerCase();
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

  Widget hubTitle(
      {BuildContext context, CreateConsignmentModel viewModel, int index}) {
    // if (!viewModel.isHubTitleEdited) {
    //   hubTitleController.text =
    //       viewModel?.consignmentRequest?.items[index]?.title?.toString();
    // }

    return createConsignmentTextFormField(
      decoration: getInputBorder(
          hintText: "Item Title",
          showSuffix: viewModel.consignmentRequest.items[index].titleError),
      enabled: true,
      // controller: hubTitleController,
      initialValue: viewModel.consignmentRequest.items[index].title ?? '',
      keyboardType: TextInputType.text,
      onTextChange: (String value) {
        viewModel.consignmentRequest.items[index].titleError = false;
        viewModel.consignmentRequest.items[index].title = value.trim();
        viewModel.notifyListeners();
        viewModel.isHubTitleEdited = true;
      },
      onFieldSubmitted: (_) {
        onfieldFocusChange(
          context,
          hubTitleFocusNode,
          dropFocusNode,
        );
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.consignmentRequest.items[index].titleError = true;
          viewModel.notifyListeners();
        }
        return null;
      },
    );
  }

  Widget remarksInput(
      {BuildContext context, CreateConsignmentModel viewModel, int index}) {
    // if (!viewModel.isRemarksEdited) {
    //   remarksController.text =
    //       viewModel?.consignmentRequest?.items[index]?.remarks?.toString();
    // }
    return TextFormField(
      // style: AppTextStyles.appBarTitleStyle,
      decoration: getInputBorder(hintText: "Remarks"),
      // maxLines: 5,
      enabled: true,
      // controller: remarksController,
      initialValue: viewModel.consignmentRequest.items[index].remarks ?? '',
      focusNode: remarksFocusNode,
      onChanged: (String value) {
        viewModel.isRemarksEdited = true;
        viewModel.consignmentRequest.items[index].remarks = value;
      },
      onFieldSubmitted: (_) {
        remarksFocusNode.unfocus();
      },
      // hintText: "Hub Title",
      keyboardType: TextInputType.text,
    );
  }

  Widget dropInput(
      {BuildContext context, CreateConsignmentModel viewModel, int index}) {
    print('dropInput, index = $index');
    return createConsignmentTextFormField(
      // style: AppTextStyles.appBarTitleStyle,
      onTextChange: (String value) {
        // if (value.trim().length > 0) {
        viewModel.consignmentRequest.items[index].dropOffError = false;
        viewModel.consignmentRequest.items[index].dropOff =
            value.trim().length == 0 ? 0 : int.parse(value);
        viewModel.notifyListeners();
        // }
        viewModel.isDropCratesEdited = true;
      },
      decoration: getInputBorder(
          hintText: "Item Drop (${viewModel.itemUnit})",
          showSuffix: viewModel.consignmentRequest.items[index].dropOffError),
      enabled: true,
      // controller: dropController,
      focusNode: dropFocusNode,
      initialValue: viewModel.consignmentRequest.items[index].dropOff == null
          ? ''
          : viewModel.consignmentRequest.items[index].dropOff.toString(),
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          dropFocusNode,
          collectFocusNode,
        );
      },
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          viewModel.consignmentRequest.items[index].dropOffError = true;
          viewModel.notifyListeners();
        }

        return null;
      },
    );
  }

  Widget collectInput(
      {BuildContext context, CreateConsignmentModel viewModel, int index}) {
    print('collectInput, index = $index');
    return createConsignmentTextFormField(
      // style: AppTextStyles.appBarTitleStyle,
      decoration: getInputBorder(
        hintText: "Item Collect (${viewModel.itemUnit})",
        showSuffix: viewModel.consignmentRequest.items[index].collectError,
      ),
      enabled: true,
      // controller: collectController,
      focusNode: collectFocusNode,
      initialValue: viewModel.consignmentRequest.items[index].collect == null
          ? ''
          : viewModel.consignmentRequest.items[index].collect.toString(),
      onTextChange: (String value) {
        // if (value.trim().length > 0) {
        viewModel.consignmentRequest.items[index].collectError = false;
        viewModel.consignmentRequest.items[index].collect =
            value.trim().length == 0 ? 0 : int.parse(value);
        viewModel.notifyListeners();
        // }
        viewModel.isCollectCratesEdited = true;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          collectFocusNode,
          paymentFocusNode,
        );
      },
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          viewModel.consignmentRequest.items[index].collectError = true;
          viewModel.notifyListeners();
        }
        return null;
      },
    );
  }

  Widget paymentInput({
    BuildContext context,
    CreateConsignmentModel viewModel,
    bool enabled,
    int index,
  }) {
    print('paymentInput, index = $index');
    return createConsignmentTextFormField(
      // style: AppTextStyles.appBarTitleStyle,
      decoration: getInputBorder(
        hintText: "Payment",
        showSuffix: viewModel.consignmentRequest.items[index].paymentError,
      ),
      enabled: !enabled,
      initialValue: getPaymentLabelInnitialValue(
          enabled: !enabled, viewModel: viewModel, index: index),
      // controller: paymentController,
      onTextChange: (String value) {
        // if (value.trim().length > 0) {
        viewModel.consignmentRequest.items[index].paymentError = false;
        viewModel.consignmentRequest.items[index].payment =
            value.trim().length == 0 ? 0 : double.parse(value);
        viewModel.notifyListeners();
        // }
        viewModel.isPaymentEdited = true;
      },
      focusNode: paymentFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          paymentFocusNode,
          remarksFocusNode,
        );
      },
      keyboardType: TextInputType.number,
      validator: (value) {
        if (!enabled) {
          return null;
        }
        if (value.isEmpty) {
          viewModel.consignmentRequest.items[index].paymentError = true;
          viewModel.notifyListeners();
        }
        return null;
      },
    );
  }

  getInputBorder({
    @required String hintText,
    bool showSuffix = false,
  }) {
    return InputDecoration(
      alignLabelWithHint: true,
      focusedErrorBorder: normalTextFormFieldBorder(),
      errorStyle: TextStyle(
        fontSize: 10,
      ),
      helperStyle: TextStyle(
        fontSize: 14,
      ),
      // contentPadding: EdgeInsets.all(16),
      labelText: hintText,
      labelStyle: TextStyle(color: AppColors.primaryColorShade5, fontSize: 14),
      fillColor: AppColors.appScaffoldColor,
      suffixIcon: showSuffix
          ? InkWell(
              onTap: () {
                // onPasswordTogglePressed(obscureText);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 70,
                  child: Center(
                    child: Text(
                      'required',
                      style: AppTextStyles.appBarTitleStyle
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ),
            )
          : null,
      focusedBorder: normalTextFormFieldBorder(),
      enabledBorder: normalTextFormFieldBorder(),
      disabledBorder: normalTextFormFieldBorder(),
      errorBorder: normalTextFormFieldBorder(),
    );
  }

  normalTextFormFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultBorder),
      borderSide: BorderSide(
        color: AppColors.primaryColorShade5,
      ),
    );
  }

  void updateData(
      {CreateConsignmentModel viewModel,
      int index,
      bool goForward = true,
      bool skip = false}) {
    bool isAllIsWell = true;

    if (viewModel.consignmentRequest.items[index].dropOff == null) {
      viewModel.consignmentRequest.items[index].dropOffError = true;
      isAllIsWell = false;
    }

    if (viewModel.consignmentRequest.items[index].collect == null) {
      viewModel.consignmentRequest.items[index].collectError = true;
      isAllIsWell = false;
    }

    if (viewModel.consignmentRequest.items[index].title == null) {
      viewModel.consignmentRequest.items[index].titleError = true;
      isAllIsWell = false;
    }

    // if (index < viewModel.consignmentRequest.items.length - 1 &&
    //     viewModel.consignmentRequest.items[index].payment == null) {
    //   viewModel.consignmentRequest.items[index].paymentError = true;
    //   isAllIsWell = false;
    // }

    if (isAllIsWell) {
      if (goForward) {
        print('Go fwd, index = $index');
        if (index < viewModel.hubsList.length) {
          _controller.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      } else {
        print('Go back, index = $index');
        if (index > 0) {
          _controller.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      }
    } else {
      viewModel.notifyListeners();
    }

    // if (skip || viewModel.formKeyList[index].currentState.validate()) {
    // FetchHubsResponse tempVar = viewModel.hubsList[index];
    // viewModel.hubsList.removeAt(index);
    // tempVar.copyWith(isSubmitted: true);
    // viewModel.hubsList.insert(index, tempVar);

    // viewModel.hubsList.forEach((element) {
    //   if (element.sequence == viewModel.hubsList[index].sequence) {
    //     Item item = viewModel.consignmentRequest.items[index];
    //     viewModel.consignmentRequest.items.removeAt(index);
    //     item = item.copyWith(
    //       dropOff:
    //           skip ? 0 : viewModel.consignmentRequest.items[index].dropOff,
    //       collect:
    //           skip ? 0 : viewModel.consignmentRequest.items[index].collect,
    //       payment:
    //           skip ? 0 : viewModel.consignmentRequest.items[index].payment,
    //       title:
    //           skip ? "NA" : viewModel.consignmentRequest.items[index].title,
    //       remarks:
    //           skip ? " " : viewModel.consignmentRequest.items[index].remarks,
    //     );
    //     viewModel.consignmentRequest.items.insert(index, item);
    //     viewModel.notifyListeners();
    //   }
    // });

    // }
  }

  void validateRegistrationNumber({CreateConsignmentModel viewModel}) {
    if (viewModel.selectedClient == null) {
      viewModel.snackBarService.showSnackbar(message: 'Please provide Client');
    } else if (selectedRegNoController.text.length == 0) {
      viewModel.snackBarService.showSnackbar(message: 'Please provide Reg no.');
    } else {
      viewModel.validateRegistrationNumber(
          selectedRegNoController.text.trim().toUpperCase());
      viewModel.resetControllerBoolValue();
      consignmentTitleController.clear();
    }
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

  Future<bool> showSummaryBottomSheet(
      {@required CreateConsignmentModel viewModel}) async {
    SheetResponse createConsignment = SheetResponse();

    createConsignment = await locator<BottomSheetService>().showCustomSheet(
      isScrollControlled: true,
      barrierDismissible: true,
      variant: BottomSheetType.createConsignmentSummary,
      // Which builder you'd like to call that was assigned in the builders function above.
      customData: CreateConsignmentDialogParams(
        selectedClient: viewModel.selectedClient,
        validatedRegistrationNumber: viewModel.validatedRegistrationNumber,
        consignmentRequest: viewModel.consignmentRequest,
        selectedRoute: viewModel.selectedRoute,
        itemUnit: viewModel.itemUnit,
      ),
    );

    return createConsignment.confirmed;
  }

  getPaymentLabelInnitialValue({
    @required bool enabled,
    @required CreateConsignmentModel viewModel,
    int index,
  }) {
    double payment = 0.00;

    if (enabled) {
      //payment can be entered in the widget. If individual item's payment
      //viewModel.consignmentRequest.items[index].payment is not null, and has a value, show it,
      //other wise show empty string.
      if (viewModel.consignmentRequest.items[index].payment == null ||
          viewModel.consignmentRequest.items[index].payment == 0) {
        return '';
      } else {
        payment = viewModel.consignmentRequest.items[index].payment;
      }
    } else {
      //payment can be not be entered in the widget. Its the last hub,
      //hence it will show sum of all payments
      //if viewModel.consignmentRequest.payment is not null, and has a value, show it,
      // other wise show empty string.
      if (viewModel.consignmentRequest.getTotalPayment() == null ||
          viewModel.consignmentRequest.getTotalPayment() == 0) {
        payment = 0;
      } else {
        payment = viewModel.consignmentRequest.getTotalPayment();
      }
    }

    return payment.toString();
  }
}

class RoutesDropDown extends StatefulWidget {
  final List<FetchRoutesResponse> optionList;
  final FetchRoutesResponse selectedValue;
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
  List<DropdownMenuItem<FetchRoutesResponse>> dropdown = [];

  List<DropdownMenuItem<FetchRoutesResponse>> getDropDownItems() {
    List<DropdownMenuItem<FetchRoutesResponse>> dropdown =
        <DropdownMenuItem<FetchRoutesResponse>>[];

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "#${widget.optionList[i].routeId}-${widget.optionList[i].routeTitle}",
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
