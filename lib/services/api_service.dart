import 'dart:convert';

import 'package:bml_supervisor/app_level/configuration.dart';
import 'package:bml_supervisor/app_level/dio_client.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/utils/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';

class ApiService {
  final dioClient = locator<DioConfig>();
  final preferences = locator<MyPreferences>();

  Future<Response> search({String registrationNumber}) async {
    Response response;
    try {
      response =
          await dioClient.getDio().get('$SEARCH_BY_REG_NO$registrationNumber');
    } on DioError catch (e) {
      throw e;
    }
    return response;
  }

  Future getEntryLogForDate(String registrationNumber, String date) async {
    Response response;
    try {
      response = await dioClient
          .getDio()
          .get('$FIND_LAST_ENTRY_BY_DATE$registrationNumber');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

// Added by Vikas
  Future<Response> vehicleEntrySearch({
    String registrationNumber,
    int duration,
  }) async {
    Response response;
    try {
      print(
          'http://192.168.0.150:8080/bookmyloading/api/vehicle/entrylog/view/$registrationNumber/$duration');
      // URL is subject to change -
      response = await Dio().get(
          'http://192.168.0.150:8080/bookmyloading/api/vehicle/entrylog/view/$registrationNumber/$duration');
    } on DioError catch (e) {
      throw e;
    }
    return response;
  }

  Future submitVehicleEntry(EntryLog entryLogRequest) async {
    Response response;
    final request = {
      "vehicleId": entryLogRequest.vehicleId,
      "entryDate": entryLogRequest.entryDate,
      "startReading": entryLogRequest.startReading,
      "endReading": entryLogRequest.endReading,
      "drivenKm": entryLogRequest.drivenKm,
      "fuelLtr": entryLogRequest.fuelLtr,
      "fuelMeterReading": entryLogRequest.fuelMeterReading,
      "ratePerLtr": entryLogRequest.ratePerLtr,
      "amountPaid": entryLogRequest.amountPaid,
      "drivenKmG": entryLogRequest.drivenKmGround,
      "startReadingG": entryLogRequest.startReadingGround,
      "trips": entryLogRequest.trips,
      "loginTime": "${entryLogRequest.loginTime}:00",
      "logoutTime": "${entryLogRequest.logoutTime}:00",
      "remarks": entryLogRequest.remarks,
      "status": entryLogRequest.status
    };
    String body = json.encode(request);
    try {
      response = await dioClient.getDio().post(SUMBIT_ENTRY, data: body);
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getEntriesFor(
      {@required String regNo,
      @required String fromDate,
      @required String toDate,
      @required String page}) async {
    Response response;

    try {
      response = await dioClient
          .getDio()
          .get(GET_ENTRIES_BTW_DATES(regNo, fromDate, toDate, page));
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future addExpense({SaveExpenseRequest request}) async {
    String body = request.toJson();
    Response response;
    try {
      response = await dioClient.getDio().post(ADD_EXPENSE, data: body);
    } on DioError catch (e) {
      return e.toString();
    }
    return response;
  }

  Future getExpensesList(
      {String regNo, String dateFrom, int pageNumber, String toDate}) async {
    Response response;
    try {
      print('${GET_EXPENSES_LIST(regNo, dateFrom, toDate, pageNumber)}');
      response = await dioClient.getDio().get(
            GET_EXPENSES_LIST(regNo, dateFrom, toDate, pageNumber),
          );
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getRoutesForClient() async {
    Response response;
    try {
      response = await dioClient.getDio().get(
            "$GET_ROUTES_FOR_CLIENT_ID$clientId",
            options: buildCacheOptions(Duration(days: 1)),
          );
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getHubData(int hubId) async {
    Response response;
    try {
      response = await dioClient.getDio().get(
            "$GET_HUB_DATA$hubId",
            options: buildCacheOptions(Duration(days: 1)),
          );
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }
}
