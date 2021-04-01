import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final double borderRadius;
  final double fontSize;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPressed;
  final Color background;
  final Color borderColor;
  final String buttonText;

  const AppButton({
    Key key,
    @required this.borderColor,
    this.borderRadius = defaultBorder,
    @required this.onTap,
    this.onLongPressed,
    @required this.background,
    @required this.buttonText,
    @required this.fontSize,
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
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                borderRadius,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(
                  0.15,
                ),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            elevation: defaultElevation,
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
                  style: AppTextStyles.latoMedium18White.copyWith(fontSize: fontSize),
                  // style: TextStyle(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
