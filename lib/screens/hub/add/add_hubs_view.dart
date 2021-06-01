import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/hub/add/add_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class AddHubsView extends StatefulWidget {
  final List<HubResponse> hubsList;

  AddHubsView({@required this.hubsList});

  @override
  _AddHubsViewState createState() => _AddHubsViewState();
}

class _AddHubsViewState extends State<AddHubsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddHubsViewModel>.reactive(
        onModelReady: (viewModel) {
          // viewModel.getClients();
          viewModel.getCities();
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: setAppBarTitle(title: 'Add Hub'),
                centerTitle: true,
              ),
              body: viewModel.isBusy
                  ? ShimmerContainer(
                      itemCount: 10,
                    )
                  : AddHubBodyWidget(
                      viewModel: viewModel,
                      hubsList: widget.hubsList,
                    ),
            ),
        viewModelBuilder: () => AddHubsViewModel());
  }
}

class AddHubBodyWidget extends StatefulWidget {
  final AddHubsViewModel viewModel;
  final List<HubResponse> hubsList;

  const AddHubBodyWidget(
      {Key key, @required this.viewModel, @required this.hubsList})
      : super(key: key);

  @override
  _AddHubBodyWidgetState createState() => _AddHubBodyWidgetState();
}

class _AddHubBodyWidgetState extends State<AddHubBodyWidget> {
  TextEditingController hubTitleController = TextEditingController();
  FocusNode hubTitleFocusNode = FocusNode();

  TextEditingController doRController = TextEditingController();
  FocusNode doRFocusNode = FocusNode();

  TextEditingController contactPersonController = TextEditingController();
  FocusNode contactPersonFocusNode = FocusNode();

  TextEditingController contactNumberController = TextEditingController();

  FocusNode contactNumberFocusNode = FocusNode();

  TextEditingController alternateMobileNumberController =
      TextEditingController();
  FocusNode alternateMobileNumberFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  TextEditingController streetController = TextEditingController();
  FocusNode streetFocusNode = FocusNode();

  TextEditingController houseNoBuildingNameController = TextEditingController();
  FocusNode houseNoBuildingNameFocusNode = FocusNode();

  TextEditingController localityController = TextEditingController();
  FocusNode localityFocusNode = FocusNode();

  TextEditingController landmarkController = TextEditingController();
  FocusNode landmarkFocusNode = FocusNode();

  TextEditingController latitudeController = TextEditingController();
  FocusNode latitudeFocusNode = FocusNode();

  TextEditingController longitudeController = TextEditingController();
  FocusNode longitudeFocusNode = FocusNode();

  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<GlobalKey> _key = List.generate(25, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildHubTitleTextFormField(viewModel: widget.viewModel),
                hubTitleController.text.trim().length > 0 &&
                        (widget.viewModel.existingHubsList.length > 0)
                    ? BottomSheetDropDown<HubResponse>(
                        supportText: hubTitleController.text.trim(),
                        bottomSheetDropDownType:
                            BottomSheetDropDownType.EXISTING_HUB_TITLE_LIST,
                        key: _key[19],
                        allowedValue: widget.viewModel.existingHubsList,
                        selectedValue: widget.viewModel.existingHubsList.isEmpty
                            ? null
                            : widget.viewModel.selectedExistingHubTitle,
                        hintText: 'Existing Hub(s)',
                        onValueSelected: (
                          String selectedAddressType,
                          int index,
                        ) {
                          widget.viewModel.existingHubsList.clear();
                          hubTitleController.text = '';
                        },
                      )
                    : Container(),
                // Card(
                //   child: Column(
                //     children: [
                //       ...fun2(widget.viewModel, context),
                //     ],
                //   ),
                // ),

                // buildNewHubTitleTextFormField(),
                buildDateOfRegistrationView(),

                buildContactPersonView(),
                buildContactNumberTextFormField(),
                buildAlternateMobileNumberTextFormField(
                    viewModel: widget.viewModel),
                buildEmailTextFormField(),
                buildHnoBuildingNameTextFormField(),
                buildStreetTextFormField(),
                buildLocalityTextFormField(),
                buildLandmarkTextFormField(),
                widget.viewModel.cityList.length > 0
                    ? buildCityTextFormField(viewModel: widget.viewModel)
                    : Container(),
                buildStateTextFormField(),
                buildCountryTextFormField(),
                buildPinCodeTextFormField(),
                buildLatitudeTextFormField(),
                buildLongitudeTextFormField(),
                buildRemarksTextFormField(),
                buildSaveButton(),
              ],
            )),
      ),
    );
  }

  List<Widget> fun2(AddHubsViewModel viewModel, BuildContext context) {
    return List.generate(widget.viewModel.existingHubsList.length, (index) {
      return InkWell(
        onTap: () {
          widget.viewModel.existingHubsList = [];
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.viewModel.existingHubsList[index].title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            hSizedBox(5),
            widget.viewModel.existingHubsList.length > 1
                ? index + 1 == widget.viewModel.existingHubsList.length
                    ? Container()
                    : DottedDivider()
                : Container(),
          ],
        ),
      );
    }).toList();
  }

  Widget selectClientForDashboardStats({AddHubsViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClient = selectedValue;
        // viewModel.getDistributors(selectedClient: selectedValue);
      },
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }

  Widget buildSaveButton() {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            if (_formKey.currentState.validate()) {
              if (hubTitleController.text.length >= 8) {
                if (contactNumberController.text.length >= 10) {
                  widget.viewModel.addHub(
                      newHubObject: AddHubRequest(
                    addressLine: houseNoBuildingNameController.text,
                    clientId: MyPreferences()?.getSelectedClient()?.clientId,
                    title: hubTitleController.text.trim(),
                    contactPerson: contactPersonController.text.trim(),
                    email: emailController.text.trim(),
                    geoLatitude: latitudeController.text.length > 0
                        ? double.parse(latitudeController.text.trim())
                        : 0,
                    geoLongitude: longitudeController.text.length > 0
                        ? double.parse(longitudeController.text.trim())
                        : 0,
                    landmark: landmarkController.text.trim(),
                    remarks: remarkController.text.trim(),
                    city: widget.viewModel.selectedCity.city,
                    state: widget.viewModel.stateController.text,
                    country: widget.viewModel.countryController.text,
                    pincode: widget.viewModel.pinCodeController.text,
                    locality: localityController.text.trim(),
                    mobile: contactNumberController.text.trim(),
                    phone: widget.viewModel.alternateMobileNumber.trim(),
                    registrationDate: doRController.text,
                    street: streetController.text.trim(),
                  ));
                } else {
                  widget.viewModel.snackBarService.showSnackbar(
                      message: 'Please enter correct mobile number');
                }
              } else {
                widget.viewModel.snackBarService.showSnackbar(
                    message: 'Hub Title Length should be greater than 7');
              }
            }
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Save'),
    );
  }

  Widget buildHubTitleTextFormField({AddHubsViewModel viewModel}) {
    return appTextFormField(
      enabled: true,
      controller: hubTitleController,
      focusNode: hubTitleFocusNode,
      hintText: addHubsHubNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {
        if (value.length > 3) {
          viewModel.checkForExistingHubTitleContainsApi(value.trim());
        }
      },
      onFieldSubmitted: (_) {
        hubTitleFocusNode.unfocus();
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildDateOfRegistrationView() {
    return buildDateOfRegistrationTextField();
  }

  buildDateOfRegistrationTextField() {
    return appTextFormField(
      enabled: false,
      controller: doRController,
      focusNode: doRFocusNode,
      hintText: addHubsDateOfRegistrationHint,
      keyboardType: TextInputType.text,
      validator: FormValidators().normalValidator,
      buttonType: ButtonType.FULL,
      buttonIcon: Icon(Icons.calendar_today_outlined),
      onButtonPressed: (() async {
        await selectDateOfRegistration();
      }),
    );
  }

  Future selectDateOfRegistration() async {
    DateTime selectedDate = await selectDate();
    if (selectedDate != null) {
      doRController.text =
          DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
      widget.viewModel.dateOfRegistration = selectedDate;

      /// give focus to next view
      contactPersonFocusNode.requestFocus();
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

  Widget buildContactPersonView() {
    return appTextFormField(
      enabled: true,
      controller: contactPersonController,
      focusNode: contactPersonFocusNode,
      hintText: addHubsContactPersonHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, contactPersonFocusNode, contactNumberFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildContactNumberTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10)
      ],
      controller: contactNumberController,
      focusNode: contactNumberFocusNode,
      hintText: addHubsContactNumberHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, contactNumberFocusNode, alternateMobileNumberFocusNode);
      },
      validator: FormValidators().mobileNumberValidator,
    );
  }

  Widget buildAlternateMobileNumberTextFormField(
      {@required AddHubsViewModel viewModel}) {
    return appTextFormField(
      inputDecoration: InputDecoration(
        suffix: IconButton(
          icon: Icon(
            Icons.copy,
            size: 16,
          ),
          onPressed: () {
            alternateMobileNumberController.text = contactNumberController.text;
            alternateMobileNumberController.selection =
                TextSelection.fromPosition(TextPosition(
                    offset: alternateMobileNumberController.text.length));
            widget.viewModel.alternateMobileNumber =
                contactNumberController.text;
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
      hintText: addHubsAlternateMobileNumberHint,
      keyboardType: TextInputType.phone,
      validator: widget.viewModel.alternateMobileNumber.length != 0
          ? FormValidators().mobileNumberNotRequiredValidator
          : null,
      onTextChange: (String value) {
        widget.viewModel.alternateMobileNumber = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, alternateMobileNumberFocusNode, emailFocusNode);
      },
    );
  }

  Widget buildEmailTextFormField() {
    return appTextFormField(
      enabled: true,
      textCapitalization: TextCapitalization.words,
      validator: FormValidators().emailValidator,
      controller: emailController,
      focusNode: emailFocusNode,
      hintText: addHubsEmailHint,
      keyboardType: TextInputType.emailAddress,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, emailFocusNode, houseNoBuildingNameFocusNode);
      },
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
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: streetController,
      focusNode: streetFocusNode,
      hintText: addDriverStreetHint,
      keyboardType: TextInputType.name,
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
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: localityController,
      focusNode: localityFocusNode,
      hintText: addDriverLocalityHint,
      keyboardType: TextInputType.name,
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
      validator: FormValidators().normalValidator,
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, landmarkFocusNode, widget.viewModel.cityFocusNode);
      },
    );
  }

  buildNewHubTitleTextFormField({AddHubsViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        /// call api here

        if (viewModel.existingHubsList.length == 0) {
          return viewModel
              .getHubTitleListForAutoComplete()
              .where((String option) {
            return option.contains(textEditingValue.text.toUpperCase());
          }).toList();
        }
        return null;
      },
      onSelected: (String selection) {
        // CitiesResponse temp;
        // viewModel.cityList.forEach((element) {
        //   if (element.city == selection) {
        //     temp = element;
        //   }
        // });
        // viewModel.selectedCity = temp;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return appTextFormField(
          onTextChange: (String value) {
            /// call check title api here
            if (textEditingController.text.trim().length > 3) {
              viewModel.checkForExistingHubTitleContainsApi(
                  textEditingController.text.trim());
            }
          },
          hintText: "New Hub title",
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (String value) {
            // if (!widget.viewModel
            //     .getCitiesListForAutoComplete()
            //     .contains(value)) {
            //   return 'Nothing selected.';
            // }
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

  buildCityTextFormField({AddHubsViewModel viewModel}) {
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
        fieldFocusChange(
            context, widget.viewModel.pinCodeFocusNode, latitudeFocusNode);
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

  Widget buildLatitudeTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(
            r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$')),
        // LengthLimitingTextInputFormatter(6)
      ],
      controller: latitudeController,
      focusNode: latitudeFocusNode,
      hintText: "Latitude",
      keyboardType: TextInputType.number,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, latitudeFocusNode, longitudeFocusNode);
      },
    );
  }

  Widget buildLongitudeTextFormField() {
    return appTextFormField(
      enabled: true,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(
            r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$')),
        // LengthLimitingTextInputFormatter(6)
      ],
      controller: longitudeController,
      focusNode: longitudeFocusNode,
      hintText: "Longitude",
      keyboardType: TextInputType.number,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, longitudeFocusNode, remarkFocusNode);
      },
    );
  }

  Widget buildRemarksTextFormField() {
    return appTextFormField(
      maxLines: 3,
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      ],
      controller: remarkController,
      focusNode: remarkFocusNode,
      hintText: addDriverRemarksHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        remarkFocusNode.unfocus();
      },
    );
  }
}
