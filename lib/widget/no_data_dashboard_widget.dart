import 'package:flutter/material.dart';

class NoDataWidget extends StatefulWidget {
  @override
  _NoDataWidgetState createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(child: Text('No data')),
    );
  }
}
