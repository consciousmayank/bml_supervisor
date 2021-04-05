import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget appTextFormField({
  bool showRupeesSymbol = false,
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
  InputDecoration inputDecoration,
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled,
  List<TextInputFormatter> formatter,
  String labelText,
  FormFieldValidator<String> validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      hintText!=null
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(hintText ?? "Null"),
            )
          : Container(),
      Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          child: TextFormField(
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
              decoration:
                  inputDecoration ?? textFieldDecoration(showRupeesSymbol),
              keyboardType: keyboardType,
              onFieldSubmitted: onFieldSubmitted,
              validator: validator),
        ),
      ),
    ],
  );
}

InputDecoration textFieldDecoration(bool showRupeesSymbol) {
  return new InputDecoration(
    prefix: showRupeesSymbol ? Text(rupeeSymbol) : null,
    hintStyle: TextStyle(fontSize: 14, color: Colors.white),
  );
}

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
