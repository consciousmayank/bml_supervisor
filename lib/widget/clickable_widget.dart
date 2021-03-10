import 'package:bml_supervisor/app_level/colors.dart';
import 'package:flutter/material.dart';

class ClickableWidget extends StatefulWidget {
  final Color childColor;
  final Widget child;
  final double elevation;
  final Function onTap;
  final BorderRadius borderRadius;

  const ClickableWidget({
    Key key,
    @required this.child,
    @required this.onTap,
    this.childColor = AppColors.appScaffoldColor,
    @required this.borderRadius,
    this.elevation = 0,
  }) : super(key: key);

  @override
  _ClickableWidgetState createState() => _ClickableWidgetState();
}

class _ClickableWidgetState extends State<ClickableWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Material(
        elevation: widget.elevation,
        animationDuration: Duration(milliseconds: 200),
        borderRadius: widget.borderRadius,
        color: isPressed ? AppColors.primaryColorShade4 : widget.childColor,
        child: InkWell(
          splashColor: AppColors.primaryColorShade5,
          child: widget.child,
          onTap: () {
            widget.onTap.call();
          },
        ),
      ),
    );
  }

  void changeTap() {
    setState(() {
      isPressed = !isPressed;
    });
  }
}
