import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget getImage(
    {@required String assetName,
    @required double width,
    @required double height,
    BoxFit fit,
    @required Color color,
    @required Alignment alignment,
    String semanticsLabel = ""}) {
  return kIsWeb
      ? Image.network("/assets/$assetName",
          width: width,
          height: height,
          fit: fit ?? BoxFit.fill,
          color: color,
          alignment: alignment,
          semanticLabel: semanticsLabel)
      : SvgPicture.asset(assetName,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          semanticsLabel: semanticsLabel);
}
