import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_view.dart';
import 'package:bml_supervisor/screens/entrylog/add_entry_logs_view.dart';
import 'package:bml_supervisor/screens/expenses/expenses_mobile_view.dart';
import 'package:bml_supervisor/screens/search/search_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainViewRoute:
        return MaterialPageRoute(
          builder: (_) => DashBoardScreenView(),
        );

      case searchPageRoute:
        bool showVehicleDetails =
            settings.arguments != null ? settings.arguments : false;
        return MaterialPageRoute(
          builder: (_) => SearchView(
            showVehicleDetails: showVehicleDetails,
          ),
        );

      case addEntryLogPageRoute:
        return MaterialPageRoute(
          builder: (_) => EntryLogsView(),
        );

      case addExpensesPageRoute:
        return MaterialPageRoute(
          builder: (_) => ExpensesMobileView(),
        );

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('Please define page for  ${settings.name}')),
                ));
    }
  }
}
