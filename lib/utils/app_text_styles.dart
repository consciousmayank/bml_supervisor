import 'package:bml_supervisor/app_level/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextStyles {

  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  TextStyle get textStyle => TextStyle(
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: textColor,
  );
  
  TextStyle get appBarTitleStyleNew => textStyle.copyWith(
    color: AppColors.white,
  );
  
  TextStyle get hintTextStyle => textStyle.copyWith(
    color: Colors.black54,
  );

  TextStyle get underLinedTextStyleNew => textStyle.copyWith(decoration: TextDecoration.underline,);
  TextStyle get textFormFieldTextStyle => textStyle.copyWith(decoration: TextDecoration.underline, fontSize: 16);
  
  TextStyle get hyperLinkStyleNew => textStyle.copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.bold,);

  AppTextStyles({
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.textColor = AppColors.primaryColorShade5,
  });
  
  AppTextStyles.bsGridViewLabelStyle({
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.textColor = AppColors.primaryColorShade4,
  });
  
  AppTextStyles.bsGridViewValueStyle({
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.textColor = AppColors.primaryColorShade4,
  });
  
  AppTextStyles.expensesPeriodTitle({
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
    this.textColor = AppColors.primaryColorShade4,
  });

  //Todo : delete in someTime.
  static const TextStyle latoBold18Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.black,
  );
  static const TextStyle latoBold16White = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle latoBold18PrimaryShade5 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.primaryColorShade5,
  );
  static const TextStyle lato20PrimaryShade5 = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.primaryColorShade5,
  );

  static const TextStyle latoBold12Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: AppColors.black,
  );

  static const TextStyle latoBold14primaryColorShade6 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.primaryColorShade6,
  );

  static const TextStyle latoMedium12Black = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: AppColors.black,
  );

  static const TextStyle latoMedium14Black = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.black,
  );

  static const TextStyle latoMedium10PrimaryShade5 = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 10,
    color: AppColors.primaryColorShade5,
  );

  static const TextStyle whiteRegular = TextStyle(
    color: AppColors.white,
  );

  static const TextStyle latoMedium12PrimaryShade5 = TextStyle(
    color: AppColors.primaryColorShade5,
    fontSize: 12,
  );

  static const TextStyle latoBold14Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.black,
  );
  static const TextStyle latoBold15Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: AppColors.black,
  );

  static const TextStyle latoMediumItalics20 = TextStyle(
      fontStyle: FontStyle.italic, fontSize: 20, color: AppColors.white);

  static const TextStyle latoMediumItalics15 = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 15,
      color: AppColors.primaryColorShade5);

  static const TextStyle latoBold16Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle latoMedium16Primary5 = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: AppColors.primaryColorShade5);

  static const TextStyle underLinedText = TextStyle(
    decoration: TextDecoration.underline,
  );
  static const TextStyle underlinedPrimaryShade5 = TextStyle(
    color: AppColors.primaryColorShade5,
    decoration: TextDecoration.underline,
  );

  static const TextStyle latoMedium18White = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.white,
  );

  static const TextStyle appBarTitleStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.white,
  );

  static const TextStyle hyperLinkStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.primaryColorShade5,
    decoration: TextDecoration.underline,
  );
}
