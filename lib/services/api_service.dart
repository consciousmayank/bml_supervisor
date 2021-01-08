import 'dart:convert';

import 'package:bml_supervisor/app_level/configuration.dart';
import 'package:bml_supervisor/app_level/dio_client.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/add_consignment_request.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/utils/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final dioClient = locator<DioConfig>();
  final preferences = locator<MyPreferences>();

  Future<Response> search({String registrationNumber}) async {
    Response response;
    try {
      print('$SEARCH_BY_REG_NO$registrationNumber');
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

  Future searchByRegistrationNumber(String registrationNumber) async {
    Response response;
    try {
      response =
          await dioClient.getDio().get('/vehicle/find/$registrationNumber');
    } on DioError catch (e) {
      return e.message;
    }
    // print(response);
    return response;
  }

// Added by Vikas
  Future<Response> vehicleEntrySearch({
    String regNum,
    String clientId,
    int duration,
  }) async {
    Response response;
    print('client id before api call: $clientId');
    try {
      if (regNum.length != 0 && clientId.length != 0) {
        print(
            'view_entry_api=====$VIEW_ENTRY/vehicle/$regNum/client/$clientId/period/$duration');
        response = await dioClient.getDio().get(
            '$VIEW_ENTRY/vehicle/$regNum/client/$clientId/period/$duration');
        regNum = '';
      } else if (regNum.length != 0 && clientId.length == 0) {
        print('api_service: $VIEW_ENTRY/vehicle/$regNum/period/$duration');
        response = await dioClient
            .getDio()
            .get('$VIEW_ENTRY/vehicle/$regNum/period/$duration');
        regNum = '';
      } else if (regNum.length == 0 && clientId.length != 0) {
        print('api_service: $VIEW_ENTRY/client/$clientId/period/$duration');
        response = await dioClient
            .getDio()
            .get('$VIEW_ENTRY/client/$clientId/period/$duration');
      } else {
        print('api_service: $VIEW_ENTRY/period/$duration');
        response = await dioClient.getDio().get('$VIEW_ENTRY/period/$duration');
      }
    } on DioError catch (e) {
      throw e;
    }
    return response;
  }

  Future submitVehicleEntry(EntryLog entryLogRequest) async {
    Response response;
    final request = {
      "clientId": entryLogRequest.clientId,
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
    print('entry in api_service========$body');

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
    print('add expense in api_servie=========: ' + body);

    Response response;
    try {
      response = await dioClient.getDio().post(ADD_EXPENSE, data: body);
    } on DioError catch (e) {
      return e.toString();
    }
    print(response);
    return response;
  }

  Future getExpensesList({
    String registrationNumber,
    String duration,
    String clientId,
  }) async {
    Response response;
    // print('reg num is api' + regNo);
    print('api_service: regNu-$registrationNumber clientId-$clientId');
    try {
      //!start
      if (registrationNumber.length != 0 && clientId.length != 0) {
        print(
            'api v + c + d: /expenses/view/vehicle/$registrationNumber/client/$clientId/period/$duration');
        response = await dioClient.getDio().get(
            '/expenses/view/vehicle/$registrationNumber/client/$clientId/period/$duration');
        registrationNumber = '';
      } else if (registrationNumber.length != 0 && clientId.length == 0) {
        print(
            'api v + d: /expenses/view/vehicle/$registrationNumber/period/$duration');
        response = await dioClient
            .getDio()
            .get('/expenses/view/vehicle/$registrationNumber/period/$duration');
        registrationNumber = '';
      } else if (registrationNumber.length == 0 && clientId.length != 0) {
        print('api c + d: /expenses/view/client/$clientId/period/$duration');
        response = await dioClient
            .getDio()
            .get('/expenses/view/client/$clientId/period/$duration');
      } else {
        print('api d : /expenses/view/period/$duration');
        response =
            await dioClient.getDio().get('/expenses/view/period/$duration');
      }
      //!end
      // print('${GET_EXPENSES_LIST(regNo, dateFrom, toDate, pageNumber)}');
      // if (registrationNumber != null) {
      //   print('/vehicle/expenses/find/$registrationNumber/period/$duration');

      //   response = await dioClient
      //       .getDio()
      //       .get('/vehicle/expenses/find/$registrationNumber/period/$duration');
      // } else {
      //   print('/expenses/view/period/$duration');

      //   response =
      //       await dioClient.getDio().get('/expenses/view/period/$duration');
      // }
      // response = await dioClient.getDio().get(
      //       GET_EXPENSES_LIST(regNo, dateFrom, toDate, pageNumber),
      //     );
    } on DioError catch (e) {
      return e.message;
    }
    print('expense list: ' + response.toString());
    return response;
  }

  Future getClientsList() async {
    Response response;
    try {
      print('calling this api: $GET_CLIENTS');
      response = await dioClient.getDio().get('$GET_CLIENTS');
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
          );
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future addConsignmentDataToHub(AddConsignmentRequest request) async {
    Response response;
    try {
      response = await dioClient
          .getDio()
          .post(ADD_CONSIGNMENT_DATA_TO_HUB, data: request.toJson());
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getConsignmentsList(
      {@required int routeId, @required String hubId}) async {
    Response response;
    try {
      response =
          await dioClient.getDio().get("$GET_CONSIGNMENTS_LIST$routeId/$hubId");
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }
}
