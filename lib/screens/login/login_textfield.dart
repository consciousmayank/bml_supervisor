import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget loginTextFormField({
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
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        hintText,
        style: TextStyle(color: Colors.white, fontSize: 11),
      ),
      hSizedBox(5),
      TextFormField(
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
          decoration: InputDecoration(
            labelText: showSuffix ? ' ' : null,
            suffixIcon: showSuffix
                ? InkWell(
                    onTap: () {
                      onPasswordTogglePressed(obscureText);
                    },
                    child: Icon(obscureText
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined),
                  )
                : null,
            alignLabelWithHint: true,
            errorStyle: TextStyle(fontSize: 14, color: AppColors.white),
            helperStyle: TextStyle(
              fontSize: 14,
            ),
            fillColor: AppColors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: getBorderRadius(),
              borderSide: BorderSide(
                color: AppColors.primaryColorShade1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: getBorderRadius(),
              borderSide: BorderSide(
                color: AppColors.primaryColorShade1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: getBorderRadius(),
              borderSide: BorderSide(
                color: AppColors.primaryColorShade1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: getBorderRadius(),
              borderSide: BorderSide(
                color: AppColors.primaryColorShade1,
              ),
            ),
          ),
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator),
    ],
  );
}

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
