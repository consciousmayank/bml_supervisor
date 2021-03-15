import 'dart:convert';

import 'package:bml_supervisor/app_level/dio_client.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/app_versioning_request.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/models/view_entry_request.dart';
import 'package:bml_supervisor/utils/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final dioClient = locator<DioConfig>();
  final preferences = MyPreferences();

  /////////////////////////Post Security/////////////////////////

  ///Authorization, get the user role, first name, last name
  Future<ParentApiResponse> login({@required String base64string}) async {
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
  Future<ParentApiResponse> getDashboardTilesStats(
      {@required String clientId}) async {
    // dashboard client specific tiles data api
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_DASHBOARD_TILES(clientId));
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

  Future<ParentApiResponse> getDailyDrivenKm(
      {String client, int period}) async {
    // dashboard bar graph
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(GET_DAILY_DRIVEN_KMS_BAR_CHART(client, period));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getRoutesDrivenKm(
      {@required String clientId, @required int period}) async {
    // dashboard line chart api
    Response response;
    DioError error;
    try {
      response =
          await dioClient.getDio().get(GET_ROUTES_DRIVEN_KM(clientId, period));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getRoutesDrivenKmPercentage(
      {String clientId, int period}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(GET_ROUTES_DRIVEN_KM_PERCENTAGE(clientId, period));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get Daily Kilometers depending on ViewEntryRequest
  ///vehicleId, clientId, period, are the options that can be sent
  Future<ParentApiResponse> getDailyEntries(
      {ViewEntryRequest viewEntryRequest}) async {
    String body = viewEntryRequest.toJson();
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post(GET_DAILY_ENTRIES, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get the list of consignments for a particular client and date.
  Future<ParentApiResponse> getConsignmentListWithDate(
      {@required String entryDate, @required String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(GET_CONSIGNMENT_LIST_FOR_A_CLIENT_AND_DATE(clientId, entryDate));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get the Consignment details with the help of consignmentId.
  Future<ParentApiResponse> getConsignmentWithId({String consignmentId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(GET_CONSIGNMENT_LIST_BY_ID(consignmentId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Update a consignment, after re-view.
  Future<ParentApiResponse> updateConsignment(
      {int consignmentId, ReviewConsignmentRequest putRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().put(
            GET_CONSIGNMENT_LIST_BY_ID(consignmentId),
            data: putRequest.toMap(),
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getPaymentHistory(
      {@required String clientId, @required int pageNumber}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(GET_PAYMENT_HISTORY(clientId, pageNumber));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> addNewPayment(
      {@required SavePaymentRequest request}) async {
    String body = request.toJson();
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post('/payment/add', data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getExpensesList({
    String registrationNumber,
    String duration,
    String clientId,
  }) async {
    Response response;
    DioError error;
    try {
      var request = new Map();
      if (registrationNumber != null) {
        request['vehicleId'] = registrationNumber;
      }
      if (duration != null) {
        request['period'] = duration;
      }
      if (clientId != null) {
        request['clientId'] = clientId;
      }

      String body = json.encode(request);
      response = await dioClient.getDio().post(
            GET_EXPENSES_LIST,
            data: body,
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Add expense for a client.
  Future<ParentApiResponse> addExpense({SaveExpenseRequest request}) async {
    String body = request.toJson();
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post(ADD_EXPENSE, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getDailyKmInfo({@required String date}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_DAILY_KM_INFO(date));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getDistributors({@required String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_DISTRIBUTORS(clientId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> changePassword(
      {@required String userName, @required String newPassword}) async {
    Response response;
    DioError error;
    try {
      var request = {"username": userName, "password": newPassword};
      String body = json.encode(request);
      response = await dioClient.getDio().post(CHANGE_PASSWORD, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> getAppVersions(
      {AppVersioningRequest request}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(GET_APP_VERSION, data: request.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  ///Get list of cities for adding driver.
  Future<ParentApiResponse> getCities() async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_CITIES);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  ///Get details of a city selected.
  Future<ParentApiResponse> getCityLocation({@required String cityId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(GET_CITY_LOCATION(cityId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> addDriver(
      {@required AddDriverRequest request}) async {
    Response response;
    DioError error;
    try {
      response =
          await dioClient.getDio().post(ADD_DRIVER, data: request.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
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
          await dioClient.getDio().get('/vehicle/view/$registrationNumber');
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
