import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/screens/payments/add/add_payment_viewmodel.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class AddPaymentView extends StatefulWidget {
  @override
  _AddPaymentViewState createState() => _AddPaymentViewState();
}

class _AddPaymentViewState extends State<AddPaymentView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: setAppBarTitle(title: 'Add Payment'),
              ),
              body: viewModel.isBusy
                  ? ShimmerContainer(
                      itemCount: 20,
                    )
                  : AddPaymentBodyWidget(
                      viewModel: viewModel,
                    ),
            ),
        viewModelBuilder: () => AddPaymentViewModel());
  }
}

class AddPaymentBodyWidget extends StatefulWidget {
  final AddPaymentViewModel viewModel;

  AddPaymentBodyWidget({this.viewModel});

  @override
  _AddPaymentBodyWidgetState createState() => _AddPaymentBodyWidgetState();
}

class _AddPaymentBodyWidgetState extends State<AddPaymentBodyWidget> {
  final FocusNode totalKmFocusNode = FocusNode();
  final TextEditingController totalKmController = TextEditingController();

  final FocusNode totalAmountFocusNode = FocusNode();
  final TextEditingController totalAmountController = TextEditingController();
  final FocusNode remarksFocusNode = FocusNode();
  final TextEditingController remarksController = TextEditingController();

  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          // controller: _scrollController,
          children: [
            // dateSelector(viewModel: widget.viewModel),
            buildDobView(),
            totalKmView(context: context),
            totalPaymentView(context: context),
            getRemarksView(),
            hSizedBox(10),
            addNewPaymentButton(viewModel: widget.viewModel),
          ],
        ),
      ),
    );
  }

  Widget buildDobView() {
    return appTextFormField(
      enabled: false,
      controller: selectedDateController,
      focusNode: selectedDateFocusNode,
      hintText: 'Entry Date',
      keyboardType: TextInputType.text,
      validator: FormValidators().normalValidator,
      buttonType: ButtonType.FULL,
      buttonIcon: Icon(Icons.calendar_today),
      onButtonPressed: () async {
        await selectDateOfBirth();
      },
    );
  }

  Future selectDateOfBirth() async {
    DateTime selectedDate = await selectDate();
    if (selectedDate != null) {
      selectedDateController.text =
          DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
      widget.viewModel.entryDate = selectedDate;
      totalKmFocusNode.requestFocus();
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
      fieldLabelText: addDriverDobHint,
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(1950),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  Widget totalKmView({BuildContext context}) {
    return appTextFormField(
      // onEditingComplete: () => node.nextFocus(),
      enabled: true,
      formatter: [
        twoDigitDecimalPointFormatter(),
      ],
      controller: totalKmController,
      focusNode: totalKmFocusNode,

      hintText: enterTotalKmHint,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      labelText: "Total Km",
      onFieldSubmitted: (_) {
        //! below code - on done, focus goes to next textField
        fieldFocusChange(context, totalKmFocusNode, totalAmountFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else if (double.parse(value) == 0) {
          return 'cannot be 0';
        } else {
          return null;
        }
      },
    );
  }

  Widget totalPaymentView({BuildContext context}) {
    return appTextFormField(
      // onEditingComplete: () => node.nextFocus(),
      enabled: true,
      formatter: [
        twoDigitDecimalPointFormatter(),
      ],
      // formatter: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      //   LengthLimitingTextInputFormatter(7)
      // ],
      controller: totalAmountController,
      focusNode: totalAmountFocusNode,
      hintText: enterTotalAmountHint,
      keyboardType: TextInputType.number,
      labelText: "Total Amount",
      onFieldSubmitted: (_) {
        //* below code - on done, focus goes to next textField
        fieldFocusChange(context, totalAmountFocusNode, remarksFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else if (double.parse(value) == 0) {
          return 'cannot be 0';
        } else {
          return null;
        }
      },
    );
  }

  Widget getRemarksView() {
    return appTextFormField(
      // onEditingComplete: () => node.unfocus(),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 3,
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

  Widget addNewPaymentButton({AddPaymentViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      // width: double.infinity,
      child: AppButton(
        background: AppColors.primaryColorShade5,
        buttonText: 'Save',
        borderRadius: defaultBorder,
        borderColor: AppColors.primaryColorShade1,
        onTap: () {
          if (_formKey.currentState.validate()) {
            if (selectedDateController.text.length != 0) {
              viewModel.addNewPayment(
                SavePaymentRequest(
                  clientId: MyPreferences().getSelectedClient().id,
                  entryDate: getDateString(viewModel.entryDate),
                  remarks: remarksController.text,
                  amount: double.parse(totalAmountController.text),
                  kilometers: double.parse(totalKmController.text),
                ),
              );
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: "Please Select Date");
            }
          }
        },
      ),
    );
  }
}
