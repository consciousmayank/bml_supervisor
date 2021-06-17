import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final double fontSize;
  final double borderRadius;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPressed;
  final Color background;
  final Color borderColor;
  final double borderWidth;
  final String buttonText;
  final FontWeight buttonTextFontWeight;

  AppButton.normal({
    Key key,
    this.borderColor = AppColors.primaryColorShade5,
    this.borderRadius = defaultBorder,
    this.borderWidth = 0,
    @required this.onTap,
    this.onLongPressed,
    this.background = AppColors.primaryColorShade5,
    @required this.buttonText,
    this.fontSize = 14,
    this.buttonTextFontWeight = FontWeight.bold,
  });

  AppButton({
    Key key,
    @required this.borderColor,
    this.borderRadius = defaultBorder,
    @required this.onTap,
    this.onLongPressed,
    @required this.background,
    @required this.buttonText,
    this.fontSize = 14,
    this.borderWidth = 2,
    this.buttonTextFontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                borderRadius,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.white,
                blurRadius: 5,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(borderWidth),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            color: background,
            child: InkWell(
              onLongPress: onLongPressed != null
                  ? () {
                      onLongPressed.call();
                    }
                  : null,
              onTap: onTap != null
                  ? () {
                      onTap.call();
                    }
                  : null,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: AppTextStyles.latoMedium18White.copyWith(
                      fontSize: fontSize, fontWeight: buttonTextFontWeight),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
