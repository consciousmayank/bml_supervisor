import 'package:flutter/material.dart';

class DisabledWidget extends StatelessWidget {
  final bool disabled;
  final Widget child;
  const DisabledWidget({
    Key key,
    this.disabled = false,
    @required this.child,
  })  : assert(child != null, 'Child cannot be null. Specify a child.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: Opacity(
        opacity: disabled ? 0.6 : 1.0,
        child: child,
      ),
    );
  }
}
