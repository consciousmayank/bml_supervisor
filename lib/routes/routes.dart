import 'package:bml_supervisor/app_level/network_sensitive_screen.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/adddriver/add_driver_view.dart';
import 'package:bml_supervisor/screens/addhubs/add_hubs_view.dart';
import 'package:bml_supervisor/screens/addroutes/add_routes/add_routes_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/add_routes/add_routes_view.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_view.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_view.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_arguments.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_form_view.dart';
import 'package:bml_supervisor/screens/addvehicledailyentry/add_entry_logs_view.dart';
import 'package:bml_supervisor/screens/clientselect/client_select_view.dart';
import 'package:bml_supervisor/screens/consignments/allot/consignement_allotment_view.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_view.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_arguments.dart';
import 'package:bml_supervisor/screens/consignments/list/consignment_list_view.dart';
import 'package:bml_supervisor/screens/consignments/listbydate/consignment_list_by_date_view.dart';
import 'package:bml_supervisor/screens/consignments/pendinglist/pending_consignments_list_view.dart';
import 'package:bml_supervisor/screens/consignments/review/review_consignment_args.dart';
import 'package:bml_supervisor/screens/consignments/review/view_consigment_view.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_view.dart';
import 'package:bml_supervisor/screens/dashboard/view_all_consignments_view.dart';
import 'package:bml_supervisor/screens/distributors/distributors_view.dart';
import 'package:bml_supervisor/screens/expenses/add/expenses_mobile_view.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_detailed_view.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_view.dart';
import 'package:bml_supervisor/screens/login/login_view.dart';
import 'package:bml_supervisor/screens/payments/payment_args.dart';
import 'package:bml_supervisor/screens/payments/payments_view.dart';
import 'package:bml_supervisor/screens/profile/changepassword/changepassword_view.dart';
import 'package:bml_supervisor/screens/profile/userprofile/userprofile_view.dart';
import 'package:bml_supervisor/screens/search/search_view.dart';
import 'package:bml_supervisor/screens/splash/splash_screen.dart';
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

      case clientSelectPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ClientSelectView(),
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
                ));

      case viewEntryLogPageRoute:
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: ViewVehicleEntryView(),
                ));

      case pickHubsPageRoute:
        PickHubsArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: PickHubsView(
                    args: args,
                  ),
                ));

      case consignmentDetailsPageRoute:
        ConsignmentDetailsArgument args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              NetworkSensitive(child: ConsignmentDetailsView(args: args)),
        );

        case consignmentListByDatePageRoute:
        // ConsignmentDetailsArgument args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              NetworkSensitive(child: ConsignmentListByDateView()),
        );



      case arrangeHubsPageRoute:
        ArrangeHubsArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
              child: ArrangeHubsView(
            args: args,
          )),
        );

      case addHubRoute:
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: AddHubsView(),
                ) //EntryLogsView(),
            );

      case addRoutesPageRoute:
        AddRoutesArguments args = settings.arguments;
        List<GetDistributorsResponse> newHubsList = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => NetworkSensitive(
                  child: AddRoutesView(
                    args: args,
                  ),
                ));

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

      case userProfileRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: UserProfileView(),
          ),
        );

      case changePasswordRoute:
        return MaterialPageRoute(
          builder: (_) => ChangePasswordView(),
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
        ReviewConsignmentArgs reviewConsignmentArgs = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: ViewConsignmentView(
              reviewConsignmentArgs: reviewConsignmentArgs,
            ),
          ),
        );

      case pendingConsignmentsListPageRoute:
        return MaterialPageRoute(
          builder: (_) => NetworkSensitive(
            child: PendingConsignmentsListView(),
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
        PaymentArgs _paymentArgs = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              NetworkSensitive(child: PaymentsView(args: _paymentArgs)),
        );

      case addDriverPageRoute:
        return MaterialPageRoute(
          builder: (_) => AddDriverView(),
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
