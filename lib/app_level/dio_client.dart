import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/api_endpoints.dart';

class DioConfig {
  final String baseUrl;
  DioConfig({@required this.baseUrl}) {
    configureDio();
  }

  final _dio = Dio();

  Interceptor get element => Interceptor();

  configureDio() {
    _dio.options
      ..baseUrl = baseUrl
      ..contentType = "application/json";
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) => requestInterceptor(options),
        // onResponse: (Response response) => responseInterceptor(response),
        onError: (DioError dioError) => errorInterceptor(dioError),
      ),
    );
  }

  dynamic requestInterceptor(RequestOptions options) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      String credentials = MyPreferences().getCredentials();
      if (options.path == SEND_PUSH_NOTIFICATIONS) {
        options.baseUrl = SEND_PUSH_NOTIFICATIONS;
        options.headers.addAll({
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAdlTzGIA:APA91bFrQTLgLUYFm150wohKKdbkhjvoblPb9vb1TsyltT6uX78B_k_nLE1ubyOmEZGIH6KS7j5qIfMrktq9eafafkV-Mkyz4Ps3_6JoCpBBAEan7MCLkCRutTGkUZjd9vg5ae0hAESc"
        });
      } else if (options.path != GET_APP_VERSION) {
        options.headers.addAll(getAuthHeader(base64String: credentials));
      }
      return options;
    }
  }

  dynamic responseInterceptor(Response options) async {
    return options;
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
