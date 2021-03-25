import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';

///
///
class AppTextView extends StatelessWidget {
  final String hintText, value;
  final int lines;
  final TextAlign textAlign;
  final bool isUnderLined;
  final double underLinedTextFontSize;

  const AppTextView({
    Key key,
    @required this.hintText,
    @required this.value,
    this.textAlign = TextAlign.left,
    this.lines = 1,
    this.isUnderLined = false,
    this.underLinedTextFontSize = 16.00,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: lines,
      textAlign: textAlign,
      style: isUnderLined
          ? AppTextStyles.underLinedText.copyWith(
              color: AppColors.primaryColorShade5,
              fontSize: underLinedTextFontSize,
              fontWeight: FontWeight.bold,
            )
          : AppTextStyles.latoMedium16Primary5,
      decoration: getInputBorder(hint: hintText),
      enabled: false,
      controller: TextEditingController(text: value),
    );
  }

  getInputBorder({@required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.appScaffoldColor,
      contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      labelText: hint,
      labelStyle: TextStyle(
        color: AppColors.primaryColorShade5,
        decoration: TextDecoration.none,
        fontSize: 14,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultBorder),
        borderSide: BorderSide(
          color: AppColors.primaryColorShade5,
        ),
      ),
    );
  }
}
