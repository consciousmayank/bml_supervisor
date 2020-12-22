import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'expenses_mobile_view.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => ExpensesMobileView(),
        // tablet: (BuildContext context) => ExpensesTabWebView(),
        // desktop: (BuildContext context) => ExpensesTabWebView(),
      ),
    );
  }
}
