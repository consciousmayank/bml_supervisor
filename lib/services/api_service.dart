import 'dart:convert';
import 'package:bml/bml.dart';

import 'package:bml_supervisor/app_level/locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService implements ManagerApis {
  final dioClient = locator<DioConfig>();

  /////////////////////////Post Security/////////////////////////

  ///Authorization, get the user role, first name, last name
  Future<ParentApiResponse> login({@required String base64string}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post(BmlManager().LOGIN);
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
      response = await dioClient
          .getDio()
          .get(BmlManager().GET_DASHBOARD_TILES(clientId));
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
      response = await dioClient.getDio().get(BmlManager().GET_CLIENTS);
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
            "${BmlManager().GET_ROUTES_FOR_CLIENT_ID_new}$clientId/page/1",
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
      response = await dioClient.getDio().get(BmlManager().GET_HUBS(routeId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get vehicle details to show in
  ///1. Create Consignment
  ///
  /// By sending registrationNumber
  Future<ParentApiResponse> getVehicleDetails(
      {@required String registrationNumber}) async {
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
  Future createConsignment({@required dynamic request}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post(
          BmlManager().ADD_CONSIGNMENT_DATA_TO_HUB,
          data: request.toJson());
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
            BmlManager().GET_ROUTES_FOR_CLIENT_AND_DATE(clientId, date),
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
          .get(BmlManager().FIND_LAST_ENTRY_BY_DATE(registrationNumber));
    } on DioError catch (e) {
      _error = e;
    }
    return ParentApiResponse(error: _error, response: _response);
  }

  Future getRecentDrivenKm({String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(BmlManager().GET_LAST_SEVEN_ENTRIES(clientId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> submitVehicleEntry({
    @required dynamic entryLogRequest,
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
      "loginTime": entryLogRequest.loginTime,
      "logoutTime": entryLogRequest.logoutTime,
      "remarks": entryLogRequest.remarks,
      "consignmentId": entryLogRequest.consignmentId,
    };
    String body = json.encode(request);
    try {
      response =
          await dioClient.getDio().post(BmlManager().SUMBIT_ENTRY, data: body);
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
          .get(BmlManager().GET_DAILY_DRIVEN_KMS_BAR_CHART(client, period));
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
      response = await dioClient
          .getDio()
          .get(BmlManager().GET_ROUTES_DRIVEN_KM(clientId, period));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getRoutesDrivenKmPercentage(
      {String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(BmlManager().GET_ROUTES_DRIVEN_KM_PERCENTAGE(clientId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get Daily Kilometers depending on ViewEntryRequest
  ///vehicleId, clientId, period, are the options that can be sent
  Future<ParentApiResponse> getDailyEntries(
      {@required dynamic viewEntryRequest}) async {
    String body = viewEntryRequest.toJson();
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(BmlManager().GET_DAILY_ENTRIES, data: body);
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
      response = await dioClient.getDio().get(BmlManager()
          .GET_CONSIGNMENT_LIST_FOR_A_CLIENT_AND_DATE(clientId, entryDate));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getPendingConsignmentsList({
    @required String clientId,
    @required int pageIndex,
  }) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(BmlManager()
          .GET_PENDING_CONSIGNMENTS_LIST_FOR_A_CLIENT(clientId, pageIndex));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getConsignmentListPageWise({
    @required String clientId,
    @required int pageIndex,
  }) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(
          BmlManager().GET_CONSIGNMENT_LIST_PAGE_WISE(clientId, pageIndex));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getRecentConsignmentsForCreateConsignment({
    @required String clientId,
  }) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(BmlManager()
          .GET_RECENT_CONSIGNMENTS_FOR_CREATE_CONSIGNMENT(clientId));
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
          .get(BmlManager().GET_CONSIGNMENT_LIST_BY_ID(consignmentId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Get the Completed Trip details with the help of consignmentId.
  Future<ParentApiResponse> getCompletedTripsWithId(
      {String consignmentId, String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(
            BmlManager().GET_COMPLETED_TRIPS_BY_ID(
              consignmentId,
              clientId,
            ),
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Update a consignment, after re-view.
  Future updateConsignment(
      {@required int consignmentId,
      @required dynamic reviewConsignmentRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().put(
            BmlManager().GET_CONSIGNMENT_LIST_BY_ID(consignmentId),
            data: reviewConsignmentRequest.toMap(),
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
          .get(BmlManager().GET_PAYMENT_HISTORY(clientId, pageNumber));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> addNewPayment(
      {@required dynamic savePaymentRequest}) async {
    String body = savePaymentRequest.toJson();
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
    String clientId,
  }) async {
    Response response;
    DioError error;
    try {
      var request = new Map();
      if (registrationNumber != null) {
        request['vehicleId'] = registrationNumber;
      }
      if (clientId != null) {
        request['clientId'] = clientId;
      }

      String body = json.encode(request);
      response = await dioClient.getDio().post(
            BmlManager().GET_EXPENSES_LIST,
            data: body,
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  ///Add expense for a client.
  Future<ParentApiResponse> addExpense({dynamic saveExpenseRequest}) async {
    String body = saveExpenseRequest.toJson();
    Response response;
    DioError error;
    try {
      response =
          await dioClient.getDio().post(BmlManager().ADD_EXPENSE, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getDailyKmInfo({@required String date}) async {
    Response response;
    DioError error;
    try {
      response =
          await dioClient.getDio().get(BmlManager().GET_DAILY_KM_INFO(date));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }

  Future<ParentApiResponse> getDistributors({@required String clientId}) async {
    Response response;
    DioError error;
    try {
      response =
          await dioClient.getDio().get(BmlManager().GET_DISTRIBUTORS(clientId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> getUserProfile() async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(BmlManager().GET_USER);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future updateUserMobile({dynamic updateUserRequest}) async {
    String body = updateUserRequest.toJson();
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .put(BmlManager().UPDATE_USER_MOBILE, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future updateUserEmail({dynamic updateUserRequest}) async {
    String body = updateUserRequest.toJson();
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .put(BmlManager().UPDATE_USER_EMAIL, data: body);
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
      response = await dioClient
          .getDio()
          .post(BmlManager().CHANGE_PASSWORD, data: body);
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> getAppVersions(
      {dynamic appVersioningRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().post(BmlManager().GET_APP_VERSION,
          data: appVersioningRequest.toJson());
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
      response = await dioClient.getDio().get(BmlManager().GET_CITIES);
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
      response =
          await dioClient.getDio().get(BmlManager().GET_CITY_LOCATION(cityId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> addDriver(
      {@required dynamic addDriverRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(BmlManager().ADD_DRIVER, data: addDriverRequest.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> addRoute(
      {@required dynamic createRouteRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(BmlManager().ADD_ROUTE, data: createRouteRequest.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> addHub({@required dynamic addHubRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(BmlManager().ADD_HUB, data: addHubRequest.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> getExpensesListForPieChartAggregate(
      {String clientId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .get(BmlManager().GET_EXPENSE_PIE_CHART(clientId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  Future<ParentApiResponse> getConsignmentTrackingStatus(
      {String clientId, @required TripStatus tripStatus}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(
            getApiCall(tripStatus: tripStatus, clientId: clientId),
          );
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  String getApiCall(
      {@required TripStatus tripStatus, @required String clientId}) {
    switch (tripStatus) {
      case TripStatus.UPCOMING:
        return BmlManager().GET_UPCOMING_TRIPS_STATUS_LIST(clientId);
        break;
      case TripStatus.ONGOING:
        return BmlManager().GET_ONGOING_TRIPS_STATUS_LIST(clientId);
        break;
      case TripStatus.COMPLETED:
        return BmlManager().GET_COMPLETED_TRIPS_STATUS_LIST(clientId);
        break;
      case TripStatus.APPROVED:
        return BmlManager().GET_APPROVED_TRIPS_STATUS_LIST(clientId);
        break;
      case TripStatus.DISCARDED:
        return BmlManager().GET_DISCARDED_TRIPS_STATUS_LIST(clientId);
        break;
      default:
        return BmlManager().GET_UPCOMING_TRIPS_STATUS_LIST(clientId);
    }
  }

  Future<ParentApiResponse> rejectCompletedTripWithId(
      {@required int consignmentId}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient.getDio().get(BmlManager()
          .REJECT_COMPLETED_TRIP_WITH_CONSIGNMENT_ID(consignmentId));
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(response: response, error: error);
  }

  ///Create a new Consignment
  Future<ParentApiResponse> addVehicle(
      {@required dynamic addVehicleRequest}) async {
    Response response;
    DioError error;
    try {
      response = await dioClient
          .getDio()
          .post(BmlManager().ADD_VEHICLE, data: addVehicleRequest.toJson());
    } on DioError catch (e) {
      error = e;
    }
    return ParentApiResponse(error: error, response: response);
  }
  ////////////////////////////////////////////////////////////////

  Future<Response> search({String registrationNumber}) async {
    Response response;
    try {
      response = await dioClient
          .getDio()
          .get('${BmlManager().SEARCH_BY_REG_NO}$registrationNumber');
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
      response = await dioClient.getDio().get(
          BmlManager().GET_ENTRIES_BTW_DATES(regNo, fromDate, toDate, page));
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
            "${BmlManager().GET_HUB_DATA}$hubId",
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
      response =
          await dioClient.getDio().get("${BmlManager().GET_HUBS}$routeId");
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
      response =
          await dioClient.getDio().get("${BmlManager().GET_HUBS}$routeId");
    } on DioError catch (e) {
      return e.message;
    }
    return response;
  }
}
