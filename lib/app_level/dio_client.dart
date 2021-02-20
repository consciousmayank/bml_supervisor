import 'package:alice/alice.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';
import 'package:stacked_services/stacked_services.dart';

import 'configuration.dart';

class DioConfig {
  Alice alice = Alice(showNotification: true);
  final _dio = Dio();

  DioConfig() {
    configureDio();
  }

  configureDio() {
    String credentials = MyPreferences().getCredentials();

    alice.setNavigatorKey(StackedService.navigatorKey);

    _dio.options
      ..baseUrl = baseSecureUrl
      // ..baseUrl = baseSecureUrlBmlApp
      ..headers =
          credentials.isEmpty ? {} : getAuthHeader(base64String: credentials)
      ..contentType = "application/json";

    _dio.interceptors.add(alice.getDioInterceptor());
  }

  Dio getDio() {
    return _dio;
  }

  void addHeaders(Map<String, String> authHeader) {
    BaseOptions options = _dio.options;
    options.headers = authHeader;
    _dio..options = options;
  }
}
