import 'package:alice/alice.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:stacked_services/stacked_services.dart';

import 'configuration.dart';
import 'locator.dart';

class DioConfig {
  MyPreferences preferences = locator.get<MyPreferences>();
  Alice alice = Alice(showNotification: true);
  final _dio = Dio();

  DioConfig() {
    configureDio();
  }

  configureDio() async {
    alice.setNavigatorKey(locator<NavigationService>().navigatorKey);
    _dio.options
      ..baseUrl = baseRestUrlProduction
      // ..baseUrl = baseRestUrl
      ..contentType = "application/json";
    _dio.interceptors.add(alice.getDioInterceptor());
    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseRestUrl)).interceptor);
  }

  Dio getDio() {
    return _dio;
  }
}
