import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignmentallotment/consignement_allotment_view.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_view.dart';
// import 'package:bml_supervisor/screens/entrylog/add_entry_logs_view.dart';
import 'package:bml_supervisor/screens/expenses/expenses_mobile_view.dart';
import 'package:bml_supervisor/screens/search/search_view.dart';
import 'package:bml_supervisor/screens/viewentry/view_entry_detailed_view.dart';
// import 'package:bml_supervisor/screens/viewentry/view_entry_view.dart';
import 'package:bml_supervisor/screens/viewentry2PointO/view_entry_view_2.dart';
import 'package:bml_supervisor/screens/viewentry2PointO/view_entry_detailed_view_2.dart';
import 'package:bml_supervisor/screens/viewexpenses/view_expenses_detailed_view.dart';
import 'package:bml_supervisor/screens/viewexpenses/view_expenses_view.dart';
import 'package:bml_supervisor/screens/entrylog2.0/add_entry_logs_view_2.dart';
import 'package:bml_supervisor/screens/entrylog2.0/add_entry_form_view_2.dart';
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
            builder: (_) => AddEntryLogsView2PointO() //EntryLogsView(),
            );

      case viewEntryLogPageRoute:
        return MaterialPageRoute(
            builder: (_) => ViewEntryView2PointO() //ViewEntryView(),
            );
      // case viewEntry2PointOLogPageRoute:
      //   return MaterialPageRoute(
      //     builder: (_) => ViewEntryView2PointO(),
      //   );

      case viewEntryDetailedViewPageRoute:
        Map<String, dynamic> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ViewEntryDetailedView(arguments: args),
        );

      case viewEntryDetailedView2PointOPageRoute:
        Map<String, dynamic> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ViewEntryDetailedView2Point0(arguments: args),
        );

      case addExpensesPageRoute:
        return MaterialPageRoute(
          builder: (_) => ExpensesMobileView(),
        );

      case viewExpensesPageRoute:
        return MaterialPageRoute(
          builder: (_) => ViewExpensesView(),
        );

      case viewExpensesDetailedViewPageRoute:
        List<ViewExpensesResponse> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ViewExpensesDetailedView(
            viewExpensesDetailedList: args,
          ),
        );

      case allotConsignmentsPageRoute:
        return MaterialPageRoute(
          builder: (_) => ConsignmentAllotmentView(),
        );

      // case addEntry2PointOLogPageRoute:
      //   return MaterialPageRoute(
      //     builder: (_) => AddEntryLogsView2PointO(),
      //   );

      case addEntry2PointOFormViewPageRoute:
        Map<String, dynamic> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => AddEntry2PointOFormView(arguments: args),
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
