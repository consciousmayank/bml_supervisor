import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/screens/driver/add/add_driver_viewmodel.dart';
import 'package:bml_supervisor/screens/pickimage/pick_image_view.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
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
            title: setAppBarTitle(title: 'Add Driver Details'),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : AddDriverBodyWidget(
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
  ScrollController _controller = new ScrollController();
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

  TextEditingController houseNoBuildingNameController = TextEditingController();
  FocusNode houseNoBuildingNameFocusNode = FocusNode();

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
  final List<GlobalKey> _key = List.generate(25, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: SingleChildScrollView(
        controller: _controller,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildVehicleTextFormField(),
              buildDlTextFormField(),
              buildAadhaarTextFormField(),
              hSizedBox(2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: BottomSheetDropDown<String>(
                      bottomSheetTitle: 'Select Gender',
                      allowedValue: genders,
                      selectedValue: widget.viewModel.selectedGender.isEmpty
                          ? ''
                          : widget.viewModel.selectedGender,
                      onValueSelected: (String selectedValue, int index) {
                        widget.viewModel.selectedGender = selectedValue;
                      },
                      hintText: 'Select Gender',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: BottomSheetDropDown<String>(
                      bottomSheetTitle: 'Select Blood Group',
                      allowedValue: bloodGroup,
                      selectedValue: widget.viewModel.selectedBloodGroup.isEmpty
                          ? ''
                          : widget.viewModel.selectedBloodGroup,
                      onValueSelected: (String selectedValue, int index) {
                        widget.viewModel.selectedBloodGroup = selectedValue;
                        fNameFocusNode.requestFocus();
                      },
                      hintText: 'Select Blood Group',
                    ),
                  ),
                ],
              ),
              buildFirstNameTextFormField(),
              buildLastNameTextFormField(),
              buildDobView(),
              buildFatherNameTextFormField(),
              buildMobileNumberTextFormField(),
              buildAlternateMobileNumberTextFormField(),
              buildWhatsAppMobileNumberTextFormField(),
              buildWorkExperienceTextFormField(),
              buildHnoBuildingNameTextFormField(),
              buildStreetTextFormField(),
              buildLocalityTextFormField(),
              buildLandmarkTextFormField(),
              buildAddressSelector(key: _key[18]),
              widget.viewModel.cityList.length > 0
                  ? buildCityTextFormField(viewModel: widget.viewModel)
                  : Container(),
              buildPinCodeTextFormField(),
              buildStateTextFormField(),
              buildCountryTextFormField(),
              buildRemarksTextFormField(),
              hSizedBox(10),
              SizedBox(
                height: 250,
                width: 200,
                child: PickImageView(
                  enableGalleryUpload: true,
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
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphaNumericFormatter,
      ],
      controller: vehicleIdController,
      focusNode: vehicleIdFocusNode,
      hintText: addDriverVehicleIdHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, vehicleIdFocusNode, drivingLicenseFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildDlTextFormField() {
    return appTextFormField(
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphaNumericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 16),
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
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildAadhaarTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().numericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 12),
      ],
      controller: aadhaarController,
      focusNode: aadhaarFocusNode,
      hintText: addDriverAadhaarHint,
      keyboardType: TextInputType.number,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, aadhaarFocusNode, fNameFocusNode);
      },
      validator: FormValidators().aadhaarCardNumberValidator,
    );
  }

//RegExp(r'[a-zA-Z0-9 ]')
  //RegExp(r'[a-zA-Z0-9 , -- /]')
  Widget buildFirstNameTextFormField() {
    return appTextFormField(
      textCapitalization: TextCapitalization.words,
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphabeticFormatter,
      ],
      controller: fNameController,
      focusNode: fNameFocusNode,
      hintText: addDriverFirstNameHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, fNameFocusNode, lNameFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildLastNameTextFormField() {
    return appTextFormField(
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphabeticFormatter,
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
      // validator: FormValidators().normalValidator
    );
  }

  Widget buildFatherNameTextFormField() {
    return appTextFormField(
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphabeticFormatter,
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
        TextFieldInputFormatter().numericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 10)
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
      validator: FormValidators().mobileNumberValidator,
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
        TextFieldInputFormatter().numericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 10)
      ],
      validator: widget.viewModel.alternatePhNo.length != 0
          ? FormValidators().mobileNumberValidator
          : null,
      controller: alternateMobileNumberController,
      focusNode: alternateMobileNumberFocusNode,
      hintText: addDriverAlternateMobileHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {
        widget.viewModel.alternatePhNo = value;
      },
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
        TextFieldInputFormatter().numericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 10)
      ],
      controller: whatsAppMobileNumberController,
      focusNode: whatsAppMobileNumberFocusNode,
      hintText: addDriverWhatsAppMobileHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {
        widget.viewModel.whatsAppNo = value;
      },
      validator: widget.viewModel.whatsAppNo.length != 0
          ? FormValidators().mobileNumberValidator
          : null,
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
        TextFieldInputFormatter().numericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 2)
      ],
      controller: workExpController,
      focusNode: workExpFocusNode,
      hintText: addDriverExperienceHint,
      keyboardType: TextInputType.number,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, workExpFocusNode, houseNoBuildingNameFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildHnoBuildingNameTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: houseNoBuildingNameController,
      focusNode: houseNoBuildingNameFocusNode,
      hintText: addDriverHnoBuildingNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, houseNoBuildingNameFocusNode, streetFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildStreetTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: streetController,
      focusNode: streetFocusNode,
      hintText: addDriverStreetHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, streetFocusNode, localityFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildLocalityTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: localityController,
      focusNode: localityFocusNode,
      hintText: addDriverLocalityHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, localityFocusNode, landmarkFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildLandmarkTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
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
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildAddressSelector({GlobalKey<State<StatefulWidget>> key}) {
    return BottomSheetDropDown<String>(
      key: key,
      allowedValue: addressTypes,
      selectedValue: widget.viewModel.selectedAddressTypes,
      hintText: 'Address Type',
      bottomSheetTitle: 'Address Type',
      onValueSelected: (
        String selectedAddressType,
        int index,
      ) {
        widget.viewModel.selectedAddressTypes = selectedAddressType;
        widget.viewModel.notifyListeners();
      },
    );
  }

  Widget buildPinCodeTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().numericFormatter,
        TextFieldInputFormatter().maxLengthFormatter(maxLength: 6)
      ],
      controller: widget.viewModel.pinCodeController,
      focusNode: widget.viewModel.pinCodeFocusNode,
      hintText: "PinCode",
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.pinCodeFocusNode.unfocus();
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildStateTextFormField() {
    return appTextFormField(
      enabled: false,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphaNumericFormatter,
      ],
      controller: widget.viewModel.stateController,
      focusNode: widget.viewModel.stateFocusNode,
      hintText: addDriverStateHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.pinCodeFocusNode.unfocus();
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildCountryTextFormField() {
    return appTextFormField(
      enabled: false,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphaNumericFormatter,
      ],
      controller: widget.viewModel.countryController,
      focusNode: widget.viewModel.countryFocusNode,
      hintText: addDriverCountryHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        widget.viewModel.countryFocusNode.unfocus();
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildRemarksTextFormField() {
    return appTextFormField(
      inputDecoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 16, top: 8, bottom: 4, right: 16),
        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),
      maxLines: 5,
      enabled: true,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter().alphaNumericFormatter,
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
    return appTextFormField(
      enabled: false,
      controller: dobController,
      focusNode: dobFocusNode,
      hintText: addDriverDobHint,
      keyboardType: TextInputType.text,
      validator: FormValidators().normalValidator,
      buttonType: ButtonType.FULL,
      buttonIcon: Icon(Icons.calendar_today),
      onButtonPressed: () async {
        await selectDateOfBirth();
      },
    );

    // Stack(
    //   alignment: Alignment.bottomRight,
    //   children: [
    //     buildDobTextField(),
    //     selectDateButton(),
    //   ],
    // );
  }

  buildDobTextField() {
    return appTextFormField(
      enabled: false,
      controller: dobController,
      focusNode: dobFocusNode,
      hintText: addDriverDobHint,
      keyboardType: TextInputType.text,
      validator: FormValidators().normalValidator,
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
      firstDate: new DateTime(1950),
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
            hideKeyboard(context: context);
            if (_formKey.currentState.validate() &&
                checkOtherFields(scrollController: _controller)) {
              widget.viewModel.addDriver(
                  newDriverObject: AddDriverRequest(
                      bloodGroup: widget.viewModel.selectedBloodGroup,
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
                      type: widget.viewModel.selectedAddressTypes,
                      addressLine1: houseNoBuildingNameController.text,
                      addressLine2: streetController.text,
                      locality: localityController.text,
                      nearby: landmarkController.text,
                      city: widget.viewModel.selectedCity.city,
                      state: widget.viewModel.stateController.text,
                      country: widget.viewModel.countryController.text,
                      pincode: widget.viewModel.pinCodeController.text,
                    )
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

  bool checkOtherFields({@required ScrollController scrollController}) {
    bool isValidated = true;

    if (widget.viewModel.selectedAddressTypes.length == 0) {
      widget.viewModel.snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(seconds: 4),
        message: 'Please select an Address Type',
        mainButtonTitle: 'Ok',
        onMainButtonTapped: () {
          Scrollable.ensureVisible(_key[18].currentContext);
          widget.viewModel.openAddressSelectorBottomSheet();
        },
      );

      isValidated = false;
    }

    return isValidated;
  }
}
