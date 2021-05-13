import 'package:bml_supervisor/app_level/colors.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final double strokeWidth;
  final double dottedLength;
  final double space;
  const DottedDivider({
    Key key,
    this.color = AppColors.primaryColorShade5,
    this.height,
    this.width = double.infinity,
    this.strokeWidth = 1.0,
    this.dottedLength = 1.0,
    this.space = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: FDottedLine(
        color: color,
        width: width,
        strokeWidth: strokeWidth,
        dottedLength: dottedLength,
        space: space,
      ),
    );
  }
}
