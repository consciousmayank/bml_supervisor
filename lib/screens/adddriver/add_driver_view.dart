import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/screens/adddriver/add_driver_viewmodel.dart';
import 'package:bml_supervisor/screens/pickimage/pick_image_view.dart';
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
      onModelReady: (viewModel) => viewModel.getCities(),
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

  TextEditingController drivingLicenseController = TextEditingController();
  FocusNode drivingLicenseFocusNode = FocusNode();

  TextEditingController aadhaarController = TextEditingController();
  FocusNode aadhaarFocusNode = FocusNode();

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

  TextEditingController remarksController = TextEditingController();
  FocusNode remarksFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildVehicleTextFormField(),
              buildDlTextFormField(),
              buildAadhaarTextFormField(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: AppDropDown(
                      optionList: genders,
                      hint: 'Select Gender',
                      selectedValue: widget.viewModel.selectedGender.isEmpty
                          ? null
                          : widget.viewModel.selectedGender,
                      onOptionSelect: (String selectedValue) {
                        widget.viewModel.selectedGender = selectedValue;
                        fNameFocusNode.requestFocus();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: buildFirstNameTextFormField(),
                  ),
                ],
              ),
              buildLastNameTextFormField(),
              buildDobView(),
              buildFatherNameTextFormField(),
              buildMobileNumberTextFormField(),
              buildAlternateMobileNumberTextFormField(),
              buildWhatsAppMobileNumberTextFormField(),
              buildWorkExperienceTextFormField(),
              widget.viewModel.cityList.length > 0
                  ? buildCityTextFormField(viewModel: widget.viewModel)
                  : Container(),
              buildStreetTextFormField(),
              buildLocalityTextFormField(),
              buildLandmarkTextFormField(),
              buildPinCodeTextFormField(),
              buildStateTextFormField(),
              buildCountryTextFormField(),
              buildRemarksTextFormField(),
              hSizedBox(10),
              SizedBox(
                height: 250,
                width: 200,
                child: PickImageView(
                  onImageSelected: (String base64String) {
                    widget.viewModel.imageBase64String = base64String;
                  },
                ),
              ),
              hSizedBox(10),
              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVehicleTextFormField() {
    return appTextFormField(
      enabled: true,
      controller: vehicleIdController,
      focusNode: vehicleIdFocusNode,
      hintText: addDriverVehicleIdHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, vehicleIdFocusNode, drivingLicenseFocusNode);
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

  Widget buildDlTextFormField() {
    return appTextFormField(
      formatter: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(16),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      ],
      enabled: true,
      controller: drivingLicenseController,
      focusNode: drivingLicenseFocusNode,
      hintText: addDriverDlHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, drivingLicenseFocusNode, aadhaarFocusNode);
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

  Widget buildAadhaarTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[LengthLimitingTextInputFormatter(16)],
      controller: aadhaarController,
      focusNode: aadhaarFocusNode,
      hintText: addDriverAadhaarHint,
      keyboardType: TextInputType.number,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, aadhaarFocusNode, fNameFocusNode);
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
      textCapitalization: TextCapitalization.words,
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
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      controller: lNameController,
      focusNode: lNameFocusNode,
      hintText: addDriverLastNameHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) async {
        await selectDateOfBirth();
        // fieldFocusChange(context, lNameFocusNode, fatherNameFocusNode);
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
      textCapitalization: TextCapitalization.words,
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
      inputDecoration: InputDecoration(
        suffix: IconButton(
          icon: Icon(
            Icons.copy,
            size: 16,
          ),
          onPressed: () {
            alternateMobileNumberController.text = mobileNumberController.text;
            alternateMobileNumberController.selection =
                TextSelection.fromPosition(TextPosition(
                    offset: alternateMobileNumberController.text.length));
          },
        ),
      ),
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
    );
  }

  Widget buildWhatsAppMobileNumberTextFormField() {
    return appTextFormField(
      inputDecoration: InputDecoration(
        suffix: IconButton(
          icon: Icon(
            Icons.copy,
            size: 16,
          ),
          onPressed: () {
            whatsAppMobileNumberController.text = mobileNumberController.text;
            alternateMobileNumberController.selection =
                TextSelection.fromPosition(TextPosition(
                    offset: alternateMobileNumberController.text.length));
          },
        ),
      ),
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
        fieldFocusChange(context, whatsAppMobileNumberFocusNode,
            widget.viewModel.cityFocusNode);
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
      hintText: addDriverExperienceHint,
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
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
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
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
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
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
      ],
      controller: landmarkController,
      focusNode: landmarkFocusNode,
      hintText: addDriverLandmarkHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, landmarkFocusNode, widget.viewModel.pinCodeFocusNode);
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

  Widget buildPinCodeTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(6)
      ],
      controller: widget.viewModel.pinCodeController,
      focusNode: widget.viewModel.pinCodeFocusNode,
      hintText: "PinCode",
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.pinCodeFocusNode.unfocus();
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

  Widget buildStateTextFormField() {
    return appTextFormField(
      enabled: false,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        // LengthLimitingTextInputFormatter(6)
      ],
      controller: widget.viewModel.stateController,
      focusNode: widget.viewModel.stateFocusNode,
      hintText: addDriverStateHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.pinCodeFocusNode.unfocus();
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

  Widget buildCountryTextFormField() {
    return appTextFormField(
      enabled: false,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        // LengthLimitingTextInputFormatter(6)
      ],
      controller: widget.viewModel.countryController,
      focusNode: widget.viewModel.countryFocusNode,
      hintText: addDriverCountryHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.countryFocusNode.unfocus();
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

  Widget buildRemarksTextFormField() {
    return appTextFormField(
      inputDecoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),
      maxLines: 5,
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        // LengthLimitingTextInputFormatter(6)
      ],
      controller: remarksController,
      focusNode: remarksFocusNode,
      hintText: addDriverRemarksHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.countryFocusNode.unfocus();
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
            await selectDateOfBirth();
          }),
        ),
      ),
    );
  }

  Future selectDateOfBirth() async {
    DateTime selectedDate = await selectDate();
    if (selectedDate != null) {
      dobController.text =
          DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
      widget.viewModel.dateOfBirth = selectedDate;
      fatherNameFocusNode.requestFocus();
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
      firstDate: new DateTime(1990),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  Widget buildSaveButton() {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            if (_formKey.currentState.validate()) {
              widget.viewModel.addDriver(
                  newDriverObject: AddDriverRequest(
                      salutation: widget.viewModel.getSalutation(),
                      firstName: fNameController.text,
                      lastName: lNameController.text,
                      dob: dobController.text,
                      dateOfJoin: getDateString(DateTime.now()),
                      gender: widget.viewModel.selectedGender,
                      fatherName: fatherNameController.text,
                      mobile: mobileNumberController.text,
                      mobileAlternate: alternateMobileNumberController.text,
                      mobileWhatsApp: whatsAppMobileNumberController.text,
                      drivingLicense: drivingLicenseController.text,
                      aadhaar: aadhaarController.text,
                      photo: widget.viewModel.imageBase64String ?? null,
                      workExperienceYr: int.parse(workExpController.text),
                      remarks: remarksController.text,
                      vehicleId: vehicleIdController.text,
                      address: [
                    Address(
                        type: 'RESIDENTIAL',
                        addressLine1: streetController.text,
                        addressLine2: 'NA',
                        locality: localityController.text,
                        nearby: landmarkController.text,
                        city: widget.viewModel.selectedCity.city,
                        state: widget.viewModel.stateController.text,
                        country: widget.viewModel.countryController.text,
                        pincode: widget.viewModel.pinCodeController.text)
                  ]));
            }
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Save'),
    );
  }

  buildCityTextFormField({AddDriverViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel.getCitiesListForAutoComplete().where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        }).toList();
      },
      onSelected: (String selection) {
        CitiesResponse temp;
        viewModel.cityList.forEach((element) {
          if (element.city == selection) {
            temp = element;
          }
        });
        viewModel.selectedCity = temp;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return appTextFormField(
          hintText: "City",
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (String value) {
            if (!widget.viewModel
                .getCitiesListForAutoComplete()
                .contains(value)) {
              return 'Nothing selected.';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: options
                    .map((String option) => GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
