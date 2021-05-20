import 'dart:ffi';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_vehicle_request.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:string_validator/string_validator.dart';

import 'add_vehicle_viewmodel.dart';

class AddVehicleView extends StatefulWidget {
  @override
  _AddVehicleViewState createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  final FocusNode chasisNumberFocusNode = FocusNode();
  final FocusNode vehicleHeightFocusNode = FocusNode();
  final FocusNode vehicleWidthFocusNode = FocusNode();
  final FocusNode vehicleLengthFocusNode = FocusNode();

  final FocusNode engineNumberFocusNode = FocusNode();

  final FocusNode ownerNameFocusNode = FocusNode();

  final FocusNode lastOwnerNameFocusNode = FocusNode();

  final FocusNode vehicleMakeFocusNode = FocusNode();

  final FocusNode vehicleModelFocusNode = FocusNode();

  final FocusNode rtoFocusNode = FocusNode();

  final FocusNode vehicleColorFocusNode = FocusNode();

  final FocusNode vehicleInitialReadingFocusNode = FocusNode();

  final FocusNode vehicleLoadCapacityFocusNode = FocusNode();

  final FocusNode registrationNumberFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddVehicleViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: setAppBarTitle(title: 'Add Vehicle'),
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: viewModel.isBusy
                    ? ShimmerContainer(
                        itemCount: 20,
                      )
                    : addVehicleRequestFormView(context, viewModel),
              ),
            ),
        viewModelBuilder: () => AddVehicleViewModel());
  }

  Widget addVehicleRequestFormView(
      BuildContext context, AddVehicleViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              controller: viewModel.controller,
              children: [
                chasisNumber(viewModel: viewModel),
                hSizedBox(20),
                registrationNumber(viewModel: viewModel),
                hSizedBox(20),
                engineNumber(viewModel: viewModel),
                hSizedBox(20),
                ownnerName(viewModel: viewModel),
                hSizedBox(20),
                lastOwnnerName(viewModel: viewModel),
                hSizedBox(20),
                vehicleMake(viewModel: viewModel),
                hSizedBox(20),
                vehicleModel(viewModel: viewModel),
                hSizedBox(20),
                rto(viewModel: viewModel),
                hSizedBox(20),
                vehicleColor(viewModel: viewModel),
                hSizedBox(20),
                vehicleInitialReading(viewModel: viewModel),
                hSizedBox(20),
                vehicleLoadCapacity(viewModel: viewModel),
                hSizedBox(20),
                Text('Enter Vehicle\'s'),
                Row(
                  children: [
                    Expanded(
                      child: vehicleHeight(viewModel: viewModel),
                      flex: 1,
                    ),
                    Expanded(
                      child: vehicleWidth(viewModel: viewModel),
                      flex: 1,
                    ),
                    Expanded(
                      child: vehicleLength(viewModel: viewModel),
                      flex: 1,
                    ),
                  ],
                ),
                hSizedBox(20),
                registrationDate(context, viewModel),
                hSizedBox(20),
                registrationUpto(context, viewModel),
                hSizedBox(20),
                ownerLevel(viewModel),
                hSizedBox(20),
                vehicleClass(viewModel),
                hSizedBox(20),
                vehicleFuelType(viewModel),
                hSizedBox(20),
                vehicleEmmisionType(viewModel),
                hSizedBox(20),
                vehicleSeating(viewModel),
              ],
            ),
          ),
          SizedBox(
            height: buttonHeight,
            width: MediaQuery.of(context).size.width,
            child: AppButton(
                borderColor: Colors.transparent,
                onTap: () {
                  if (_formKey.currentState.validate() &&
                      (!validateDropDowns(viewModel))) {
                    viewModel.registerVehicle();
                  }
                },
                background: AppColors.primaryColorShade5,
                buttonText: 'Submit'),
          )
        ],
      ),
    );
  }

  Widget chasisNumber({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.chassisNumberError,
      initialValue: viewModel.addVehicleRequest.chassisNumber,
      textCapitalization: TextCapitalization.characters,
      // controller: chasisNumberController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest =
              viewModel.addVehicleRequest.copyWith(chassisNumber: value);
          viewModel.notifyListeners();
        }
      },
      focusNode: chasisNumberFocusNode,
      hintText: chasisNumberHint,
      keyboardType: TextInputType.text,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, chasisNumberFocusNode, registrationNumberFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            chassisNumberError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            chassisNumberError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleHeight({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.heightError,
      initialValue: viewModel.addVehicleRequest.height == null
          ? ''
          : viewModel.addVehicleRequest.height.toString(),
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      keyboardType: TextInputType.number,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(height: int.parse(value), heightError: null);
        }
      },
      focusNode: vehicleHeightFocusNode,
      hintText: vehicleHeightHint,
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, vehicleHeightFocusNode, vehicleWidthFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            heightError: textRequired,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleWidth({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.widthError,
      initialValue: viewModel.addVehicleRequest.width == null
          ? ''
          : viewModel.addVehicleRequest.width.toString(),
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      keyboardType: TextInputType.number,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(width: int.parse(value), widthError: null);
        }
      },
      focusNode: vehicleWidthFocusNode,
      hintText: vehicleWidthHint,
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, vehicleWidthFocusNode, vehicleLengthFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            widthError: textRequired,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleLength({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.lengthError,
      initialValue: viewModel.addVehicleRequest.length == null
          ? ''
          : viewModel.addVehicleRequest.length.toString(),
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      keyboardType: TextInputType.number,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(length: int.parse(value), lengthError: null);
        }
      },
      focusNode: vehicleLengthFocusNode,
      hintText: vehicleLengthHint,
      onFieldSubmitted: (_) {
        vehicleLengthFocusNode.unfocus();
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            lengthError: textRequired,
          );
        }
        return null;
      },
    );
  }

  Widget registrationNumber({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.registrationNumberError,
      initialValue: viewModel.addVehicleRequest.registrationNumber,
      textCapitalization: TextCapitalization.characters,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
      // controller: registrationNumberController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              registrationNumber: value, registrationNumberError: null);
        }
      },
      focusNode: registrationNumberFocusNode,
      hintText: registrationNumberHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, registrationNumberFocusNode, engineNumberFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            registrationNumberError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            registrationNumberError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget engineNumber({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.engineNumberError,
      initialValue: viewModel.addVehicleRequest.engineNumber,
      textCapitalization: TextCapitalization.characters,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
      // controller: engineNumberController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(engineNumber: value, engineNumberError: null);
        }
      },
      focusNode: engineNumberFocusNode,
      hintText: engineNumberHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, engineNumberFocusNode, ownerNameFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            engineNumberError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            engineNumberError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget ownnerName({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.ownerNameError,
      initialValue: viewModel.addVehicleRequest.ownerName,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      // controller: ownerNameController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(ownerName: value, ownerNameError: null);
        }
      },
      focusNode: ownerNameFocusNode,
      hintText: ownerNameHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, ownerNameFocusNode, lastOwnerNameFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            ownerNameError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            ownerNameError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget lastOwnnerName({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.lastOwnerError,
      initialValue: viewModel.addVehicleRequest.lastOwner,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      // controller: lastOwnerNameController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(lastOwner: value, lastOwnerError: null);
        }
      },
      focusNode: lastOwnerNameFocusNode,
      hintText: lastOwnerNameHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, lastOwnerNameFocusNode, vehicleMakeFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            lastOwnerError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            lastOwnerError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleMake({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.makeError,
      initialValue: viewModel.addVehicleRequest.make,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      // controller: vehicleMakeController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(make: value, makeError: null);
        }
      },
      focusNode: vehicleMakeFocusNode,
      hintText: vehicleMakeHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, vehicleMakeFocusNode, vehicleModelFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            makeError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            makeError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleModel({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.modelError,
      initialValue: viewModel.addVehicleRequest.model,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      // controller: vehicleModelController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(model: value, modelError: null);
        }
      },
      focusNode: vehicleModelFocusNode,
      hintText: vehicleModelHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, vehicleModelFocusNode, rtoFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            modelError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            modelError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget rto({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.rtoError,
      initialValue: viewModel.addVehicleRequest.rto,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      // controller: rtoController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest =
              viewModel.addVehicleRequest.copyWith(rto: value, rtoError: null);
        }
      },
      focusNode: rtoFocusNode,
      hintText: rtoHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, rtoFocusNode, vehicleColorFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            rtoError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            rtoError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleColor({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.colorError,
      initialValue: viewModel.addVehicleRequest.color,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      ],
      // controller: vehicleColorController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(color: value, colorError: null);
        }
      },
      focusNode: vehicleColorFocusNode,
      hintText: vehicleColorHint,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        fieldFocusChange(
            context, vehicleColorFocusNode, vehicleInitialReadingFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            colorError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            colorError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleInitialReading({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.initReadingError,
      initialValue: viewModel.addVehicleRequest.initReading == null
          ? ''
          : viewModel.addVehicleRequest.initReading.toString(),
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(7)
      ],
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(initReading: int.parse(value), initReadingError: null);
        }
      },
      focusNode: vehicleInitialReadingFocusNode,
      hintText: vehicleInitialReadingHint,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, vehicleInitialReadingFocusNode,
            vehicleLoadCapacityFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            initReadingError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            initReadingError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget vehicleLoadCapacity({@required AddVehicleViewModel viewModel}) {
    return appTextFormField(
      errorText: viewModel.addVehicleRequest.loadCapacityError,
      initialValue: viewModel.addVehicleRequest.loadCapacity,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      // controller: vehicleLoadCapacityController,
      onTextChange: (String value) {
        if (value.trim().length > 0) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest
              .copyWith(loadCapacity: value, loadCapacityError: null);
        }
      },
      focusNode: vehicleLoadCapacityFocusNode,
      hintText: vehicleLoadCapacityHint,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {
        vehicleLoadCapacityFocusNode.unfocus();
      },
      validator: (value) {
        if (value.isEmpty) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            loadCapacityError: textRequired,
          );
        } else if (!isAlphanumeric(value)) {
          viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
            loadCapacityError: invalidChasisNumber,
          );
        }
        return null;
      },
    );
  }

  Widget registrationDate(BuildContext context, AddVehicleViewModel viewModel) {
    return appTextFormField(
        errorText: viewModel.addVehicleRequest.registrationDateError,
        hintText: registrationDateHint,
        enabled: false,
        controller: viewModel.registrationDateController,
        onTextChange: (String value) {
          if (value.trim().length > 0) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              registrationDate: value,
              registrationDateError: null,
            );
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              registrationDateError: textRequired,
            );
          }
          return null;
        },
        showButtonOnRight: true,
        buttonIcon: Icon(Icons.calendar_today_outlined),
        buttonLabelText: 'Select Date',
        onButtonPressed: () async {
          DateTime selectedDate = await _selectDate(viewModel);
          if (selectedDate != null) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              registrationDate:
                  DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase(),
            );
            viewModel.registrationDateController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
          }
        });
  }

  Widget registrationUpto(BuildContext context, AddVehicleViewModel viewModel) {
    return appTextFormField(
        errorText: viewModel.addVehicleRequest.registrationUptoError,
        // initialValue: viewModel.addVehicleRequest.registrationUpto,
        hintText: registrationUptoHint,
        enabled: false,
        controller: viewModel.registrationUptoController,
        onTextChange: (String value) {
          if (value.trim().length > 0) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              registrationUpto: value,
              registrationUptoError: null,
            );
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              registrationUptoError: textRequired,
            );
          }
          return null;
        },
        showButtonOnRight: true,
        buttonIcon: Icon(Icons.calendar_today_outlined),
        buttonLabelText: 'Select Date',
        onButtonPressed: () async {
          DateTime selectedDate = await _selectDate(viewModel);
          if (selectedDate != null) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
                registrationUpto: DateFormat('dd-MM-yyyy')
                    .format(selectedDate)
                    .toLowerCase());
            viewModel.registrationUptoController.text =
                DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
          }
        });
  }

  Future<DateTime> _selectDate(AddVehicleViewModel viewModel) async {
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
      lastDate: new DateTime(2035),
    );

    return picked;
  }

  ownerLevel(AddVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropDown(
          selectedValue: viewModel.addVehicleRequest.ownerLevel != null
              ? viewModel.addVehicleRequest.ownerLevel.toString()
              : null,
          hint: ownerLevelHint,
          onOptionSelect: (selectedValue) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
                ownerLevel: int.parse(selectedValue), ownerLevelError: null);
            viewModel.notifyListeners();
          },
          optionList: ownerLevelList,
        ),
        viewModel.addVehicleRequest.ownerLevelError != null
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  textRequired,
                  style: ThemeConfiguration()
                      .getAppThemeComplete()
                      .inputDecorationTheme
                      .errorStyle,
                ),
              )
            : Container()
      ],
    );
  }

  vehicleClass(AddVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropDown(
          selectedValue: viewModel.addVehicleRequest.vehicleClass != null
              ? viewModel.addVehicleRequest.vehicleClass
              : null,
          hint: vehicleClassHint,
          onOptionSelect: (selectedValue) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              vehicleClass: selectedValue,
              vehicleClassError: null,
            );
            viewModel.notifyListeners();
          },
          optionList: vehicleClassList,
        ),
        viewModel.addVehicleRequest.vehicleClassError != null
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  textRequired,
                  style: ThemeConfiguration()
                      .getAppThemeComplete()
                      .inputDecorationTheme
                      .errorStyle,
                ),
              )
            : Container()
      ],
    );
  }

  vehicleFuelType(AddVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropDown(
          selectedValue: viewModel.addVehicleRequest.fuelType != null
              ? viewModel.addVehicleRequest.fuelType
              : null,
          hint: vehicleFuelTypeHint,
          onOptionSelect: (selectedValue) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              fuelType: selectedValue,
              fuelTypeError: null,
            );
            viewModel.notifyListeners();
          },
          optionList: vehicleFuelTypeList,
        ),
        viewModel.addVehicleRequest.fuelTypeError != null
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  textRequired,
                  style: ThemeConfiguration()
                      .getAppThemeComplete()
                      .inputDecorationTheme
                      .errorStyle,
                ),
              )
            : Container()
      ],
    );
  }

  vehicleEmmisionType(AddVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropDown(
          selectedValue: viewModel.addVehicleRequest.emission != null
              ? viewModel.addVehicleRequest.emission
              : null,
          hint: vehicleEmissionTypeHint,
          onOptionSelect: (selectedValue) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
              emission: selectedValue,
              emissionError: null,
            );

            viewModel.notifyListeners();
          },
          optionList: vehicleEmmisionTypeList,
        ),
        viewModel.addVehicleRequest.emissionError != null
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  textRequired,
                  style: ThemeConfiguration()
                      .getAppThemeComplete()
                      .inputDecorationTheme
                      .errorStyle,
                ),
              )
            : Container()
      ],
    );
  }

  vehicleSeating(AddVehicleViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropDown(
          selectedValue: viewModel.addVehicleRequest.seatingCapacity != null
              ? viewModel.addVehicleRequest.seatingCapacity.toString()
              : null,
          hint: vehicleSeatingCapacityHint,
          onOptionSelect: (selectedValue) {
            viewModel.addVehicleRequest = viewModel.addVehicleRequest.copyWith(
                seatingCapacity: int.parse(selectedValue),
                seatingCapacityError: null);
            viewModel.notifyListeners();
          },
          optionList: vehicleSeatingList,
        ),
        viewModel.addVehicleRequest.seatingCapacityError != null
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  textRequired,
                  style: ThemeConfiguration()
                      .getAppThemeComplete()
                      .inputDecorationTheme
                      .errorStyle,
                ),
              )
            : Container()
      ],
    );
  }

  validateDropDowns(AddVehicleViewModel viewModel) {
    bool returningValue = false;
    if (viewModel.addVehicleRequest.seatingCapacity == null) {
      viewModel.addVehicleRequest.seatingCapacityError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.seatingCapacityError = null;
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.ownerLevel == null) {
      viewModel.addVehicleRequest.ownerLevelError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.ownerLevelError = null;
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.vehicleClass == null) {
      viewModel.addVehicleRequest.vehicleClassError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.vehicleClassError = null;
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.fuelType == null) {
      viewModel.addVehicleRequest.fuelTypeError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.fuelTypeError = null;
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.emission == null) {
      viewModel.addVehicleRequest.emissionError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.emissionError = null;
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.height == null) {
      viewModel.addVehicleRequest.widthError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.widthError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.width == null) {
      viewModel.addVehicleRequest.widthError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.widthError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.length == null) {
      viewModel.addVehicleRequest.lengthError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.lengthError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.loadCapacity == null) {
      viewModel.addVehicleRequest.loadCapacityError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.loadCapacityError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.initReading == null) {
      viewModel.addVehicleRequest.initReadingError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.initReadingError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.color == null) {
      viewModel.addVehicleRequest.colorError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.colorError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.rto == null) {
      viewModel.addVehicleRequest.rtoError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.rtoError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.emission == null) {
      viewModel.addVehicleRequest.emissionError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.emissionError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.model == null) {
      viewModel.addVehicleRequest.modelError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.modelError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.make == null) {
      viewModel.addVehicleRequest.makeError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.makeError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.fuelType == null) {
      viewModel.addVehicleRequest.fuelTypeError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.fuelTypeError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.vehicleClass == null) {
      viewModel.addVehicleRequest.vehicleClassError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.vehicleClassError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.lastOwner == null) {
      viewModel.addVehicleRequest.lastOwnerError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.lastOwnerError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.ownerLevel == null) {
      viewModel.addVehicleRequest.ownerLevelError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.ownerLevelError = null;
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.ownerName == null) {
      viewModel.addVehicleRequest.ownerNameError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.ownerNameError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.engineNumber == null) {
      viewModel.addVehicleRequest.engineNumberError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.engineNumberError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.chassisNumber == null) {
      viewModel.addVehicleRequest.chassisNumberError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.chassisNumberError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.registrationDate == null) {
      viewModel.addVehicleRequest.registrationDateError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.registrationDateError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.registrationNumber == null) {
      viewModel.addVehicleRequest.registrationNumberError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.registrationNumberError = '';
      returningValue = false;
    }

    if (viewModel.addVehicleRequest.registrationUpto == null) {
      viewModel.addVehicleRequest.registrationUptoError = textRequired;
      returningValue = true;
    } else {
      viewModel.addVehicleRequest.registrationUptoError = '';
      returningValue = false;
    }

    if (returningValue) {
      viewModel.scrollToBottom();
    }
    viewModel.notifyListeners();

    return returningValue;
  }
}
