import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';

import 'locator.dart';

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.ERROR,
    config: SnackbarConfig(
      isDismissible: true,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: AppColors.primaryColorShade6,
      textColor: Colors.red,
      borderRadius: defaultBorder,
      borderColor: Colors.red[200],
      borderWidth: 1,
      animationDuration: Duration(milliseconds: 200),
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.NORMAL,
    config: SnackbarConfig(
      backgroundColor: Colors.black,
      titleColor: AppColors.primaryColorShade5,
      messageColor: Colors.white,
      borderRadius: 1,
    ),
  );
}
