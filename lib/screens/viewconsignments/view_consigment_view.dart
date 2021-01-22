import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_logs_view.dart';
import 'package:bml_supervisor/screens/viewconsignments/view_consignment_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ViewConsignmentView extends StatefulWidget {
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
        onModelReady: (viewModel) => viewModel.getClientIds(),
        builder: (context, viewModel, child) => SafeArea(
              left: false,
              right: false,
              child: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: true,
                    title: Text("View Consignments"),
                    actions: [
                      isEditAllowed
                          ? FlatButton(onPressed: () {}, child: Text("Edit"))
                          : Container()
                    ]),
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
        viewModelBuilder: () => ViewConsignmentViewModel());
  }

  void setDataInTextFormFields(
      {int position, ViewConsignmentViewModel viewModel}) {
    hubTitleController.text =
        viewModel.hubList[position].consignmentHubTitle ?? "";
    dropController.text = viewModel.hubList[position].dropOff.toString() ?? "";
    collectController.text =
        viewModel.hubList[position].collect.toString() ?? "";
    paymentController.text =
        viewModel.hubList[position].payment.toString() ?? "";
    remarksController.text = viewModel.hubList[position].remarks ?? "";
  }

  Widget body(BuildContext context, ViewConsignmentViewModel viewModel) {
    if (viewModel.hubList.length > 0) {
      setDataInTextFormFields(position: 0, viewModel: viewModel);
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          dateSelector(context: context, viewModel: viewModel),
          viewModel.entryDate != null
              ? ClientsDropDown(
                  optionList: viewModel.clientsList,
                  hint: "Select Client",
                  onOptionSelect: (GetClientsResponse selectedValue) {
                    viewModel.selectedClient = selectedValue;
                    viewModel.getRoutes(selectedValue.id);
                    viewModel.selectedRoute = null;
                  },
                  selectedClient: viewModel.selectedClient == null
                      ? null
                      : viewModel.selectedClient,
                )
              : Container(),
          viewModel.selectedClient == null
              ? Container()
              : RoutesDropDown(
                  optionList: viewModel.routesList,
                  hint: "Select Routes",
                  onOptionSelect:
                      (RoutesForSelectedClientAndDateResponse selectedValue) {
                    viewModel.selectedRoute = selectedValue;
                    viewModel.getConsignments();
                  },
                  selectedValue: viewModel.selectedRoute == null
                      ? null
                      : viewModel.selectedRoute,
                ),
          viewModel.hubList.length == 0
              ? Container()
              : SizedBox(
                  height: createConsignmentCardHeight,
                  child: Stack(
                    children: [
                      PageView.builder(
                        onPageChanged: (index) {
                          setDataInTextFormFields(
                              position: index, viewModel: viewModel);
                        },
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: AppColors.primaryColorShade5,
                            elevation: 4,
                            shape: getCardShape(),
                            child: Stack(
                              children: [
                                Image.asset(
                                  semiCircles,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              InkWell(
                                                child: Image.asset(
                                                  locationIcon,
                                                  fit: BoxFit.cover,
                                                  height: locationIconHeight,
                                                  width: locationIconWidth,
                                                ),
                                                onTap: () {
                                                  launchMaps(
                                                      viewModel.hubList[index]
                                                          .geoLatitude,
                                                      viewModel.hubList[index]
                                                          .geoLongitude);
                                                },
                                              ),
                                              Text("# ${index + 1}"),
                                              hSizedBox(10),
                                              Text(
                                                viewModel.hubList[index]
                                                    .contactPerson
                                                    .toUpperCase(),
                                                style: AppTextStyles
                                                    .latoBold18Black,
                                              ),
                                              hSizedBox(10),
                                              Text(
                                                "${viewModel.hubList[index].contactPerson}",
                                                style: AppTextStyles
                                                    .latoMedium14Black,
                                              ),
                                              Text(
                                                  viewModel.hubList[index].city,
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
                                                viewModel: viewModel),
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
                                                    viewModel.hubList.length -
                                                        1),
                                          ),
                                          wSizedBox(10),
                                          Expanded(
                                            flex: 1,
                                            child: gPaymentInput(
                                                context: context,
                                                viewModel: viewModel,
                                                enabled: index ==
                                                    viewModel.hubList.length -
                                                        1),
                                          ),
                                        ],
                                      ),
                                      hSizedBox(5),
                                      remarksInput(
                                          context: context,
                                          viewModel: viewModel),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: viewModel.hubList.length,
                      ),
                      Positioned(
                        bottom: 5,
                        left: 2,
                        right: 2,
                        child: DotsIndicator(
                          controller: _controller,
                          itemCount: viewModel.hubList.length,
                          color: AppColors.primaryColorShade1,
                        ),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget hubTitle(
      {BuildContext context, ViewConsignmentViewModel viewModel, int index}) {
    return TextFormField(
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
      {BuildContext context, ViewConsignmentViewModel viewModel}) {
    return TextFormField(
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
    );
  }

  Widget collectInput(
      {BuildContext context, ViewConsignmentViewModel viewModel}) {
    return TextFormField(
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
    );
  }

  Widget paymentInput({
    BuildContext context,
    ViewConsignmentViewModel viewModel,
    bool enabled,
  }) {
    return TextFormField(
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
      enabled: !enabled,
      decoration: getInputBorder(hint: enabled ? "" : "Payment Received"),
      controller: gPaymentController,
      focusNode: gPaymentFocusNode,
      onFieldSubmitted: (_) {
        gPaymentFocusNode.unfocus();
      },
      keyboardType: TextInputType.number,
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
            viewModel.selectedClient = null;
            viewModel.selectedRoute = null;
            viewModel.entryDate = selectedDate;
            if (viewModel.selectedClient != null) {
              viewModel.getRoutes(viewModel.selectedClient.id);
            }
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
        List<DropdownMenuItem<RoutesForSelectedClientAndDateResponse>>();

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].routeName}  (${widget.optionList[i].routeId})",
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
