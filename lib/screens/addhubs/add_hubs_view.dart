import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/screens/addhubs/add_hubs_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../app_level/colors.dart';
import '../../app_level/themes.dart';
import '../../models/cities_response.dart';
import '../../models/secured_get_clients_response.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/dimens.dart';
import '../../utils/stringutils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/app_button.dart';
import '../../widget/app_suffix_icon_button.dart';
import '../../widget/app_textfield.dart';
import '../../widget/client_dropdown.dart';

class AddHubsView extends StatefulWidget {
  @override
  _AddHubsViewState createState() => _AddHubsViewState();
}

class _AddHubsViewState extends State<AddHubsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddHubsViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClients();
          viewModel.getCities();
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Add Hubs',
                  style: AppTextStyles.appBarTitleStyle,
                ),
                centerTitle: true,
              ),
              body: AddHubBodyWidget(
                viewModel: viewModel,
              ),
            ),
        viewModelBuilder: () => AddHubsViewModel());
  }
}

class AddHubBodyWidget extends StatefulWidget {
  final AddHubsViewModel viewModel;

  const AddHubBodyWidget({Key key, @required this.viewModel}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                selectClientForDashboardStats(viewModel: widget.viewModel),
                buildHubTitleTextFormField(),
                buildDateOfRegistrationView(),
                buildContactPersonView(),
                buildContactNumberTextFormField(),
                buildAlternateMobileNumberTextFormField(),
                buildEmailTextFormField(),
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
                    clientId: widget.viewModel.selectedClient.clientId,
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
                    phone: alternateMobileNumberController.text.trim(),
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

  Widget buildHubTitleTextFormField() {
    return appTextFormField(
      enabled: true,
      controller: hubTitleController,
      focusNode: hubTitleFocusNode,
      hintText: addHubsHubNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        hubTitleFocusNode.unfocus();
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

  Widget buildDateOfRegistrationView() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        buildDateOfRegistrationTextField(),
        selectDateButton(),
      ],
    );
  }

  buildDateOfRegistrationTextField() {
    return appTextFormField(
      enabled: false,
      controller: doRController,
      focusNode: doRFocusNode,
      hintText: addHubsDateOfRegistrationHint,
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
            await selectDateOfRegistration();
          }),
        ),
      ),
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
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
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
            alternateMobileNumberController.text = contactNumberController.text;
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
      hintText: addHubsAlternateMobileNumberHint,
      keyboardType: TextInputType.phone,
      onTextChange: (String value) {},
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
      //todo: regex for email verification
      // formatter: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      // ],
      controller: emailController,
      focusNode: emailFocusNode,
      hintText: addHubsEmailHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, emailFocusNode, streetFocusNode);
      },
    );
  }

  Widget buildStreetTextFormField() {
    return appTextFormField(
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      ],
      controller: streetController,
      focusNode: streetFocusNode,
      hintText: addDriverStreetHint,
      keyboardType: TextInputType.name,
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
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      ],
      controller: localityController,
      focusNode: localityFocusNode,
      hintText: addDriverLocalityHint,
      keyboardType: TextInputType.name,
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
            context, landmarkFocusNode, widget.viewModel.cityFocusNode);
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
      keyboardType: TextInputType.text,
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
      keyboardType: TextInputType.text,
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
