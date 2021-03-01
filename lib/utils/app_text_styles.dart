import 'package:bml_supervisor/app_level/colors.dart';
import 'package:flutter/cupertino.dart';

class AppTextStyles {
  static const TextStyle latoBold18Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.black,
  );

  static const TextStyle latoBold12Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: AppColors.black,
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

  static const TextStyle latoBold14Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.black,
  );

  static const TextStyle latoBold16Black = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.black);

  static const TextStyle underLinedText = TextStyle(
    decoration: TextDecoration.underline,
  );

  static const TextStyle whiteRegular = TextStyle(
    color: AppColors.white,
  );

  static const TextStyle latoMediumItalics20 = TextStyle(
      fontStyle: FontStyle.italic, fontSize: 20, color: AppColors.white);

  static const TextStyle appBarTitleStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.white,
  );
  static const TextStyle latoMedium16Primary5 = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: AppColors.primaryColorShade5);
  static const TextStyle latoBold18PrimaryShade5 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.primaryColorShade5,
  );
}
