import 'dart:async';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/temp_hubs/add_hubs/temp_add_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class TempAddHubsView extends StatefulWidget {
  const TempAddHubsView({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  final TempAddHubsViewArguments arguments;

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
            ),
            body: model.isBusy
                ? ShimmerContainer(
                    itemCount: 20,
                  )
                : AddHubBodyWidget(
                    hubTitle: widget.arguments.hubTitle,
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
  const AddHubBodyWidget({
    Key key,
    @required this.viewModel,
    @required this.hubsList,
    @required this.reviewedConsigId,
    this.hubTitle,
  }) : super(key: key);

  final List<SingleTempHub> hubsList;
  final int reviewedConsigId;
  final String hubTitle;
  final TempAddHubsViewModel viewModel;

  @override
  _AddHubBodyWidgetState createState() => _AddHubBodyWidgetState();
}

class _AddHubBodyWidgetState extends State<AddHubBodyWidget> {
  TextEditingController alternateMobileNumberController =
      TextEditingController();

  FocusNode alternateMobileNumberFocusNode = FocusNode();
  GlobalKey autocompleteKey = GlobalKey();
  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();
  TextEditingController contactNumberController = TextEditingController();
  FocusNode contactNumberFocusNode = FocusNode();
  TextEditingController contactPersonController = TextEditingController();
  FocusNode contactPersonFocusNode = FocusNode();
  TextEditingController doRController = TextEditingController();
  FocusNode doRFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode focusNode = FocusNode();
  TextEditingController houseNoBuildingNameController = TextEditingController();
  FocusNode houseNoBuildingNameFocusNode = FocusNode();
  TextEditingController hubTitleController = TextEditingController();
  FocusNode hubTitleFocusNode = FocusNode();
  TextEditingController itemsCollectController = TextEditingController();
  FocusNode itemsCollectFocusNode = FocusNode();
  TextEditingController itemsDropController = TextEditingController();
  FocusNode itemsDropFocusNode = FocusNode();
  TextEditingController landmarkController = TextEditingController();
  FocusNode landmarkFocusNode = FocusNode();
  TextEditingController latitudeController = TextEditingController();
  FocusNode latitudeFocusNode = FocusNode();
  TextEditingController localityController = TextEditingController();
  FocusNode localityFocusNode = FocusNode();
  TextEditingController longitudeController = TextEditingController();
  FocusNode longitudeFocusNode = FocusNode();
  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocusNode = FocusNode();
  TextEditingController streetController = TextEditingController();
  FocusNode streetFocusNode = FocusNode();

  Timer _debounce;
  final List<GlobalKey> _key = List.generate(25, (index) => GlobalKey());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  BottomSheetDropDown<SingleTempHub> buildExistingHubBottomSheetDropDown() {
    return BottomSheetDropDown<SingleTempHub>(
      bottomSheetTitle: 'Existing Hub(s)',
      supportText: hubTitleController.text,
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
      ) {},
    );
  }

  Widget buildSaveButton() {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            widget.viewModel.addToReturningHubsList(
                newHubObject: SingleTempHub.empty().copyWith(
                  title: hubTitleController.text,
                  consignmentId: widget.reviewedConsigId,
                ),
                onErrorOccured: (widgetType) =>
                    onErrorOccured(widgetType: widgetType));
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Save'),
    );
  }

  Widget buildHubTitleTextFormField({TempAddHubsViewModel viewModel}) {
    if (widget.hubTitle != null && widget.hubTitle.trim().length > 0) {
      hubTitleController.text = widget.hubTitle;
    }
    return appTextFormField(
      buttonType: hubTitleController.text.length > 0
          ? ButtonType.SMALL
          : ButtonType.NONE,
      buttonIcon: hubTitleController.text.length > 0 ? Icon(Icons.close) : null,
      buttonLabelText: 'Reset',
      onButtonPressed: () {
        viewModel.resetForm();
        hubTitleController.clear();
      },
      controller: hubTitleController,
      enabled: true,
      focusNode: hubTitleFocusNode,
      hintText: addHubsHubNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {
        viewModel.checkForExistingHubTitleContainsApi(value);
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
    } else {
      contactPersonController.clear();
    }
    return appTextFormField(
      enabled: true,
      controller: contactPersonController,
      focusNode: contactPersonFocusNode,
      hintText: addHubsContactPersonHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(contactPerson: value);
      },
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
    } else {
      contactNumberController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(mobile: value);
      },
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
    } else {
      houseNoBuildingNameController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(addressLine1: value);
      },
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
      selectedValue: widget.viewModel.enteredHub.addressType ?? '',
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
      validator: FormValidators().normalValidator,
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(nearby: value);
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, landmarkFocusNode, widget.viewModel.cityFocusNode);
      },
    );
  }

  Widget buildStreetTextFormField() {
    if (widget.viewModel.enteredHub.addressLine2 != null) {
      streetController.text = widget.viewModel.enteredHub.addressLine2;
    } else {
      streetController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(addressLine2: value);
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, streetFocusNode, localityFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildLocalityTextFormField() {
    if (widget.viewModel.enteredHub.locality != null) {
      localityController.text = widget.viewModel.enteredHub.locality;
    } else {
      localityController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(locality: value);
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, localityFocusNode, landmarkFocusNode);
      },
      validator: FormValidators().normalValidator,
    );
  }

  buildCityTextFormField({TempAddHubsViewModel viewModel}) {
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

        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(city: temp.city);

        viewModel.getPinCodeState(cityId: temp.id);
        // viewModel.selectedCity = temp;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        if (viewModel.enteredHub.city != null) {
          textEditingController.text = viewModel.enteredHub.city;
          textEditingController.selection = TextSelection.fromPosition(
            TextPosition(
              offset: textEditingController.text.length,
            ),
          );
        } else {
          textEditingController.clear();
        }

        return appTextFormField(
          hintText: "City",
          controller: textEditingController,
          onTextChange: (String value) {
            widget.viewModel.enteredHub.copyWith(city: value);
          },
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

  Widget dropInput() {
    if (widget.viewModel.enteredHub.dropOff != null) {
      itemsDropController.text = widget.viewModel.enteredHub.dropOff.toString();
      itemsDropController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: itemsDropController.text.length,
        ),
      );
    } else {
      itemsDropController.clear();
    }
    return appTextFormField(
      onTextChange: (String value) {
        widget.viewModel.enteredHub = widget.viewModel.enteredHub.copyWith(
          dropOff: value.trim().length == 0 ? 0 : double.parse(value),
        );
        // widget.viewModel.notifyListeners();
      },
      hintText: "${widget.viewModel.enteredHub.itemUnit ?? 'Items'} Drop",
      enabled: true,
      controller: itemsDropController,
      focusNode: itemsDropFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          itemsDropFocusNode,
          itemsCollectFocusNode,
        );
      },
      keyboardType: TextInputType.number,
      validator: FormValidators().normalValidator,
    );
  }

  Widget collectInput() {
    if (widget.viewModel.enteredHub.collect != null) {
      itemsCollectController.text =
          widget.viewModel.enteredHub.collect.toString();
      itemsCollectController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: itemsCollectController.text.length,
        ),
      );
    } else {
      itemsCollectController.clear();
    }
    return appTextFormField(
      onTextChange: (String value) {
        widget.viewModel.enteredHub = widget.viewModel.enteredHub.copyWith(
          collect: value.trim().length == 0 ? 0 : double.parse(value),
        );
        // widget.viewModel.notifyListeners();
      },
      hintText: "${widget.viewModel.enteredHub.itemUnit ?? 'Items'} Collect",
      enabled: true,
      controller: itemsCollectController,
      focusNode: itemsCollectFocusNode,
      onFieldSubmitted: (_) {
        itemsCollectFocusNode.unfocus();
      },
      keyboardType: TextInputType.number,
      validator: FormValidators().normalValidator,
    );
  }

  Widget buildStateTextFormField() {
    if (widget.viewModel.enteredHub.state != null) {
      widget.viewModel.stateController.text = widget.viewModel.enteredHub.state;
    } else {
      widget.viewModel.stateController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub.copyWith(state: value);
      },
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
    } else {
      widget.viewModel.countryController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub.copyWith(country: value);
      },
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
    } else {
      widget.viewModel.pinCodeController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub.copyWith(pincode: value);
      },
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
    } else {
      latitudeController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub = widget.viewModel.enteredHub
            .copyWith(geoLatitude: double.parse(value));
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, latitudeFocusNode, longitudeFocusNode);
      },
    );
  }

  Widget buildLongitudeTextFormField() {
    if (widget.viewModel.enteredHub.geoLongitude != null) {
      longitudeController.text =
          widget.viewModel.enteredHub.geoLongitude.toString();
    } else {
      longitudeController.clear();
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
      onTextChange: (String value) {
        widget.viewModel.enteredHub = widget.viewModel.enteredHub
            .copyWith(geoLongitude: double.parse(value));
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, longitudeFocusNode, remarkFocusNode);
      },
    );
  }

  Widget buildRemarksTextFormField() {
    if (widget.viewModel.enteredHub.remarks != null) {
      remarkController.text = widget.viewModel.enteredHub.remarks;
    } else {
      remarkController.clear();
    }
    return appTextFormField(
      enabled: true,
      maxLines: 7,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      ],
      controller: remarkController,
      focusNode: remarkFocusNode,
      hintText: addDriverRemarksHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {
        widget.viewModel.enteredHub =
            widget.viewModel.enteredHub.copyWith(remarks: (value));
      },
      onFieldSubmitted: (_) {
        remarkFocusNode.unfocus();
      },
    );
  }

  onErrorOccured({
    @required ErrorWidgetType widgetType,
  }) {
    switch (widgetType) {
      case ErrorWidgetType.TITLE:
        hubTitleFocusNode.requestFocus();
        break;
      case ErrorWidgetType.DROP_INPUT:
        itemsDropFocusNode.requestFocus();
        break;
      case ErrorWidgetType.COLLECT_INPUT:
        itemsCollectFocusNode.requestFocus();
        break;
        break;
      case ErrorWidgetType.HOUSE_N0_BUULDING_NAME:
        houseNoBuildingNameFocusNode.requestFocus();
        break;
      case ErrorWidgetType.STREET:
        streetFocusNode.requestFocus();
        break;
      case ErrorWidgetType.LOCALITY:
        localityFocusNode.requestFocus();
        break;
      case ErrorWidgetType.CITY:
        cityFocusNode.requestFocus();
        break;
      case ErrorWidgetType.PINCODE:
        widget.viewModel.pinCodeFocusNode.requestFocus();
        break;
      case ErrorWidgetType.CONTACT_PERSON:
        contactPersonFocusNode.requestFocus();
        break;
      case ErrorWidgetType.CONTACT_NUMBER:
        contactNumberFocusNode.requestFocus();
        break;
      case ErrorWidgetType.LANDMARK:
        landmarkFocusNode.requestFocus();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHubTitleTextFormField(viewModel: widget.viewModel),
            widget.viewModel.hubsList.length > 0
                ? buildExistingHubBottomSheetDropDown()
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
                itemsDropFocusNode.requestFocus();
              },
              optionList: selectItemUnit,
            ),
            Row(
              children: [
                Expanded(
                  child: dropInput(),
                  flex: 1,
                ),
                wSizedBox(10),
                Expanded(
                  child: collectInput(),
                  flex: 1,
                ),
              ],
            ),
            buildAddressSelector(),
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
            buildContactPersonView(),
            buildContactNumberTextFormField(),
            buildLatitudeTextFormField(),
            buildLongitudeTextFormField(),
            buildRemarksTextFormField(),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }
}

class TempAddHubsViewArguments {
  TempAddHubsViewArguments({
    @required this.reviewedConsigId,
    this.hubsList,
    this.hubTitle,
  });

  final List<SingleTempHub> hubsList;
  final int reviewedConsigId;
  final String hubTitle;
}

enum ErrorWidgetType {
  TITLE,
  DROP_INPUT,
  COLLECT_INPUT,
  HOUSE_N0_BUULDING_NAME,
  STREET,
  LOCALITY,
  CITY,
  LANDMARK,
  PINCODE,
  CONTACT_PERSON,
  CONTACT_NUMBER,
}
