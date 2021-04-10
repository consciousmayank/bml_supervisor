import 'package:bml_supervisor/app_level/colors.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: FDottedLine(
        color: AppColors.primaryColorShade5,
        width: double.infinity,
        strokeWidth: 1.0,
        dottedLength: 1.0,
        space: 1.0,
      ),
    );
  }
}
