import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';

class DashBoardLoadingWidget extends StatefulWidget {
  @override
  _DashBoardLoadingWidgetState createState() => _DashBoardLoadingWidgetState();
}

class _DashBoardLoadingWidgetState extends State<DashBoardLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
