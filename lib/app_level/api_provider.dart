import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  // Rest Url used in Production : "http://bookmyloading.com/api";
  // mr Rawat's laptop url : "http://192.168.0.148:8080/bmlapp/api";
  // local server :  "http://192.168.0.193:8080/api";

  final String _baseUrl = "http://bookmyloading.com/api";
  Map<String, String> headers = {
    "X-Requested-With": "XmlHttpRequest",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "*",
    // Required for CORS support to work
    "Access-Control-Allow-Credentials": 'true',
  };

  Future<ParentApiResponse> get(String url) async {
    var responseJson;
    var error;
    try {
      final response = await http.get(_baseUrl + url, headers: getHeaders());
      responseJson = _response(response);
    } on SocketException {
      error = FetchDataException('No Internet connection');
    }
    return ParentApiResponse(response: responseJson, error: error);
  }

  Future<ParentApiResponse> post(String url, Map body) async {
    var responseJson;
    var error;
    try {
      final response =
          await http.post(_baseUrl + url, headers: getHeaders(), body: body);
      responseJson = _response(response);
    } on SocketException {
      error = FetchDataException('No Internet connection');
    }
    return ParentApiResponse(response: responseJson, error: error);
  }

  Future<ParentApiResponse> put(String url, Map body) async {
    var responseJson;
    var error;
    try {
      final response =
          await http.put(_baseUrl + url, headers: getHeaders(), body: body);
      responseJson = _response(response);
    } on SocketException {
      error = FetchDataException('No Internet connection');
    }
    return ParentApiResponse(response: responseJson, error: error);
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print('inside 200');
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Map<String, String> getHeaders() {
    String credentials = MyPreferences().getCredentials();
    if (credentials.length > 0) {
      headers.addAll(getAuthHeader(base64String: credentials));
    } else {
      headers.remove("Authorization");
    }

    return headers;
  }

  Map<String, String> updateHeaders() {
    String credentials = MyPreferences().getCredentials();
    if (credentials.length > 0) {
      headers.addAll(getAuthHeader(base64String: credentials));
    } else {
      headers.remove("Authorization");
    }

    return headers;
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;
  final _statusCode;

  get statusCode => _statusCode;

  get message => _message;

  CustomException([this._message, this._prefix, this._statusCode]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message, int code])
      : super(message, "Error During Communication: ", code);
}

class BadRequestException extends CustomException {
  BadRequestException([message, int code])
      : super(message, "Invalid Request: ", code);
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message, int code])
      : super(message, "Unauthorised: ", code);
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message, int code])
      : super(message, "Invalid Input: ", code);
}
