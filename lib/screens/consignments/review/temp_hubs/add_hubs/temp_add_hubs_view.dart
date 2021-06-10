import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/add_hubs/temp_add_hubs_viewmodel.dart';
import 'package:bml_supervisor/screens/hub/add/add_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class TempAddHubsView extends StatefulWidget {
  final TempAddHubsViewArguments arguments;
  const TempAddHubsView({
    Key key,
    @required this.arguments,
  }) : super(key: key);
  @override
  _TempAddHubsViewState createState() => _TempAddHubsViewState();
}

class _TempAddHubsViewState extends State<TempAddHubsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TempAddHubsViewModel>.reactive(
      onModelReady: (model) => model.getCities(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.navigationService.back(result: null);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Hubs',
                style: AppTextStyles().appBarTitleStyleNew,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    model.navigationService.back(
                      result: copyList(
                        model.hubsList,
                      ),
                    );
                  },
                  icon: Icon(Icons.done),
                )
              ],
            ),
            body: model.isBusy
                ? ShimmerContainer(
                    itemCount: 20,
                  )
                : AddHubBodyWidget(
                    reviewedConsigId: widget.arguments.reviewedConsigId,
                    viewModel: model,
                    hubsList: model.hubsList,
                  ),
          ),
          top: true,
          bottom: true,
        ),
      ),
      viewModelBuilder: () => TempAddHubsViewModel(),
    );
  }
}

class AddHubBodyWidget extends StatefulWidget {
  final TempAddHubsViewModel viewModel;
  final List<SingleTempHub> hubsList;
  final int reviewedConsigId;
  const AddHubBodyWidget(
      {Key key,
      @required this.viewModel,
      @required this.hubsList,
      @required this.reviewedConsigId})
      : super(key: key);

  @override
  _AddHubBodyWidgetState createState() => _AddHubBodyWidgetState();
}

class _AddHubBodyWidgetState extends State<AddHubBodyWidget> {
  // TextEditingController hubTitleController = TextEditingController();
  FocusNode hubTitleFocusNode = FocusNode();

  TextEditingController doRController = TextEditingController();
  FocusNode doRFocusNode = FocusNode();

  TextEditingController contactPersonController = TextEditingController();
  FocusNode contactPersonFocusNode = FocusNode();

  TextEditingController itemsCollectController = TextEditingController();
  FocusNode itemsCollectFocusNode = FocusNode();

  TextEditingController itemsDropController = TextEditingController();
  FocusNode itemsDropFocusNode = FocusNode();

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

  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();

  TextEditingController latitudeController = TextEditingController();
  FocusNode latitudeFocusNode = FocusNode();

  TextEditingController longitudeController = TextEditingController();
  FocusNode longitudeFocusNode = FocusNode();

  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocusNode = FocusNode();

  final List<GlobalKey> _key = List.generate(25, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHubTitleTextFormField(viewModel: widget.viewModel),
            widget.viewModel.hubsList.length > 0
                ? widget.viewModel.enteredHub.title.trim().length > 0
                    ? buildExistingHubBottomSheetDropDown()
                    : Container()
                : Container(),
            AppDropDown(
              showUnderLine: true,
              selectedValue: widget.viewModel.enteredHub.itemUnit != null
                  ? widget.viewModel.enteredHub.itemUnit
                  : null,
              hint: "Item Unit",
              onOptionSelect: (selectedValue) {
                widget.viewModel.enteredHub = widget.viewModel.enteredHub
                    .copyWith(itemUnit: selectedValue);
                widget.viewModel.notifyListeners();
                contactPersonFocusNode.requestFocus();
              },
              optionList: selectItemUnit,
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: child,
                    flex: 1,
                  ),
                  wSizedBox(10),
                  Expanded(
                    child: child,
                    flex: 1,
                  ),
                ],
              ),
            ),
            buildContactPersonView(),
            buildContactNumberTextFormField(),
            buildAddressSelector(),
            buildHnoBuildingNameTextFormField(),
            buildStreetTextFormField(),
            buildLocalityTextFormField(),
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
        ),
      ),
    );
  }

  BottomSheetDropDown<SingleTempHub> buildExistingHubBottomSheetDropDown() {
    return BottomSheetDropDown<SingleTempHub>(
      bottomSheetTitle: 'Existing Hub(s)',
      supportText: widget.viewModel.enteredHub.title,
      bottomSheetDropDownType: BottomSheetDropDownType.EXISTING_TEMP_HUBS_LIST,
      key: _key[19],
      allowedValue: widget.viewModel.hubsList,
      selectedValue: widget.viewModel.hubsList.isEmpty
          ? null
          : widget.viewModel.enteredHub,
      hintText: 'Existing Hub(s)',
      onValueSelected: (
        SingleTempHub selectedValue,
        int selectedIndex,
      ) {
        widget.viewModel.enteredHub = widget.viewModel.enteredHub.copyWith(
          title: selectedValue.title,
          consignmentId: widget.reviewedConsigId,
          itemUnit: null,
          dropOff: -1,
          collect: -1,
          contactPerson: selectedValue.contactPerson,
          mobile: selectedValue.mobile,
          addressType: selectedValue.addressType,
          addressLine1: selectedValue.addressLine1,
          addressLine2: selectedValue.addressLine2,
          locality: selectedValue.locality,
          nearby: selectedValue.nearby,
          city: selectedValue.city,
          state: selectedValue.state,
          country: selectedValue.country,
          pincode: selectedValue.pincode,
          geoLatitude: selectedValue.geoLatitude,
          geoLongitude: selectedValue.geoLongitude,
          remarks: selectedValue.remarks,
        );

        widget.viewModel.notifyListeners();
      },
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
            // if (_formKey.currentState.validate()) {
            //   if (hubTitleController.text.length >= 8) {
            //     if (contactNumberController.text.length >= 10) {
            //       ///Change this

            //     } else {
            //       widget.viewModel.snackBarService.showSnackbar(
            //           message: 'Please enter correct mobile number');
            //     }
            //   } else {
            //     widget.viewModel.snackBarService.showSnackbar(
            //         message: 'Hub Title Length should be greater than 7');
            //   }
            // }

            widget.viewModel.addToReturningHubsList(
              newHubObject: SingleTempHub.empty().copyWith(
                  consignmentId: widget.reviewedConsigId,
                  dropOff: 0,
                  collect: 0,
                  title: '',
                  contactPerson: contactPersonController.text,
                  mobile: contactNumberController.text,
                  addressType: '',
                  addressLine1: '',
                  addressLine2: '',
                  locality: '',
                  nearby: '',
                  city: '',
                  state: '',
                  country: '',
                  pincode: '',
                  geoLatitude: 0,
                  geoLongitude: 0,
                  remarks: ''),
            );
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Save'),
    );
  }

  Widget buildItemsCollectTextFormField({TempAddHubsViewModel viewModel}) {
    return appTextFormField(
      controller: TextEditingController(text: viewModel.enteredHub.title),
      enabled: true,
      focusNode: hubTitleFocusNode,
      hintText: addHubsHubNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {
        viewModel.enteredHub = viewModel.enteredHub.copyWith(title: value);
        viewModel.notifyListeners();
        if (value.length > 1) {
          viewModel.checkForExistingHubTitleContainsApi(value.trim());
        }
      },
      onFieldSubmitted: (_) {
        hubTitleFocusNode.unfocus();
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildHubTitleTextFormField({TempAddHubsViewModel viewModel}) {
    return appTextFormField(
      controller: TextEditingController(text: viewModel.enteredHub.title),
      enabled: true,
      focusNode: hubTitleFocusNode,
      hintText: addHubsHubNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {
        viewModel.enteredHub = viewModel.enteredHub.copyWith(title: value);
        viewModel.notifyListeners();
        if (value.length > 1) {
          viewModel.checkForExistingHubTitleContainsApi(value.trim());
        }
      },
      onFieldSubmitted: (_) {
        hubTitleFocusNode.unfocus();
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildContactPersonView() {
    if (widget.viewModel.enteredHub.contactPerson != null) {
      contactPersonController.text = widget.viewModel.enteredHub.contactPerson;
    }
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
    if (widget.viewModel.enteredHub.mobile != null) {
      contactNumberController.text = widget.viewModel.enteredHub.mobile;
    }
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

  Widget buildHnoBuildingNameTextFormField() {
    if (widget.viewModel.enteredHub.addressLine1 != null) {
      houseNoBuildingNameController.text =
          widget.viewModel.enteredHub.addressLine1;
    }
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

  Widget buildAddressSelector() {
    return BottomSheetDropDown<String>(
      allowedValue: addressTypes,
      selectedValue: widget.viewModel.enteredHub.addressType,
      hintText: 'Address Type',
      bottomSheetTitle: 'Address Type',
      onValueSelected: (
        String selectedAddressType,
        int index,
      ) {
        widget.viewModel.enteredHub = widget.viewModel.enteredHub.copyWith(
          addressType: selectedAddressType,
        );
        widget.viewModel.notifyListeners();
      },
    );
  }

  Widget buildStreetTextFormField() {
    if (widget.viewModel.enteredHub.addressLine2 != null) {
      streetController.text = widget.viewModel.enteredHub.addressLine2;
    }
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
    if (widget.viewModel.enteredHub.locality != null) {
      localityController.text = widget.viewModel.enteredHub.locality;
    }
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

  buildCityTextFormField({TempAddHubsViewModel viewModel}) {
    if (widget.viewModel.enteredHub.city != null) {
      cityController.text = widget.viewModel.enteredHub.city;
    }

    return appTextFormField(
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: cityController,
      focusNode: cityFocusNode,
      hintText: addDriverCityHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {
        viewModel.enteredHub = viewModel.enteredHub.copyWith(city: value);
        viewModel.notifyListeners();
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, localityFocusNode, landmarkFocusNode);
      },
      validator: FormValidators().normalValidator,
    );

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
    if (widget.viewModel.enteredHub.state != null) {
      widget.viewModel.stateController.text = widget.viewModel.enteredHub.state;
    }

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
    if (widget.viewModel.enteredHub.country != null) {
      widget.viewModel.countryController.text =
          widget.viewModel.enteredHub.country;
    }
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
    if (widget.viewModel.enteredHub.pincode != null) {
      widget.viewModel.pinCodeController.text =
          widget.viewModel.enteredHub.pincode;
    }
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
    if (widget.viewModel.enteredHub.geoLatitude != null) {
      latitudeController.text =
          widget.viewModel.enteredHub.geoLatitude.toString();
    }
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
    if (widget.viewModel.enteredHub.geoLongitude != null) {
      longitudeController.text =
          widget.viewModel.enteredHub.geoLongitude.toString();
    }
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
    if (widget.viewModel.enteredHub.remarks != null) {
      remarkController.text = widget.viewModel.enteredHub.remarks;
    }
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

class TempAddHubsViewArguments {
  final int reviewedConsigId;

  TempAddHubsViewArguments({@required this.reviewedConsigId});
}
