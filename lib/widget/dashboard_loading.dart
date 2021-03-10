import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';

class DashBoardLoadingWidget extends StatefulWidget {
  @override
  _DashBoardLoadingWidgetState createState() => _DashBoardLoadingWidgetState();
}

class _DashBoardLoadingWidgetState extends State<DashBoardLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Center(
        child: ShimmerContainer(),
      ),
    );
  }
}
