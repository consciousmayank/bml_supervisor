import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/string_list_type_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BottomSheetDropDown<T> extends StatefulWidget {
  final List<T> allowedValue;
  final String selectedValue;
  final String hintText;
  final Function onValueSelected;
  final BottomSheetDropDownType bottomSheetDropDownType;

  const BottomSheetDropDown({
    Key key,
    @required this.allowedValue,
    @required this.selectedValue,
    @required this.hintText,
    @required this.onValueSelected,
    this.bottomSheetDropDownType = BottomSheetDropDownType.STRING,
  }) : super(key: key);

  const BottomSheetDropDown.createConsignmentRoutes({
    Key key,
    @required this.allowedValue,
    @required this.selectedValue,
    @required this.hintText,
    @required this.onValueSelected,
    this.bottomSheetDropDownType =
        BottomSheetDropDownType.CREATE_CONSIGNMENT_ROUTES_LIST,
  }) : super(key: key);

  @override
  _BottomSheetDropDownState<T> createState() => _BottomSheetDropDownState<T>();
}

class _BottomSheetDropDownState<T> extends State<BottomSheetDropDown> {
  String preSelectedValue = '';
  bool isOpen = false;
  @override
  void initState() {
    super.initState();
    preSelectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return appTextFormField(
      controller: TextEditingController(
        text: preSelectedValue,
      ),
      enabled: false,
      hintText: widget.hintText,
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
              preSelectedValue = args.selectedTextVale;
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
}

enum BottomSheetDropDownType { CREATE_CONSIGNMENT_ROUTES_LIST, STRING }
