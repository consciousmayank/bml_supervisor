import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget appTextFormField({
  String vehicleOwnerName, //required only in create consignment
  bool showRupeesSymbol = false,
  TextEditingController controller,
  FocusNode focusNode,
  String hintText,
  String initialValue,
  TextAlign textAlignment = TextAlign.start,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextInputType keyboardType,
  Function onFieldSubmitted,
  Function onEditingComplete,
  Function onTextChange,
  bool enabled = true,
  bool autoFocus = false,
  int maxLines = 1,
  InputDecoration inputDecoration,
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled,
  List<TextInputFormatter> formatter,
  String labelText,
  FormFieldValidator<String> validator,
  ButtonType buttonType = ButtonType.NONE,
  String buttonLabelText,
  Widget buttonIcon,
  Function onButtonPressed,
  String errorText,
  GlobalKey<State<StatefulWidget>> key,
}) {
  return GestureDetector(
    onTap: buttonType == ButtonType.FULL ? onButtonPressed.call : null,
    child: Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            hintText != null
                ? Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(hintText ?? "Null"),
                  )
                : Container(),
            vehicleOwnerName != null
                ? Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      vehicleOwnerName,
                      style: AppTextStyles.latoMedium16Primary5
                          .copyWith(fontSize: 10, color: Colors.green),
                    ),
                  )
                : Container(),
          ],
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Stack(
              children: [
                TextFormField(
                    enableInteractiveSelection: true,
                    initialValue: initialValue,
                    autovalidateMode: autoValidateMode,
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
                    decoration: inputDecoration ??
                        textFieldDecoration(showRupeesSymbol, errorText),
                    keyboardType: keyboardType,
                    onFieldSubmitted: onFieldSubmitted,
                    validator: validator),
                buttonType == ButtonType.NONE
                    ? Container()
                    : buttonType == ButtonType.SMALL
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              label: Text(buttonLabelText ?? ''),
                              icon: buttonIcon,
                              onPressed: buttonType == ButtonType.FULL
                                  ? null
                                  : onButtonPressed.call,
                            ),
                          )
                        : Positioned(
                            top: 10,
                            bottom: 10,
                            right: 20,
                            child: buttonIcon,
                          ),
                errorText != null
                    ? Positioned(
                        left: 4,
                        bottom: 0,
                        child: Text(
                          errorText,
                          style: AppTextStyles.latoMedium10PrimaryShade5
                              .copyWith(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

InputDecoration textFieldDecoration(bool showRupeesSymbol, String errorText) {
  return new InputDecoration(
    prefix: showRupeesSymbol ? Text(rupeeSymbol) : null,
    hintStyle: TextStyle(fontSize: 14, color: Colors.white),
    focusedBorder: normalTextFormFieldBorder(),
    enabledBorder: normalTextFormFieldBorder(),
    disabledBorder: normalTextFormFieldBorder(),
    errorBorder: errorText != null
        ? errorTextFormFieldBorder()
        : normalTextFormFieldBorder(),
  );
}

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

normalTextFormFieldBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(defaultBorder),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );
}

errorTextFormFieldBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(defaultBorder),
    borderSide: BorderSide(
      color: Colors.red,
    ),
  );
}

enum ButtonType { FULL, SMALL, NONE }
