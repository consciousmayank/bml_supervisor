import 'package:dio/dio.dart';

class ParentApiResponse {
  final String badCredentials = 'Bad Credentials.';
  final String noDataFound = 'There is no data.';
  final String serverBusy = 'Server is busy. Please try again';
  final String defaultError = 'Something went wrong.';

  final DioError error;
  final Response response;

  ParentApiResponse({this.error, this.response});

  String getErrorReason() {
    switch (this.error.response.statusCode) {
      case 401:
        return badCredentials;
        break;
      case 404:
        return noDataFound;
      case 500:
        return serverBusy;
        break;
      default:
        return defaultError;
    }
  }
}
