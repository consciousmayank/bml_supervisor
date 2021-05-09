import 'package:bml/bml.dart';
import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/single_pending_consignments_item.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:flutter/cupertino.dart';

abstract class ConsignmentApis {
  Future<SearchByRegNoResponse> getVehicleDetails(
      {@required String registrationNumber});

  Future<ApiResponse> createConsignment(
      {@required CreateConsignmentRequest createConsignmentRequest});

  Future<List<ConsignmentsForSelectedDateAndClientResponse>>
      getConsignmentsForSelectedDateAndClient(
          {@required String clientId, @required String date});

  Future<ConsignmentDetailResponseNew> getConsignmentWithId(
      {@required String consignmentId});

  Future<ApiResponse> updateConsignment(
      {int consignmentId, ReviewConsignmentRequest putRequest});

  Future<List<SinglePendingConsignmentListItem>> getPendingConsignmentsList(
      {@required String clientId, @required int pageIndex});

  Future<List<SinglePendingConsignmentListItem>> getConsignmentListPageWise(
      {@required String clientId, @required int pageIndex});

  Future<List<SinglePendingConsignmentListItem>>
      getRecentConsignmentsForCreateConsignment({
    @required String clientId,
  });
}

class ConsignmentApisImpl extends BaseApi implements ConsignmentApis {
  ApiService _apiService = locator<ApiService>();
  SnackbarService _snackBarService = locator<SnackbarService>();

  @override
  Future<SearchByRegNoResponse> getVehicleDetails(
      {String registrationNumber}) async {
    SearchByRegNoResponse vehicleDetails;
    ParentApiResponse apiResponse =
        await _apiService.getVehicleDetails(registrationNumber);
    if (apiResponse.error == null) {
      //positive

      if (apiResponse.isNoDataFound()) {
        vehicleDetails = null;
      } else {
        vehicleDetails =
            SearchByRegNoResponse.fromMap(apiResponse.response.data);
      }
    } else {
      //negative
      _snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }
    return vehicleDetails;
  }

  @override
  Future<ApiResponse> createConsignment(
      {CreateConsignmentRequest createConsignmentRequest}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);

    ParentApiResponse apiResponse =
        await _apiService.createConsignment(request: createConsignmentRequest);
    if (apiResponse.error == null) {
      //positive

      if (apiResponse.isNoDataFound()) {
        _snackBarService.showSnackbar(message: apiResponse.emptyResult);
      } else {
        response = ApiResponse.fromMap(apiResponse.response.data);
      }
    } else {
      //negative
      _snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }

    return response;
  }

  @override
  Future<List<ConsignmentsForSelectedDateAndClientResponse>>
      getConsignmentsForSelectedDateAndClient(
          {String clientId, String date}) async {
    List<ConsignmentsForSelectedDateAndClientResponse> response = [];
    ParentApiResponse apiResponse = await _apiService
        .getConsignmentListWithDate(clientId: clientId, entryDate: date);

    if (filterResponse(apiResponse) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        ConsignmentsForSelectedDateAndClientResponse consignment =
            ConsignmentsForSelectedDateAndClientResponse.fromMap(element);
        response.add(consignment);
      });
    }

    return response;
  }

  @override
  Future<ConsignmentDetailResponseNew> getConsignmentWithId(
      {@required String consignmentId}) async {
    ConsignmentDetailResponseNew _response;
    ParentApiResponse apiResponse =
        await apiService.getConsignmentWithId(consignmentId: consignmentId);
    if (filterResponse(apiResponse) != null) {
      _response =
          ConsignmentDetailResponseNew.fromJson(apiResponse.response.data);
    }

    return _response;
  }

  @override
  Future<ApiResponse> updateConsignment(
      {int consignmentId, ReviewConsignmentRequest putRequest}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);

    ParentApiResponse apiResponse = await apiService.updateConsignment(
      consignmentId: consignmentId,
      putRequest: putRequest,
    );

    if (filterResponse(apiResponse) != null) {
      response = ApiResponse.fromMap(apiResponse.response.data);
    }

    return response;
  }

  @override
  Future<List<SinglePendingConsignmentListItem>> getPendingConsignmentsList(
      {String clientId, int pageIndex}) async {
    List<SinglePendingConsignmentListItem> response = [];
    ParentApiResponse apiResponse = await _apiService
        .getPendingConsignmentsList(clientId: clientId, pageIndex: pageIndex);

    if (filterResponse(apiResponse) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        SinglePendingConsignmentListItem singlePendingConsignmentListItem =
            SinglePendingConsignmentListItem.fromMap(element);
        response.add(singlePendingConsignmentListItem);
      });
    }

    return response;
  }

  @override
  Future<List<SinglePendingConsignmentListItem>> getConsignmentListPageWise({
    String clientId,
    int pageIndex,
  }) async {
    List<SinglePendingConsignmentListItem> response = [];
    ParentApiResponse apiResponse = await _apiService
        .getConsignmentListPageWise(clientId: clientId, pageIndex: pageIndex);

    if (filterResponse(apiResponse) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        SinglePendingConsignmentListItem singlePendingConsignmentListItem =
            SinglePendingConsignmentListItem.fromMap(element);
        response.add(singlePendingConsignmentListItem);
      });
    }

    return response;
  }

  @override
  Future<List<SinglePendingConsignmentListItem>>
      getRecentConsignmentsForCreateConsignment({String clientId}) async {
    List<SinglePendingConsignmentListItem> response = [];
    ParentApiResponse apiResponse =
        await _apiService.getRecentConsignmentsForCreateConsignment(
      clientId: clientId,
    );

    if (filterResponse(apiResponse) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        SinglePendingConsignmentListItem singlePendingConsignmentListItem =
            SinglePendingConsignmentListItem.fromMap(element);
        response.add(singlePendingConsignmentListItem);
      });
    }

    return response;
  }
}
