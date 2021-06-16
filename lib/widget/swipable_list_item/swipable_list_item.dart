import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SwipableWidget extends StatefulWidget {
  final Widget child;
  final bool showAnimation;
  final int index;

  SwipableWidget({
    @required this.child,
    this.showAnimation = false,
    @required this.index,
  });

  @override
  _SwipableWidgetState createState() => _SwipableWidgetState();
}

class _SwipableWidgetState extends State<SwipableWidget> {
  ScrollController scrollController;
  double width;
  bool showAnimation;

  @override
  void initState() {
    showAnimation = widget.showAnimation;
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (width == null) {
      width = MediaQuery.of(context).size.width;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _animateInputField() {
    Future.delayed(
        Duration(
          milliseconds: 300,
        ), () async {
      await scrollController?.animateTo(
        width * 0.25,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      await Future.delayed(Duration(milliseconds: 1000));
      await scrollController?.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );

      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animateInputField.call();
      });
      return Container(
        child: widget.child,
      );
    } else {
      return Slidable(
        key: Key(widget.index.toString()),
        direction: Axis.horizontal,
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        child: widget.child,
        actions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () {
              print("delete");
            },
          ),
        ],
      );
    }
  }
}
