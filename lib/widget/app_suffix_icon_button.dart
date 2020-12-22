import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appSuffixIconButton({
  @required final Widget icon,
  @required final Function onPressed,
}) {
  return MaterialButton(
    height: buttonHeight,
    color: ThemeConfiguration.primaryBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(3.0), bottomRight: Radius.circular(3.0)),
    ),
    child: icon,
    onPressed: onPressed,
  );
}
