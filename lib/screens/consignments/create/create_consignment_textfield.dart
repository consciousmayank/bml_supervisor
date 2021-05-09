import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bml/bml.dart';

Widget createConsignmentTextFormField({
  @required InputDecoration decoration,
  Function onPasswordTogglePressed,
  bool obscureText = false,
  bool showSuffix = false,
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
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled,
  String initialValue,
  String errorText = 'required',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
          initialValue: initialValue,
          autovalidateMode: autoValidateMode,
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
          decoration: decoration,
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator),
    ],
  );
}

void onfieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

getInputBorder({
  @required String hintText,
  @required String errorText,
  bool showSuffix = false,
}) {
  return InputDecoration(
    alignLabelWithHint: true,
    focusedErrorBorder: normalTextFormFieldBorder(),
    errorStyle: TextStyle(
      fontSize: 10,
    ),
    helperStyle: TextStyle(
      fontSize: 14,
    ),
    // contentPadding: EdgeInsets.all(16),
    labelText: hintText,
    labelStyle: TextStyle(color: AppColors.primaryColorShade5, fontSize: 14),
    fillColor: AppColors.appScaffoldColor,
    suffixIcon: showSuffix
        ? InkWell(
            onTap: () {
              // onPasswordTogglePressed(obscureText);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 70,
                child: Center(
                  child: Text(
                    errorText,
                    style: AppTextStyles.appBarTitleStyle
                        .copyWith(color: Colors.red),
                  ),
                ),
              ),
            ),
          )
        : null,
    focusedBorder: normalTextFormFieldBorder(),
    enabledBorder: normalTextFormFieldBorder(),
    disabledBorder: normalTextFormFieldBorder(),
    errorBorder: normalTextFormFieldBorder(),
  );
}

normalTextFormFieldBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(defaultBorder),
    borderSide: BorderSide(
      color: AppColors.primaryColorShade5,
    ),
  );
}
