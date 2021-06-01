import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/string_list_type_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class BottomSheetDropDown<T> extends StatefulWidget {
  final List<T> allowedValue;
  T selectedValue;
  final String hintText;
  final String errorText;
  final Function onValueSelected;
  final BottomSheetDropDownType bottomSheetDropDownType;
  final String supportText;

  BottomSheetDropDown({
    Key key,
    this.errorText,
    this.supportText,
    @required this.allowedValue,
    @required this.selectedValue,
    @required this.hintText,
    @required this.onValueSelected,
    this.bottomSheetDropDownType = BottomSheetDropDownType.STRING,
  }) : super(key: key);

  BottomSheetDropDown.createConsignmentRoutes({
    Key key,
    this.errorText,
    this.supportText,
    @required this.allowedValue,
    @required this.selectedValue,
    @required this.hintText,
    @required this.onValueSelected,
    this.bottomSheetDropDownType =
        BottomSheetDropDownType.CREATE_CONSIGNMENT_ROUTES_LIST,
  }) : super(key: key);

  ///To show while adding expenses. Shows a list of clientId+vehicleId+routeTitle
  BottomSheetDropDown.getDailyKilometerInfo({
    Key key,
    this.errorText,
    this.supportText,
    @required this.allowedValue,
    @required this.selectedValue,
    @required this.hintText,
    @required this.onValueSelected,
    this.bottomSheetDropDownType =
        BottomSheetDropDownType.ADD_EXPENSES_ROUTES_LIST,
  }) : super(key: key);

  @override
  _BottomSheetDropDownState<T> createState() => _BottomSheetDropDownState<T>();
}

class _BottomSheetDropDownState<T> extends State<BottomSheetDropDown> {
  // T preSelectedValue;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    // preSelectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return appTextFormField(
      errorText: widget.errorText,
      controller: TextEditingController(
        text: getTextValue(),
      ),
      enabled: false,
      hintText: widget.hintText ?? '',
      keyboardType: TextInputType.text,
      buttonType: ButtonType.FULL,
      buttonIcon: isOpen
          ? Icon(Icons.arrow_drop_up_sharp)
          : Icon(Icons.arrow_drop_down_sharp),
      onButtonPressed: () {
        setState(() {
          isOpen = true;
        });
        hideKeyboard(context: context);
        locator<BottomSheetService>()
            .showCustomSheet(
          customData: StringListTypeBottomSheetInputArgs<T>(
            allowedValues: widget.allowedValue,
            preSelectedValue: widget.selectedValue,
            bottomSheetDropDownType: widget.bottomSheetDropDownType,
          ),
          barrierDismissible: false,
          isScrollControlled: false,
          variant: BottomSheetType.STRING_LIST,
        )
            .then((value) {
          if (value != null && value.confirmed) {
            StringListTypeBottomSheetOutputArgs args = value.responseData;
            widget.onValueSelected.call(args.selectedValue, args.index);

            setState(() {
              widget.selectedValue = args.selectedValue;
              isOpen = false;
            });
          } else {
            setState(() {
              isOpen = false;
            });
          }
        });
      },
    );
  }

  getTextValue() {
    switch (widget.bottomSheetDropDownType) {
      case BottomSheetDropDownType.CREATE_CONSIGNMENT_ROUTES_LIST:
        return 'R#${widget.selectedValue.routeId}. ${widget.selectedValue.routeTitle}';

      case BottomSheetDropDownType.ADD_EXPENSES_ROUTES_LIST:
        if (widget.selectedValue.routeTitle.length > 0) {
          return '${widget.selectedValue.clientId} - ${widget.selectedValue.vehicleId}(${widget.selectedValue.routeTitle})';
        } else {
          return '';
        }

        break;
      case BottomSheetDropDownType.STRING:
        return widget.selectedValue.toString();
        break;

      case BottomSheetDropDownType.EXISTING_HUB_TITLE_LIST:
        String hubLabel;
        if (widget.allowedValue.length > 1) {
          hubLabel = 'hubs';
        } else {
          hubLabel = 'hub';
        }
        return '${widget.allowedValue.length.toString()} $hubLabel matches title \'${widget.supportText}\''.toUpperCase();
        break;

      default:
        return '';
    }
  }
}

enum BottomSheetDropDownType {
  CREATE_CONSIGNMENT_ROUTES_LIST,
  STRING,
  ADD_EXPENSES_ROUTES_LIST,
  EXISTING_HUB_TITLE_LIST,
}
