import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class IconBlueBackground extends StatelessWidget {
  final String iconName;
  final double iconHeight;
  final double iconWidth;
  const IconBlueBackground({
    @required this.iconName,
    this.iconWidth = drawerIconsHeight,
    this.iconHeight = drawerIconsWidth,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: AppColors.drawerIconsBackgroundColor,
        borderRadius: getBorderRadius(),
      ),
      child: Center(
        child: Image.asset(
          iconName,
          height: iconHeight,
          width: iconWidth,
          // color: AppColors.primaryColorShade5,
        ),
      ),
    );
  }
}
