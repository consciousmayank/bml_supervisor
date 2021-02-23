import 'package:bml_supervisor/screens/consignments/allot/consignment_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/login/login_apis.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import 'dio_client.dart';

final locator = GetIt.instance;

void declareDependencies() {
//A lazy Singleton will create the object on the first instance when it is
  // called. This is useful when you have a service that takes time to start
  // and should only start when it is needed.
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
  // locator.registerLazySingleton(() => MyPreferences());
  locator.registerLazySingleton(() => DioConfig());
  locator.registerLazySingleton(() => DashBoardApisImpl());
  locator.registerLazySingleton(() => ConsignmentApisImpl());
  locator.registerLazySingleton(() => LoginApisImpl());
  locator.registerLazySingleton(() => ApiService());

  //A Factory will return a new instance of the service anytime it is called.
  // locator.registerFactory(() => DashBoardApisImpl());
  // locator.registerFactory(() => LoginApisImpl());
  // locator.registerFactory(() => DioConfig());
  // locator.registerFactory(() => ApiService());
//  locator.registerFactory(() => GraphQlConfig());

  //A singleton will always return the same instance of that service.
//  locator.registerSingleton<MyPreferences>(MyPreferences(), signalsReady: true);
}
