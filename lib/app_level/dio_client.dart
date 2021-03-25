import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/api_endpoints.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'configuration.dart';

class DioConfig {
  final _dio = Dio();

  DioConfig() {
    configureDio();
  }

  Interceptor get element => Interceptor();

  configureDio() {
    _dio.options
      ..baseUrl = kReleaseMode ? baseRestUrlProduction : baseRestUrlProduction
      ..contentType = "application/json";
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) => requestInterceptor(options),
        onResponse: (Response response) => responseInterceptor(response),
        onError: (DioError dioError) => errorInterceptor(dioError)));
  }

  dynamic requestInterceptor(RequestOptions options) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      String credentials = MyPreferences().getCredentials();
      if (options.path != GET_APP_VERSION) {
        options.headers.addAll(getAuthHeader(base64String: credentials));
      }
      return options;
    }
  }

  dynamic responseInterceptor(Response options) async {
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("${options.request.baseUrl}${options.request.path}");
    print("${options.data.toString()}");
    print('${options.request.method}');
    print('${options.request.headers.toString()}');
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return options;
    // if (options.headers.value("verifyToken") != null) {
    //   //if the header is present, then compare it with the Shared Prefs key
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var verifyToken = prefs.get("VerifyToken");
    //
    //   // if the value is the same as the header, continue with the request
    //   if (options.headers.value("verifyToken") == verifyToken) {
    //     return options;
    //   }
    // }
    //
    // return DioError(
    //     request: options.request, message: "User is no longer active");
  }

  dynamic errorInterceptor(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        // TODO: Handle this case.
        break;
      case DioErrorType.SEND_TIMEOUT:
        // TODO: Handle this case.
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        // TODO: Handle this case.
        break;
      case DioErrorType.RESPONSE:
        break;
      case DioErrorType.CANCEL:
        // TODO: Handle this case.
        break;
      case DioErrorType.DEFAULT:
        if (dioError.error.message == 'Connection failed') {
          return DioError(response: Response(statusCode: 100));
        } else {
          return DioError(response: Response(statusCode: 700));
        }
        break;
    }

    return dioError;
  }

  Dio getDio() {
    return _dio;
  }
}
