import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

double curvedBorder = 40;

Widget loginTextFormField({
  bool obscureText = false,
  TextEditingController controller,
  FocusNode focusNode,
  String hintText,
  TextAlign textAlignment = TextAlign.start,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextInputType keyboardType,
  Function onFieldSubmitted,
  Function onEditingComplete,
  Function onTextChange,
  bool enabled = true,
  bool autoFocus = false,
  int maxLines = 1,
  List<TextInputFormatter> formatter,
  String labelText,
  FormFieldValidator<String> validator,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(curvedBorder),
    ),
    elevation: defaultElevation,
    child: TextFormField(
        obscureText: obscureText,
        textAlign: textAlignment,
        onEditingComplete: onEditingComplete,
        maxLines: maxLines,
        onChanged: onTextChange,
        textCapitalization: textCapitalization,
        inputFormatters: formatter,
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        decoration: textFieldDecoration(hintText),
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator),
  );
}

InputDecoration textFieldDecoration(String hintLabel) {
  return InputDecoration(
    alignLabelWithHint: true,
    errorStyle: TextStyle(
      fontSize: 14,
    ),
    helperStyle: TextStyle(
      fontSize: 14,
    ),
    // helperText: ' ',
    hintText: hintLabel,
    hintStyle:
        TextStyle(color: AppColors.loginTextFormFieldHintColor, fontSize: 14),
    fillColor: AppColors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(curvedBorder),
      borderSide: BorderSide(
        color: AppColors.primaryColorShade1,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(curvedBorder),
      borderSide: BorderSide(
        color: AppColors.primaryColorShade1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(curvedBorder),
      borderSide: BorderSide(
        color: AppColors.primaryColorShade1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(curvedBorder),
      borderSide: BorderSide(
        color: AppColors.primaryColorShade1,
      ),
    ),
  );
}

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
