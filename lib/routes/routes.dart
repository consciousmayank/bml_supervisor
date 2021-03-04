import 'package:bml_supervisor/app_level/network_sensitive_screen.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_arguments.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_form_view.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_logs_view.dart';
import 'package:bml_supervisor/screens/consignments/allot/consignement_allotment_view.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_arguments.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_view.dart';
import 'package:bml_supervisor/screens/consignments/review/view_consigment_view.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_view.dart';
import 'package:bml_supervisor/screens/dashboard/view_all_consignments_view.dart';
import 'package:bml_supervisor/screens/distributors/distributors_view.dart';
import 'package:bml_supervisor/screens/expenses/add/expenses_mobile_view.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_detailed_view.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_view.dart';
import 'package:bml_supervisor/screens/login/login_view.dart';
import 'package:bml_supervisor/screens/payments/payments_view.dart';
import 'package:bml_supervisor/screens/search/search_view.dart';
import 'package:bml_supervisor/screens/splash_screen.dart';
import 'package:bml_supervisor/screens/viewhubs/hubs_view.dart';
import 'package:bml_supervisor/screens/viewhubs/view_routes_arguments.dart';
import 'package:bml_supervisor/screens/viewroutes/view_routes_view.dart';
import 'package:bml_supervisor/screens/viewvehicleentry/view_entry_detailed_view.dart';
import 'package:bml_supervisor/screens/viewvehicleentry/view_entry_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainViewRoute:
      case mainViewRoute:
        return MaterialPageRoute(
          // builder: (_) => LoginView(),
          builder: (_) => SplashScreen(),
        );

      case logInPageRoute:
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );

      case dashBoardPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: DashBoardScreenView(),
          ),
        );

      case searchPageRoute:
        bool showVehicleDetails =
            settings.arguments != null ? settings.arguments : false;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: SearchView(
              showVehicleDetails: showVehicleDetails,
            ),
          ),
        );

      case addEntryLogPageRoute:
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: AddVehicleEntryView(),
                ) //EntryLogsView(),
            );

      case viewEntryLogPageRoute:
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: ViewVehicleEntryView(),
                ) //ViewEntryView(),
            );

      case viewEntryDetailedView2PointOPageRoute:
        Map<String, dynamic> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewEntryDetailedView(arguments: args),
          ),
        );

      case viewAllConsignmentsViewPageRoute:
        List<RecentConginmentResponse> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewAllConsignmentsView(recentConsignmentList: args),
          ),
        );

      case addExpensesPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ExpensesMobileView(),
          ),
        );

      case viewExpensesPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewExpensesView(),
          ),
        );

      case viewExpensesDetailedViewPageRoute:
        Map<String, dynamic> args = settings.arguments;
        // List<ViewExpensesResponse> args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewExpensesDetailedView(
              arguments: args,
            ),
          ),
        );

      case allotConsignmentsPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ConsignmentAllotmentView(),
          ),
        );

      case viewRoutesPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewRoutesView(),
          ),
        );
      case distributorsLogPageRoute:
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: DistributorsScreenView(),
                ) //ViewEntryView(),
            );

      case viewConsignmentsPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewConsignmentView(),
          ),
        );

      case addEntry2PointOFormViewPageRoute:
        AddEntryArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: AddVehicleEntryFormView(arguments: args),
          ),
        );

      case paymentsPageRoute:
        return MaterialPageRoute(
          builder: (_) => PaymentsView(),
        );

      case hubsViewPageRoute:
        ViewRoutesArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: HubsView(
              selectedRoute: args.clickedRoute,
            ),
          ),
        );

      case consignmentsListPageRoute:
        ConsignmentListArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ConsignmentListView(
              duration: args.duration,
              clientId: args.clientId,
              isFulPageView: args.isFulPageView,
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Please define page for  ${settings.name}'),
            ),
          ),
        );
    }
  }
}
