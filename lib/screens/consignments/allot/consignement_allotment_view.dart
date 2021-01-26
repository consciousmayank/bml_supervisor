import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/enums/dialog_type.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_logs_view.dart';
import 'package:bml_supervisor/screens/consignments/allot/consignement_allotment_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'consignment_dialog_params.dart';

class ConsignmentAllotmentView extends StatefulWidget {
  @override
  _ConsignmentAllotmentViewState createState() =>
      _ConsignmentAllotmentViewState();
}

class _ConsignmentAllotmentViewState extends State<ConsignmentAllotmentView> {
  bool isEditAllowed = true;
  ScrollController _scrollController = ScrollController();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();

  final TextEditingController consignmentTitleController =
      TextEditingController();
  final FocusNode consignmentTitleFocusNode = FocusNode();

  final PageController _controller = PageController(
    initialPage: 0,
  );

  TextEditingController hubTitleController = TextEditingController();
  FocusNode hubTitleFocusNode = FocusNode();

  TextEditingController remarksController = TextEditingController();
  FocusNode remarksFocusNode = FocusNode();

  TextEditingController dropController = TextEditingController();
  FocusNode dropFocusNode = FocusNode();

  TextEditingController collectController = TextEditingController();
  FocusNode collectFocusNode = FocusNode();

  TextEditingController paymentController = TextEditingController();
  FocusNode paymentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentAllotmentViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getClientIds(),
      builder: (context, viewModel, child) => SafeArea(
          left: false,
          right: false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text("Allot Consignments"),
            ),
            body: viewModel.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: getSidePadding(context: context),
                    child: body(context, viewModel),
                  ),
          )),
      viewModelBuilder: () => ConsignmentAllotmentViewModel(),
    );
  }

  Widget body(BuildContext context, ConsignmentAllotmentViewModel viewModel) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClientsDropDown(
            optionList: viewModel.clientsList,
            hint: "Select Client",
            onOptionSelect: (GetClientsResponse selectedValue) {
              viewModel.selectedClient = selectedValue;
              viewModel.getRoutes(selectedValue.id);
            },
            selectedClient: viewModel.selectedClient == null
                ? null
                : viewModel.selectedClient,
          ),
          RoutesDropDown(
            optionList: viewModel.routesList,
            hint: "Select Routes",
            onOptionSelect: (GetRoutesResponse selectedValue) {
              viewModel.selectedRoute = selectedValue;
              viewModel.getHubs();
              consignmentTitleController.clear();
              hubTitleController.clear();
              dropController.clear();
              collectController.clear();
              paymentController.clear();
              remarksController.clear();
            },
            selectedValue: viewModel.selectedRoute == null
                ? null
                : viewModel.selectedRoute,
          ),

          // getConsignments
          viewModel.selectedRoute == null
              ? Container()
              // : makeTimeLine(context: context, viewModel: viewModel)
              : dateSelector(context: context, viewModel: viewModel),

          viewModel.entryDate == null
              ? Container()
              : registrationSelector(context: context, viewModel: viewModel),

          viewModel.entryDate == null
              ? Container()
              : consignmentTextField(viewModel: viewModel),

          viewModel.validatedRegistrationNumber == null
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      "${viewModel.validatedRegistrationNumber.ownerName}, ${viewModel.validatedRegistrationNumber.model}"),
                ),

          viewModel.validatedRegistrationNumber == null
              ? Container()
              : SizedBox(
                  height: createConsignmentCardHeight,
                  child: Stack(
                    children: [
                      PageView.builder(
                        onPageChanged: (index) {
                          hubTitleController.text =
                              viewModel.consignmentRequest.items[index].title ??
                                  "";
                          dropController.text = viewModel.consignmentRequest
                                      .items[index].dropOff !=
                                  null
                              ? dropController.text = viewModel
                                  .consignmentRequest.items[index].dropOff
                                  .toString()
                              : "";
                          collectController.text = viewModel.consignmentRequest
                                      .items[index].collect !=
                                  null
                              ? viewModel
                                  .consignmentRequest.items[index].collect
                                  .toString()
                              : "";

                          if (index == viewModel.hubsList.length - 1) {
                            double grandTotal = 0;
                            for (int i = 1;
                                i <
                                    viewModel.consignmentRequest.items.length -
                                        1;
                                i++) {
                              if (viewModel
                                      .consignmentRequest.items[i].payment !=
                                  null) {
                                grandTotal = grandTotal +
                                        viewModel.consignmentRequest.items[i]
                                            .payment ??
                                    0;
                              }
                            }

                            viewModel.consignmentRequest.items
                                .forEach((element) {});
                            paymentController.text = grandTotal.toString();
                          } else {
                            paymentController.text = viewModel
                                        .consignmentRequest
                                        .items[index]
                                        .payment !=
                                    null
                                ? viewModel
                                    .consignmentRequest.items[index].payment
                                    .toString()
                                : "";
                          }

                          remarksController.text = viewModel
                                  .consignmentRequest.items[index].remarks ??
                              "";
                        },
                        // physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: ThemeConfiguration.primaryBackground,
                            elevation: 4,
                            shape: getCardShape(),
                            child: Container(
                              // padding: EdgeInsets.all(8),
                              child: Form(
                                key: viewModel.formKeyList[index],
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      semiCircles,
                                    ),
                                    // Container(
                                    //     height: double.infinity,
                                    //     width: double.infinity,
                                    //     color: AppColors.primaryColorShade4
                                    //         .withOpacity(0.5)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  InkWell(
                                                    child: Image.asset(
                                                      locationIcon,
                                                      fit: BoxFit.cover,
                                                      height:
                                                          locationIconHeight,
                                                      width: locationIconWidth,
                                                    ),
                                                    onTap: () {
                                                      launchMaps(
                                                          viewModel
                                                              .hubsList[index]
                                                              .geoLatitude,
                                                          viewModel
                                                              .hubsList[index]
                                                              .geoLongitude);
                                                    },
                                                  ),
                                                  Text("# ${index + 1}"),
                                                  hSizedBox(10),
                                                  Text(
                                                    viewModel
                                                        .hubsList[index].title
                                                        .toUpperCase(),
                                                    style: AppTextStyles
                                                        .latoBold18Black,
                                                  ),
                                                  hSizedBox(10),
                                                  Text(
                                                    "${viewModel.hubsList[index].contactPerson}",
                                                    style: AppTextStyles
                                                        .latoMedium14Black,
                                                  ),
                                                  Text(
                                                      viewModel
                                                          .hubsList[index].city,
                                                      style: AppTextStyles
                                                          .latoMedium14Black),
                                                ],
                                              ),
                                            ),
                                          ),
                                          hubTitle(
                                              context: context,
                                              viewModel: viewModel,
                                              index: index),
                                          hSizedBox(5),
                                          dropInput(
                                              context: context,
                                              viewModel: viewModel),
                                          hSizedBox(5),
                                          collectInput(
                                              context: context,
                                              viewModel: viewModel),
                                          hSizedBox(5),
                                          paymentInput(
                                              context: context,
                                              viewModel: viewModel,
                                              enabled: index ==
                                                  viewModel.hubsList.length -
                                                      1),
                                          remarksInput(
                                              context: context,
                                              viewModel: viewModel),
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
                                                              updateData(
                                                                  viewModel:
                                                                      viewModel,
                                                                  index: index,
                                                                  goForward:
                                                                      false);
                                                            },
                                                            background: AppColors
                                                                .primaryColorShade5,
                                                            buttonText:
                                                                "Previous",
                                                            borderColor: AppColors
                                                                .primaryColorShade1,
                                                          ),
                                                        ),
                                                ),
                                                wSizedBox(20),
                                                Expanded(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      height: buttonHeight,
                                                      child: AppButton(
                                                        buttonText: index ==
                                                                viewModel
                                                                        .hubsList
                                                                        .length -
                                                                    1
                                                            ? "Finish"
                                                            : "Next",
                                                        onTap: index ==
                                                                viewModel
                                                                        .hubsList
                                                                        .length -
                                                                    1
                                                            ? () {
                                                                updateData(
                                                                    viewModel:
                                                                        viewModel,
                                                                    index:
                                                                        index);

                                                                if (consignmentTitleController
                                                                        .text
                                                                        .trim()
                                                                        .length ==
                                                                    0) {
                                                                  locator<SnackbarService>()
                                                                      .showSnackbar(
                                                                          message:
                                                                              "Please Enter Consignment Title");
                                                                  consignmentTitleFocusNode
                                                                      .requestFocus();
                                                                  _scrollController.animateTo(0,
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              200),
                                                                      curve: Curves
                                                                          .easeInOut);
                                                                } else {
                                                                  locator<
                                                                          DialogService>()
                                                                      .showCustomDialog(
                                                                    variant:
                                                                        DialogType
                                                                            .CREATE_CONSIGNMENT,
                                                                    // Which builder you'd like to call that was assigned in the builders function above.
                                                                    customData:
                                                                        ConsignmentDialogParams(
                                                                      selectedClient:
                                                                          viewModel
                                                                              .selectedClient,
                                                                      validatedRegistrationNumber:
                                                                          viewModel
                                                                              .validatedRegistrationNumber,
                                                                      consignmentRequest:
                                                                          viewModel
                                                                              .consignmentRequest,
                                                                      selectedRoute:
                                                                          viewModel
                                                                              .selectedRoute,
                                                                    ),
                                                                  )
                                                                      .then(
                                                                          (value) {
                                                                    if (value !=
                                                                        null) {
                                                                      if (value
                                                                          .confirmed) {
                                                                        viewModel.createConsignment(
                                                                            consignmentTitle:
                                                                                consignmentTitleController.text);
                                                                      }
                                                                    }
                                                                  });
                                                                }
                                                              }
                                                            : () {
                                                                updateData(
                                                                    viewModel:
                                                                        viewModel,
                                                                    index:
                                                                        index);
                                                              },
                                                        borderColor: AppColors
                                                            .primaryColorShade1,
                                                        background: AppColors
                                                            .primaryColorShade5,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    index == viewModel.hubsList.length - 1 ||
                                            index == 0
                                        ? Container()
                                        : Positioned(
                                            right: 10,
                                            top: 10,
                                            child: InkWell(
                                              child: Text("Skip"),
                                              onTap: () {
                                                updateData(
                                                    viewModel: viewModel,
                                                    index: index,
                                                    goForward: true,
                                                    skip: true);
                                              },
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: viewModel.hubsList.length,
                      ),
                      Positioned(
                        bottom: 6,
                        left: 2,
                        right: 2,
                        child: DotsIndicator(
                          controller: _controller,
                          itemCount: viewModel.hubsList.length,
                          color: AppColors.primaryColorShade1,
                        ),
                      )
                    ],
                  ),
                ),

          // viewModel.validatedRegistrationNumber == null
          //     ? Container()
          //     : createConsignmentButton(viewModel: viewModel)
        ],
      ),
    );
  }

  Widget createConsignmentButton({ConsignmentAllotmentViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, top: 10),
        child: RaisedButton(
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
              locator<DialogService>()
                  .showConfirmationDialog(
                barrierDismissible: false,
                title: 'Create Consignment?',
                description:
                    "Are you sure that you want to create a consignment? You can still update it afterwards.",
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

  registrationSelector(
      {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
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

  registrationNumberTextField(ConsignmentAllotmentViewModel viewModel) {
    return appTextFormField(
        enabled: true,
        controller: selectedRegNoController,
        focusNode: selectedRegNoFocusNode,
        hintText: drRegNoHint,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (_) {
          validateRegistrationNumber(viewModel: viewModel);
        });
  }

  consignmentTextField({ConsignmentAllotmentViewModel viewModel}) {
    return appTextFormField(
        enabled: true,
        controller: consignmentTitleController,
        focusNode: consignmentTitleFocusNode,
        hintText: consignmentTitleHint,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) => consignmentTitleFocusNode.unfocus());
  }

  selectRegButton(
      BuildContext context, ConsignmentAllotmentViewModel viewModel) {
    return SizedBox(
      height: 58,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0, right: 4),
        child: appSuffixIconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            validateRegistrationNumber(viewModel: viewModel);
          },
        ),
      ),
    );
  }

  dateSelector(
      {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectedDateTextField(ConsignmentAllotmentViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Entry Date",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  selectDateButton(
      BuildContext context, ConsignmentAllotmentViewModel viewModel) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, right: 4),
        child: appSuffixIconButton(
          icon: Icon(Icons.calendar_today_outlined),
          onPressed: (() async {
            DateTime selectedDate = await selectDate();
            if (selectedDate != null) {
              selectedDateController.text =
                  DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
              viewModel.entryDate = selectedDate;
            }
          }),
        ),
      ),
    );
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
      helpText: 'Registration Expires on',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Expiration Date',
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  Widget hubTitle(
      {BuildContext context,
      ConsignmentAllotmentViewModel viewModel,
      int index}) {
    return TextFormField(
      decoration: getInputBorder(hintText: "Enter HubTitle"),
      enabled: true,
      controller: hubTitleController,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          hubTitleFocusNode,
          dropFocusNode,
        );
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

  Widget remarksInput(
      {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
    return TextFormField(
      decoration: getInputBorder(hintText: "Enter Remarks"),
      enabled: true,
      controller: remarksController,
      focusNode: remarksFocusNode,
      onFieldSubmitted: (_) {
        remarksFocusNode.unfocus();
      },
      // hintText: "Hub Title",
      keyboardType: TextInputType.text,
    );
  }

  Widget dropInput(
      {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
    return TextFormField(
      decoration: getInputBorder(hintText: "Enter Crates to drop"),
      enabled: true,
      controller: dropController,
      focusNode: dropFocusNode,
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
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget collectInput(
      {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
    return TextFormField(
      decoration: getInputBorder(hintText: "Enter Crates to collect"),
      enabled: true,
      controller: collectController,
      focusNode: collectFocusNode,
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
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget paymentInput({
    BuildContext context,
    ConsignmentAllotmentViewModel viewModel,
    bool enabled,
  }) {
    return TextFormField(
      decoration: getInputBorder(hintText: "Enter Payment"),
      enabled: !enabled,
      controller: paymentController,
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
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  getInputBorder({String hintText}) {
    return InputDecoration(
      alignLabelWithHint: true,
      errorStyle: TextStyle(
        fontSize: 14,
      ),
      helperStyle: TextStyle(
        fontSize: 14,
      ),
      helperText: ' ',
      labelText: hintText,
      labelStyle: TextStyle(color: AppColors.black, fontSize: 14),
      fillColor: AppColors.primaryColorShade5,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.primaryColorShade1,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.primaryColorShade1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.primaryColorShade1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: AppColors.primaryColorShade1,
        ),
      ),
    );
  }

  void updateData(
      {ConsignmentAllotmentViewModel viewModel,
      int index,
      bool goForward = true,
      bool skip = false}) {
    if (skip || viewModel.formKeyList[index].currentState.validate()) {
      FetchHubsResponse tempVar = viewModel.hubsList[index];
      viewModel.hubsList.removeAt(index);
      tempVar.copyWith(isSubmitted: true);
      viewModel.hubsList.insert(index, tempVar);

      viewModel.hubsList.forEach((element) {
        if (element.sequence == viewModel.hubsList[index].sequence) {
          Item item = viewModel.consignmentRequest.items[index];
          viewModel.consignmentRequest.items.removeAt(index);
          item = item.copyWith(
            dropOff: skip ? 0 : int.parse(dropController.text),
            collect: skip ? 0 : int.parse(collectController.text),
            payment: skip ? 0 : double.parse(paymentController.text),
            title: skip ? " " : hubTitleController.text.trim(),
            remarks: skip ? " " : remarksController.text.trim(),
          );
          viewModel.consignmentRequest.items.insert(index, item);

          viewModel.notifyListeners();
        }
      });

      if (goForward) {
        if (index < viewModel.hubsList.length) {
          _controller.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      } else {
        if (index > 0) {
          _controller.previousPage(
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      }
    }
  }

  void validateRegistrationNumber({ConsignmentAllotmentViewModel viewModel}) {
    if (viewModel.selectedClient == null) {
      viewModel.snackBarService.showSnackbar(message: 'Please provide Client');
    } else if (selectedRegNoController.text.length == 0) {
      viewModel.snackBarService.showSnackbar(message: 'Please provide Reg no.');
    } else {
      viewModel.validateRegistrationNumber(
          selectedRegNoController.text.trim().toUpperCase());
    }
  }
}

class RoutesDropDown extends StatefulWidget {
  final List<GetRoutesResponse> optionList;
  final GetRoutesResponse selectedValue;
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
  List<DropdownMenuItem<GetRoutesResponse>> dropdown = [];

  List<DropdownMenuItem<GetRoutesResponse>> getDropDownItems() {
    List<DropdownMenuItem<GetRoutesResponse>> dropdown =
        List<DropdownMenuItem<GetRoutesResponse>>();

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].title}  (${widget.optionList[i].id})",
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