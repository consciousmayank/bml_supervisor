import 'dart:convert';

import 'package:bml_supervisor/app_level/dio_client.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/models/view_entry_request.dart';
import 'package:bml_supervisor/utils/api_endpoints.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final dioClient = locator<DioConfig>();
  final preferences = MyPreferences();

  /////////////////////////Post Security/////////////////////////

  ///Authorization, get the user role, first name, last name
  Future<ParentApiResponse> login({@required String base64string}) async {
    dioClient.addHeaders(getAuthHeader(base64String: base64string));
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post(LOGIN);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get dashboard Tiles Data.
  Future<ParentApiResponse> getDashboardTilesStats() async {
    // dashboard client specific tiles data api
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_DASHBOARD_TILES);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get the list of clients which logged in user/manager are allotted/can handle
  Future<ParentApiResponse> getClientsList() async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_CLIENTS);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get All the routes for the selected client
  Future<ParentApiResponse> getRoutesForClientId(
      {@required String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(
            "$GET_ROUTES_FOR_CLIENT_ID_new$clientId/page/1",
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get all the hubs for selected RouteId
  Future<ParentApiResponse> getHubsList({
    @required int routeId,
  }) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_HUBS(routeId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get vehicle details to show in
  ///1. Allot Consignment
  ///
  /// By sending registrationNumber
  Future<ParentApiResponse> getVehicleDetails(String registrationNumber) async {
    Response response;
    DioError error;
    try {
      response =
          await dioClient.getDio().get('/vehicle/view/$registrationNumber');
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Create a new Consignment
  Future<ParentApiResponse> createConsignment(
      {@required CreateConsignmentRequest request}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(ADD_CONSIGNMENT_DATA_TO_HUB, data: request.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getRoutesForSelectedClientAndDate({
    @required String clientId,
    @required String date,
  }) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(
            GET_ROUTES_FOR_CLIENT_AND_DATE(clientId, date),
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getLatestDailyEntry(
      {@required String registrationNumber}) async {
    Response _response;
    DioError _error;
    try {
      _response = await dioClient
          .getDio()
          .get(FIND_LAST_ENTRY_BY_DATE(registrationNumber));
    } on DioError catch (e) {
      _error = e;
    }
    return ParentApiResponse(error: _error, response: _response);
  }

  Future<ParentApiResponse> submitVehicleEntry({
    @required EntryLog entryLogRequest,
  }) async {
    Response response;
    DioError error;
    final request = {
      "routeId": entryLogRequest.routeId,
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
    try {
      response = await dioClient.getDio().post(SUMBIT_ENTRY, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ////////////////////////////////////////////////////////////////

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

  // Added by Vikas

  Future searchByRegistrationNumber(String registrationNumber) async {
    Response response;
    try {
      response =
          await dioClient.getDio().get('/vehicle/find/$registrationNumber');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getRoutesDrivenKm({int clientId, int period}) async {
    // dashboard line chart api
    Response response;
    try {
      response = await dioClient.getDio().get(
          '/vehicle/entrylog/route/drivenKm/client/$clientId/period/$period');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getRoutesDrivenKmPercentage({int clientId, int period}) async {
    Response response;
    try {
      response = await dioClient.getDio().get(
          '/vehicle/entrylog/consignment/view/aggregate/client/$clientId/period/$period');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getRecentConsignments({int clientId, int period}) async {
    // dashboard recent consignment table
    Response response;
    try {
      response = await dioClient
          .getDio()
          .get('/vehicle/entrylog/consignment/view/client/$clientId');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getTotalDrivenKmStats({int client, int period}) async {
    // dashboard bar graph
    Response response;
    try {
      response = await dioClient
          .getDio()
          .get('/vehicle/entrylog/drivenKm/client/$client/period/$period');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getPaymentHistory(
      {@required String clientId, @required int pageNumber}) async {
    Response response;
    try {
      response = await dioClient
          .getDio()
          .get(GET_PAYMENT_HISTORY(clientId, pageNumber));
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future addNewPayment(SavePaymentRequest request) async {
    String body = request.toJson();
    Response response;
    try {
      response = await dioClient.getDio().post('/payment/add', data: body);
    } on DioError catch (e) {
      return e.toString();
    }
    return response;
  }

// Added by Vikas
//! Not in use anymore, replaced by the POST version - vehicleEntrySearch2PointO()
  // Future<Response> vehicleEntrySearch({
  //   String regNum,
  //   String clientId,
  //   int duration,
  // }) async {
  //   Response response;
  //   print('client id before api call: $clientId');
  //   try {
  //     if (regNum.length != 0 && clientId.length != 0) {
  //       response = await dioClient.getDio().get(
  //           '$VIEW_ENTRY/vehicle/$regNum/client/$clientId/period/$duration');
  //       regNum = '';
  //     } else if (regNum.length != 0 && clientId.length == 0) {
  //       response = await dioClient
  //           .getDio()
  //           .get('$VIEW_ENTRY/vehicle/$regNum/period/$duration');
  //       regNum = '';
  //     } else if (regNum.length == 0 && clientId.length != 0) {
  //       response = await dioClient
  //           .getDio()
  //           .get('$VIEW_ENTRY/client/$clientId/period/$duration');
  //     } else {
  //       response = await dioClient.getDio().get('$VIEW_ENTRY/period/$duration');
  //     }
  //   } on DioError catch (e) {
  //     throw e;
  //   }
  //   return response;
  // }

  Future vehicleEntrySearch2PointO({ViewEntryRequest viewEntryRequest}) async {
    String body = viewEntryRequest.toJson();
    Response response;
    try {
      response =
          await dioClient.getDio().post('/vehicle/entrylog/view', data: body);
    } on DioError catch (e) {
      return e.toString();
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

  Future getExpensesList({
    String registrationNumber,
    String duration,
    String clientId,
  }) async {
    Response response;
    // print('reg num is api' + regNo);
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
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  // Future getRoutesForClient({int clientId}) async {
  //   Response response;
  //   try {
  //     response = await dioClient.getDio().get(
  //           "$GET_ROUTES_FOR_CLIENT_ID$clientId/page/1",
  //         );
  //   } on DioError catch (e) {
  //     return e.message;
  //   }
  //   return response;
  // }

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

  Future updateConsignment(
      {int consignmentId, ReviewConsignmentRequest putRequest}) async {
    Response response;
    print('in api service');
    print(putRequest.assessBy);
    putRequest.reviewedItems.forEach((element) {
      print('dropOff: ${element.dropOff}');
      print('collect: ${element.collect}');
      print('payment: ${element.payment}');
    });
    print('api call /api/consignment/$consignmentId');
    try {
      response = await dioClient.getDio().put(
            '/consignment/$consignmentId',
            data: putRequest.toMap(),
          );
    } on DioError catch (e) {
      return e.message;
    }
    print(response);
    return response;
  }

  // Future getConsignmentsList(
  //     {@required int routeId,
  //     @required int clientId,
  //     @required String entryDate}) async {
  //   Response response;
  //   try {
  //     response = await dioClient.getDio().get(
  //         GET_CONSIGNMENT_FOR_CLIENT_AND_DATE(clientId, routeId, entryDate));
  //   } on DioError catch (e) {
  //     return e.message;
  //   }
  //   return response;
  // }

  Future getConsignmentListWithDate({String entryDate}) async {
    Response response;
    print('api call - /client/consignment/list/date/$entryDate');
    try {
      response = await dioClient
          .getDio()
          .get('/client/consignment/list/date/$entryDate');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getConsignmentWithId({String consignmentId}) async {
    Response response;
    print('api call - /client/consignment/$consignmentId');
    try {
      response =
          await dioClient.getDio().get('/client/consignment/$consignmentId');
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getHubs({int routeId}) async {
    Response response;
    try {
      response = await dioClient.getDio().get("$GET_HUBS$routeId");
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getHubsForRouteAndClientId({
    @required int routeId,
  }) async {
    Response response;
    try {
      response = await dioClient.getDio().get("$GET_HUBS$routeId");
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }

  Future getClientDashboardStats(PreferencesSavedUser user) async {
    // dashboard client specific tiles data api
    Response response;
    try {
      response = await dioClient.getDio().get(GET_DASHBOARD_STATS(user));
    } on DioError catch (e) {
      return e.message;
    }
    print(response);
    return response;
  }
}
