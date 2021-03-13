import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/screens/adddriver/add_driver_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class AddDriverView extends StatefulWidget {
  @override
  _AddDriverViewState createState() => _AddDriverViewState();
}

class _AddDriverViewState extends State<AddDriverView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddDriverViewModel>.reactive(
      builder: (context, viewModel, child) => SafeArea(
        left: false,
        right: false,
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Add Driver Details",
              style: AppTextStyles.appBarTitleStyle,
            ),
          ),
          body: AddDriverBodyWidget(
            viewModel: viewModel,
          ),
        ),
      ),
      viewModelBuilder: () => AddDriverViewModel(),
    );
  }
}

class AddDriverBodyWidget extends StatefulWidget {
  final AddDriverViewModel viewModel;

  const AddDriverBodyWidget({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _AddDriverBodyWidgetState createState() => _AddDriverBodyWidgetState();
}

class _AddDriverBodyWidgetState extends State<AddDriverBodyWidget> {
  TextEditingController vehicleIdController = TextEditingController();
  FocusNode vehicleIdFocusNode = FocusNode();

  TextEditingController fNameController = TextEditingController();
  FocusNode fNameFocusNode = FocusNode();

  TextEditingController fatherNameController = TextEditingController();
  FocusNode fatherNameFocusNode = FocusNode();

  TextEditingController mobileNumberController = TextEditingController();
  FocusNode mobileNumberFocusNode = FocusNode();

  TextEditingController alternateMobileNumberController =
      TextEditingController();
  FocusNode alternateMobileNumberFocusNode = FocusNode();

  TextEditingController whatsAppMobileNumberController =
      TextEditingController();
  FocusNode whatsAppMobileNumberFocusNode = FocusNode();

  TextEditingController workExpController = TextEditingController();
  FocusNode workExpFocusNode = FocusNode();

  TextEditingController streetController = TextEditingController();
  FocusNode streetFocusNode = FocusNode();

  TextEditingController localityController = TextEditingController();
  FocusNode localityFocusNode = FocusNode();

  TextEditingController landmarkController = TextEditingController();
  FocusNode landmarkFocusNode = FocusNode();

  TextEditingController lNameController = TextEditingController();
  FocusNode lNameFocusNode = FocusNode();

  TextEditingController dobController = TextEditingController();
  FocusNode dobFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildVehicleTextFormField(),
            buildFirstNameTextFormField(),
            buildLastNameTextFormField(),
            buildDobView(),
            AppDropDown(
              optionList: genders,
              hint: 'Select Gender',
              selectedValue: widget.viewModel.selectedGender.isEmpty
                  ? null
                  : widget.viewModel.selectedGender,
              onOptionSelect: (String selectedValue) {
                widget.viewModel.selectedGender = selectedValue;
              },
            ),
            buildMobileNumberTextFormField(),
            buildAlternateMobileNumberTextFormField(),
            buildWhatsAppMobileNumberTextFormField(),
            buildStreetTextFormField(),
            buildLocalityTextFormField(),
            buildLandmarkTextFormField(),
            hSizedBox(10),
            buildSaveBButton(),
          ],
        ),
      ),
    );
  }

  Widget buildVehicleTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
      controller: vehicleIdController,
      focusNode: vehicleIdFocusNode,
      hintText: addDriverVehicleIdHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, vehicleIdFocusNode, fNameFocusNode);
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

//RegExp(r'[a-zA-Z0-9 ]')
  //RegExp(r'[a-zA-Z0-9 , -- /]')
  Widget buildFirstNameTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      controller: fNameController,
      focusNode: fNameFocusNode,
      hintText: addDriverFirstNameHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, fNameFocusNode, lNameFocusNode);
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

  Widget buildLastNameTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      controller: lNameController,
      focusNode: lNameFocusNode,
      hintText: addDriverLastNameHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, lNameFocusNode, fatherNameFocusNode);
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

  Widget buildFatherNameTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
      ],
      controller: fatherNameController,
      focusNode: fatherNameFocusNode,
      hintText: addDriverFatherNameHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, fatherNameFocusNode, mobileNumberFocusNode);
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

  Widget buildMobileNumberTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10)
      ],
      controller: mobileNumberController,
      focusNode: mobileNumberFocusNode,
      hintText: addDriverMobileHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, mobileNumberFocusNode, alternateMobileNumberFocusNode);
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

  Widget buildAlternateMobileNumberTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10)
      ],
      controller: alternateMobileNumberController,
      focusNode: alternateMobileNumberFocusNode,
      hintText: addDriverAlternateMobileHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, alternateMobileNumberFocusNode,
            whatsAppMobileNumberFocusNode);
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

  Widget buildWhatsAppMobileNumberTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10)
      ],
      controller: whatsAppMobileNumberController,
      focusNode: whatsAppMobileNumberFocusNode,
      hintText: addDriverWhatsAppMobileHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, alternateMobileNumberFocusNode,
            whatsAppMobileNumberFocusNode);
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

  Widget buildWorkExperienceTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(2)
      ],
      controller: workExpController,
      focusNode: workExpFocusNode,
      hintText: addDriverMobileHint,
      keyboardType: TextInputType.number,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, workExpFocusNode, streetFocusNode);
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

  Widget buildStreetTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(2)
      ],
      controller: streetController,
      focusNode: streetFocusNode,
      hintText: addDriverStreetHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, streetFocusNode, localityFocusNode);
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

  Widget buildLocalityTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(2)
      ],
      controller: localityController,
      focusNode: localityFocusNode,
      hintText: addDriverLocalityHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, localityFocusNode, landmarkFocusNode);
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

  Widget buildLandmarkTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(2)
      ],
      controller: landmarkController,
      focusNode: landmarkFocusNode,
      hintText: addDriverLandmarkHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, localityFocusNode, landmarkFocusNode);
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

  Widget buildDobView() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        buildDobTextField(),
        selectDateButton(),
      ],
    );
  }

  buildDobTextField() {
    return appTextFormField(
      enabled: false,
      controller: dobController,
      focusNode: dobFocusNode,
      hintText: addDriverDobHint,
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

  selectDateButton() {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, right: 4),
        child: appSuffixIconButton(
          icon: Icon(Icons.calendar_today_outlined),
          onPressed: (() async {
            DateTime selectedDate = await selectDate();
            if (selectedDate != null) {
              dobController.text =
                  DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
              widget.viewModel.dateOfBirth = selectedDate;
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
      fieldLabelText: addDriverDobHint,
      fieldHintText: 'Month/Date/Year',
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(1990),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  Widget buildSaveBButton() {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            if (_formKey.currentState.validate()) {
              widget.viewModel.snackBarService
                  .showSnackbar(message: "Validated");
            }
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Save'),
    );
  }
}
