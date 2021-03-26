import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appSuffixIconButton({
  @required final Widget icon,
  @required final Function onPressed,
}) {
  return SizedBox(
    height: buttonHeight,
    child: ElevatedButton(
      child: icon,
      onPressed: onPressed,
    ),
  );
}
