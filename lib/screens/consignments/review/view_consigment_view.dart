import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart'
    as reviewConsignment;
import 'package:bml_supervisor/screens/consignments/review/review_consignment_args.dart';
import 'package:bml_supervisor/screens/consignments/review/view_consignment_viewmodel.dart';
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

class ViewConsignmentView extends StatefulWidget {
  final ReviewConsignmentArgs reviewConsignmentArgs;

  const ViewConsignmentView({Key key, @required this.reviewConsignmentArgs})
      : super(key: key);

  @override
  _ViewConsignmentViewState createState() => _ViewConsignmentViewState();
}

class _ViewConsignmentViewState extends State<ViewConsignmentView> {
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  final PageController _controller = PageController(
    initialPage: 0,
  );

  ScrollController _scrollController = ScrollController();
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

  TextEditingController gDropController = TextEditingController();
  FocusNode gDropFocusNode = FocusNode();

  TextEditingController gCollectController = TextEditingController();
  FocusNode gCollectFocusNode = FocusNode();

  TextEditingController gPaymentController = TextEditingController();
  FocusNode gPaymentFocusNode = FocusNode();

  bool isEditAllowed = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewConsignmentViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClientIds();
          viewModel.getConsignmentWithId(
            consignmentId: widget
                .reviewConsignmentArgs.selectedConsignment.consigmentId
                .toString(),
          );
        },
        builder: (context, viewModel, child) => WillPopScope(
              onWillPop: () {
                viewModel.navigationService.back(result: false);
                return Future.value(false);
              },
              child: SafeArea(
                left: false,
                right: false,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: true,
                    title: Text(
                        "Review Consignments - ${MyPreferences().getSelectedClient().clientId}",
                        style: AppTextStyles.appBarTitleStyle),
                    // actions: [
                    //   isEditAllowed
                    //       ? TextButton(
                    //           onPressed: () {
                    //             // call update consignment api
                    //           },
                    //           child: Text("Edit"))
                    //       : Container()
                    // ],
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
            ),
        viewModelBuilder: () => ViewConsignmentViewModel());
  }

  void setDataInTextFormFields({
    int position,
    ViewConsignmentViewModel viewModel,
  }) {
    hubTitleController.text = viewModel
            .consignmentDetailResponseNew.items[position].title
            .toString() ??
        "";
    dropController.text = viewModel
            .consignmentDetailResponseNew.items[position].dropOff
            .toString() ??
        "";
    collectController.text = viewModel
            .consignmentDetailResponseNew.items[position].collect
            .toString() ??
        "";
    paymentController.text = viewModel
            .consignmentDetailResponseNew.items[position].payment
            .toString() ??
        "";
    remarksController.text =
        viewModel.consignmentDetailResponseNew.items[position].remarks ?? "";
    gDropController.text = viewModel
            .reviewConsignmentRequest.reviewedItems[position].dropOff
            .toString() ??
        "";
    gCollectController.text = viewModel
            .reviewConsignmentRequest.reviewedItems[position].collect
            .toString() ??
        "";
    // gPaymentController.text = viewModel
    //         .consignmentDetailResponseNew.items[position].payment
    //         .toString() ??
    //     "";
    if (position ==
        viewModel.reviewConsignmentRequest.reviewedItems.length - 1) {
      double grandTotal = 0;
      for (int i = 1;
          i < viewModel.reviewConsignmentRequest.reviewedItems.length - 1;
          i++) {
        grandTotal = grandTotal +
            viewModel.reviewConsignmentRequest.reviewedItems[i].payment;
      }

      gPaymentController.text = grandTotal.toString();
    } else {
      gPaymentController.text = viewModel
              .reviewConsignmentRequest.reviewedItems[position].payment
              .toString() ??
          "";
    }
  }

  Widget body(BuildContext context, ViewConsignmentViewModel viewModel) {
    if (viewModel.consignmentDetailResponseNew != null &&
        !viewModel.isInitiallyDataSet &&
        viewModel.consignmentDetailResponseNew.items.length > 0) {
      setDataInTextFormFields(position: 0, viewModel: viewModel);
      viewModel.isInitiallyDataSet = true;
    }
    return viewModel.consignmentDetailResponseNew != null
        ? SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (index) {
                      setDataInTextFormFields(
                          position: index, viewModel: viewModel);
                    },
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: AppColors.primaryColorShade5,
                        elevation: 4,
                        shape: getCardShape(),
                        child: Form(
                          key: viewModel.formKeyList[index],
                          child: Stack(
                            children: [
                              Image.asset(
                                semiCircles,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                            Text("# ${index + 1}"),
                                            hSizedBox(10),
                                            Text(
                                              viewModel
                                                  .consignmentDetailResponseNew
                                                  .items[index]
                                                  .hubContactPerson
                                                  .toUpperCase(),
                                              style:
                                                  AppTextStyles.latoBold18Black,
                                            ),
                                            hSizedBox(10),
                                            Text(
                                              "${viewModel.consignmentDetailResponseNew.items[index].hubContactPerson}",
                                              style: AppTextStyles
                                                  .latoMedium14Black,
                                            ),
                                            Text(
                                                viewModel
                                                    .consignmentDetailResponseNew
                                                    .items[index]
                                                    .hubCity,
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
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: dropInput(
                                              context: context,
                                              viewModel: viewModel),
                                        ),
                                        wSizedBox(10),
                                        Expanded(
                                          flex: 1,
                                          child: gDropInput(
                                              context: context,
                                              viewModel: viewModel,
                                              index: index),
                                        ),
                                      ],
                                    ),
                                    hSizedBox(5),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: collectInput(
                                              context: context,
                                              viewModel: viewModel),
                                        ),
                                        wSizedBox(10),
                                        Expanded(
                                          flex: 1,
                                          child: gCollectInput(
                                              context: context,
                                              viewModel: viewModel),
                                        ),
                                      ],
                                    ),
                                    hSizedBox(5),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: paymentInput(
                                              context: context,
                                              viewModel: viewModel,
                                              enabled: index ==
                                                  viewModel
                                                          .consignmentDetailResponseNew
                                                          .items
                                                          .length -
                                                      1),
                                        ),
                                        wSizedBox(10),
                                        Expanded(
                                          flex: 1,
                                          child: gPaymentInput(
                                              context: context,
                                              viewModel: viewModel,
                                              enabled: index ==
                                                  viewModel
                                                          .consignmentDetailResponseNew
                                                          .items
                                                          .length -
                                                      1),
                                        ),
                                      ],
                                    ),
                                    hSizedBox(5),
                                    remarksInput(
                                        context: context, viewModel: viewModel),
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
                                                        updateReviewConsignmentData(
                                                          viewModel: viewModel,
                                                          index: index,
                                                          goForward: false,
                                                        );
                                                      },
                                                      background: AppColors
                                                          .primaryColorShade5,
                                                      buttonText: "Previous",
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
                                                                  .consignmentDetailResponseNew
                                                                  .items
                                                                  .length -
                                                              1
                                                      ? "Finish"
                                                      : "Next",
                                                  onTap: index ==
                                                          viewModel
                                                                  .consignmentDetailResponseNew
                                                                  .items
                                                                  .length -
                                                              1
                                                      ? () {
                                                          // finish btn functionality
                                                          updateReviewConsignmentData(
                                                              viewModel:
                                                                  viewModel,
                                                              index: index);
                                                          // update api call
                                                          viewModel
                                                              .updateConsignment();
                                                        }
                                                      : () {
                                                          // Next btn functionality
                                                          updateReviewConsignmentData(
                                                              viewModel:
                                                                  viewModel,
                                                              index: index);
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
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount:
                        viewModel.consignmentDetailResponseNew.items.length,
                  ),
                  Positioned(
                    bottom: 5,
                    left: 2,
                    right: 2,
                    child: DotsIndicator(
                      controller: _controller,
                      itemCount:
                          viewModel.consignmentDetailResponseNew.items.length,
                      color: AppColors.primaryColorShade1,
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget hubTitle(
      {BuildContext context, ViewConsignmentViewModel viewModel, int index}) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      decoration: getInputBorder(hint: "Title"),
      enabled: false,
      controller: hubTitleController,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          hubTitleFocusNode,
          dropFocusNode,
        );
      },
    );
  }

  Widget remarksInput(
      {BuildContext context, ViewConsignmentViewModel viewModel}) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      enabled: false,
      decoration: getInputBorder(hint: "Remarks"),
      controller: remarksController,
      focusNode: remarksFocusNode,
      onFieldSubmitted: (_) {
        remarksFocusNode.unfocus();
      },
      // hintText: "Hub Title",
      keyboardType: TextInputType.text,
    );
  }

  Widget dropInput({BuildContext context, ViewConsignmentViewModel viewModel}) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      enabled: false,
      decoration: getInputBorder(hint: "Crates To Drop"),
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
    );
  }

  Widget gDropInput(
      {BuildContext context, ViewConsignmentViewModel viewModel, int index}) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      // onChanged: (newGDrop) {
      //   // viewModel.consignmentDetailResponseNew.items[index].dropOffG = newGDrop;
      //   print('before dropG: ${viewModel.consignmentDetailResponseNew.items[index].dropOffG}');
      //   print('***************************************');
      //   ConsignmentDetailsResponse temp = viewModel.consignmentDetailResponseNew.items[index];
      //   viewModel.consignmentDetailResponseNew.items.removeAt(index);
      //   temp = temp.copyWith(dropOffG: int.parse(newGDrop));
      //   viewModel.consignmentDetailResponseNew.items.insert(index, temp);
      //   print('after dropG: ${viewModel.consignmentDetailResponseNew.items[index].dropOffG}');
      // },
      enabled: true,
      decoration: getInputBorder(hint: "Crates Dropped"),
      controller: gDropController,
      focusNode: gDropFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          gDropFocusNode,
          gCollectFocusNode,
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
      {BuildContext context, ViewConsignmentViewModel viewModel}) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      enabled: false,
      decoration: getInputBorder(hint: "Crates To Collect"),
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
    );
  }

  Widget gCollectInput(
      {BuildContext context, ViewConsignmentViewModel viewModel}) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      enabled: true,
      decoration: getInputBorder(hint: "Crates Collected"),
      controller: gCollectController,
      focusNode: gCollectFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          gCollectFocusNode,
          gPaymentFocusNode,
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
    ViewConsignmentViewModel viewModel,
    bool enabled,
  }) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      enabled: false,
      decoration: getInputBorder(hint: enabled ? "" : "Payment To Receive"),
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
    );
  }

  Widget gPaymentInput({
    BuildContext context,
    ViewConsignmentViewModel viewModel,
    bool enabled,
  }) {
    return TextFormField(
      style: AppTextStyles.appBarTitleStyle,
      enabled: !enabled,
      decoration: getInputBorder(hint: enabled ? "" : "Payment Received"),
      controller: gPaymentController,
      focusNode: gPaymentFocusNode,
      onFieldSubmitted: (_) {
        gPaymentFocusNode.unfocus();
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

  dateSelector({BuildContext context, ViewConsignmentViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectedDateTextField(ViewConsignmentViewModel viewModel) {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: "Entry Date",
      labelText: "Entry Date",
      keyboardType: TextInputType.text,
    );
  }

  selectDateButton(BuildContext context, ViewConsignmentViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.calendar_today_outlined),
        onPressed: (() async {
          DateTime selectedDate = await selectDate();
          if (selectedDate != null) {
            selectedDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
            viewModel.selectedRoute = null;
            viewModel.entryDate = selectedDate;
            // viewModel.getRoutes(viewModel.selectedClient.clientId);
            viewModel.getConsignmentListWithDate();
          }
        }),
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

  getInputBorder({@required String hint}) {
    return InputDecoration(
      alignLabelWithHint: true,
      errorStyle: TextStyle(
        fontSize: 14,
      ),
      labelText: hint,
      helperStyle: TextStyle(
        fontSize: 14,
      ),
      helperText: ' ',
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

  void updateReviewConsignmentData({
    ViewConsignmentViewModel viewModel,
    int index,
    bool goForward = true,
    bool skip = false,
  }) {
    if (skip || viewModel.formKeyList[index].currentState.validate()) {
      print('form validated');
      print('gDropController.text: ${gDropController.text}');
      print('gCollectController.text: ${gCollectController.text}');
      print('gPaymentController.text: ${gPaymentController.text}');

      reviewConsignment.Item tempReviewItem =
          viewModel.reviewConsignmentRequest.reviewedItems[index];
      viewModel.reviewConsignmentRequest.reviewedItems.removeAt(index);
      // viewModel.consignmentDetailResponseNew.reviewedItems.add()
      tempReviewItem = tempReviewItem.copyWith(
        dropOff: skip ? 0 : int.parse(gDropController.text),
        collect: skip ? 0 : int.parse(gCollectController.text),
        payment: skip ? 0 : double.parse(gPaymentController.text),
      );
      viewModel.reviewConsignmentRequest.reviewedItems
          .insert(index, tempReviewItem);
      viewModel.notifyListeners();
      print('request object values');
      print(
          '${viewModel.reviewConsignmentRequest.reviewedItems[index].dropOff}');
      print(
          '${viewModel.reviewConsignmentRequest.reviewedItems[index].collect}');
      print(
          '${viewModel.reviewConsignmentRequest.reviewedItems[index].payment}');

      if (goForward) {
        if (index < viewModel.consignmentDetailResponseNew.items.length) {
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
}

class ConsignmentsDropDown extends StatefulWidget {
  final List<ConsignmentsForSelectedDateAndClientResponse> optionList;
  final ConsignmentsForSelectedDateAndClientResponse selectedConsignment;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  ConsignmentsDropDown(
      {@required this.optionList,
      this.selectedConsignment,
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _ConsignmentsDropDownState createState() => _ConsignmentsDropDownState();
}

class _ConsignmentsDropDownState extends State<ConsignmentsDropDown> {
  // List<DropdownMenuItem<ConsignmentsForSelectedDateAndClientResponse>>
  //     dropdown = [];

  List<DropdownMenuItem<ConsignmentsForSelectedDateAndClientResponse>>
      getDropDownItems() {
    List<DropdownMenuItem<ConsignmentsForSelectedDateAndClientResponse>>
        dropdown =
        <DropdownMenuItem<ConsignmentsForSelectedDateAndClientResponse>>[];

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "C#${widget.optionList[i].consigmentId}/ ${widget.optionList[i].routeTitle}/ R#${widget.optionList[i].routeId}",
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
                    value: widget.selectedConsignment,
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
