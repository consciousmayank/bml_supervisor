import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:dio/dio.dart';

import 'configuration.dart';
import 'locator.dart';

class DioConfig {
  MyPreferences preferences = locator.get<MyPreferences>();
  // Alice alice = Alice(showNotification: true);
  final _dio = Dio();

  DioConfig() {
    configureDio();
  }

  configureDio() async {
    // alice.setNavigatorKey(locator<NavigationService>().navigatorKey);
    _dio.options
      ..baseUrl = baseRestUrl
      ..contentType = "application/json";

    // _dio.interceptors.add(alice.getDioInterceptor());
  }

  Dio getDio() {
    return _dio;
  }
}
