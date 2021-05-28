import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchWidget extends StatelessWidget {
  final String hintTitle;

  final Function onEditingComplete;
  final Function onClearTextClicked;
  final Function onTextChange;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> formatter;
  final bool enabled = true;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final Function onFieldSubmitted;

  const SearchWidget({
    Key key,
    @required this.hintTitle,
    @required this.onEditingComplete,
    @required this.onClearTextClicked,
    this.onTextChange,
    @required this.formatter,
    @required this.controller,
    @required this.focusNode,
    @required this.keyboardType,
    @required this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      childColor: AppColors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconBlueBackground(
              iconName: searchBlueIcon,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: hintTitle,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
                  ),
                  onEditingComplete: onEditingComplete,
                  onChanged: onTextChange,
                  textCapitalization: textCapitalization,
                  inputFormatters: formatter,
                  enabled: enabled,
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  onFieldSubmitted: onFieldSubmitted,
                ),
              ),
            ),
            if (controller.text.trim().length > 0)
              InkWell(
                onTap: () => onClearTextClicked(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                forwardArrowIcon,
                height: 10,
                width: 10,
              ),
            ),
          ],
        ),
      ),
      onTap: null,
      borderRadius: getBorderRadius(),
    );
  }

  normalTextFormFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultBorder),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  // errorTextFormFieldBorder() {
  //   return OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(defaultBorder),
  //     borderSide: BorderSide(
  //       color: Colors.red,
  //     ),
  //   );
  // }
}
