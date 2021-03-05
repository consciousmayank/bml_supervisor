import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:dio/dio.dart';

class ParentApiResponse {
  final String badCredentials = 'Bad Credentials.';
  final String noResourceFound = 'Resource does not exist.';
  final String serverBusy = 'Server is busy. Please try again';
  final String defaultError = 'Something went wrong.';
  final String emptyResult = 'No Records Found.';
  final String notAuthorised = 'You are not authorised.';
  final String noInternet =
      'You are not connected to Internet. Please Try Again.';

  final DioError error;
  final Response response;

  ParentApiResponse({this.error, this.response});

  bool isNoDataFound() {
    return response.statusCode == 204;
  }

  String getErrorReason() {
    if (this.error.response == null) {
      return this.error.message;
    } else {
      switch (this.error.response.statusCode) {
        case 100:
          return noInternet;
          break;
        case 204:
          return emptyResult;
          break;
        case 401:
          return badCredentials;
          break;
        case 403:
          return notAuthorised;
          break;
        case 404:
          return noResourceFound;
        case 500:
          return serverBusy;
          break;
        case 400:
          ApiResponse response = ApiResponse.fromMap(this.error.response.data);
          return response.message;
        default:
          return defaultError;
      }
    }
  }
}
