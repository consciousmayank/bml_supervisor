import 'package:flutter/material.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'add_entry_logs_viewmodel_2.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';

class AddEntryLogsView2PointO extends StatefulWidget {
  @override
  _AddEntryLogsView2PointOState createState() =>
      _AddEntryLogsView2PointOState();
}

class _AddEntryLogsView2PointOState extends State<AddEntryLogsView2PointO> {
  final _formKey = GlobalKey<FormState>();
  final _controller = ScrollController();
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddEntryLogsViewModel2PointO>.reactive(
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
                child: Column(
                  children: [
                    formView(context: context, viewModel: viewModel),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => AddEntryLogsViewModel2PointO(),
    );
  }

  formView({BuildContext context, AddEntryLogsViewModel2PointO viewModel}) {
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
      ),
    );
  }

  List<Widget> mobileFormView(
      {BuildContext context, AddEntryLogsViewModel2PointO viewModel}) {
    return [
      Column(
        children: [
          getValueForScreenType(
            context: context,
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dateSelector(context: context, viewModel: viewModel),
                registrationSelector(context: context, viewModel: viewModel),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  dateSelector({BuildContext context, AddEntryLogsViewModel2PointO viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        selectedDateTextField(viewModel),
        selectDateButton(context, viewModel),
      ],
    );
  }

  selectDateButton(
      BuildContext context, AddEntryLogsViewModel2PointO viewModel) {
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

  Future<DateTime> selectDate(AddEntryLogsViewModel2PointO viewModel) async {
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
      lastDate: new DateTime.now(),
    );

    return picked;
  }

  selectedDateTextField(AddEntryLogsViewModel2PointO viewModel) {
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
      {BuildContext context, AddEntryLogsViewModel2PointO viewModel}) {
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

  registrationNumberTextField(AddEntryLogsViewModel2PointO viewModel) {
    viewModel.selectedVehicle != null
        ? selectedRegNoController.text =
            viewModel.selectedVehicle.registrationNumber
        : selectedRegNoController.text = "";
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

  selectRegButton(
      BuildContext context, AddEntryLogsViewModel2PointO viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          if (selectedRegNoController.text.length == 0 ||
              selectedDateController.text.length == 0) {
            viewModel.snackBarService
                .showSnackbar(message: 'Please fill all the fields');
          } else {
            viewModel.getEntryLogForLastDate(
                selectedRegNoController.text.toUpperCase());
          }
        },
      ),
    );
  }
}
