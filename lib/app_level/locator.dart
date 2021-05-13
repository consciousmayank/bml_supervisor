import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/screens/addhubs/add_hubs_apis.dart';
import 'package:bml_supervisor/screens/addroutes/add_routes_apis.dart';
import 'package:bml_supervisor/screens/charts/charts_api.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/screens/dailykms/daily_entry_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/expenses/expenses_api.dart';
import 'package:bml_supervisor/screens/login/login_apis.dart';
import 'package:bml_supervisor/screens/payments/payments_apis.dart';
import 'package:bml_supervisor/screens/profile/profile_apis.dart';
import 'package:bml_supervisor/screens/splash/app_start_apis.dart';
import 'package:bml_supervisor/screens/trips/trips_apis.dart';
import 'package:bml_supervisor/screens/vehicle/vehicle_apis.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bml/bml.dart';

final locator = GetIt.instance;

Future declareDependencies() async {
  SharedPreferencesService sharedPreferences =
      await SharedPreferencesService.getInstance();
  locator.registerSingleton(sharedPreferences);
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => DriverApisImpl());
  locator.registerLazySingleton(() => DioConfig());
  locator.registerLazySingleton(() => DashBoardApisImpl());
  locator.registerLazySingleton(() => ConsignmentApisImpl());
  locator.registerLazySingleton(() => DailyEntryApisImpl());
  locator.registerLazySingleton(() => ChartsApiImpl());
  locator.registerLazySingleton(() => ProfileApisImpl());
  locator.registerLazySingleton(() => AppStartApiImpl());
  locator.registerLazySingleton(() => PaymentsApisImpl());
  locator.registerLazySingleton(() => ExpensesApisImpl());
  locator.registerLazySingleton(() => LoginApisImpl());
  locator.registerLazySingleton(() => AddHubApisImpl());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AddRouteApisImpl());
  locator.registerLazySingleton(() => TripsApisImpl());
  locator.registerLazySingleton(() => VehicleApisImpl());
  locator.registerSingleton(BottomSheetService());

  //A Factory will return a new instance of the service anytime it is called.
  // locator.registerFactory(() => DashBoardApisImpl());
  // locator.registerFactory(() => LoginApisImpl());
  // locator.registerFactory(() => DioConfig());
  // locator.registerFactory(() => ApiService());
//  locator.registerFactory(() => GraphQlConfig());

  //A singleton will always return the same instance of that service.
//  locator.registerSingleton<MyPreferences>(preferences, signalsReady: true);
}
