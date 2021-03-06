import 'dart:typed_data';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    Key key,
    @required this.image,
    this.size = profileImageSize,
    this.circularBorderRadius,
    this.imageFit = BoxFit.cover,
  }) : super(key: key);

  final Uint8List image;
  final double size;
  final double circularBorderRadius;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColorShade5, width: 2),
        borderRadius: BorderRadius.circular(
            circularBorderRadius != null ? circularBorderRadius : size),
        color: AppColors.appScaffoldColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            circularBorderRadius != null ? circularBorderRadius : size),
        child: image == null
            ? Image.asset(
                profileIcon,
                color: AppColors.primaryColorShade5,
                fit: imageFit,
                height: size,
                width: size,
              )
            : Image.memory(
                image,
                fit: imageFit,
                height: size == 0 ? double.infinity : size,
                width: size == 0 ? double.infinity : size,
              ),
      ),
    );
  }
}
