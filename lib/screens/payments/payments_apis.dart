import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';
import 'package:bml_supervisor/models/payment_list_aggregate.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:flutter/cupertino.dart';

abstract class PaymentsApis {
  Future<ApiResponse> addNewPayment(
      {@required SavePaymentRequest savePaymentRequest});
  Future<List<PaymentHistoryResponse>> getPaymentHistory({
    @required int clientId,
    @required int pageNumber,
  });

  Future<PaymentListAggregate> getPaymentListAggregate({
    @required int clientId,
  });
}

class PaymentsApisImpl extends BaseApi implements PaymentsApis {
  @override
  Future<ApiResponse> addNewPayment(
      {SavePaymentRequest savePaymentRequest}) async {
    ApiResponse response = ApiResponse(
        status: 'failed', message: ParentApiResponse().defaultError);

    ParentApiResponse apiResponse =
        await apiService.addNewPayment(request: savePaymentRequest);

    if (filterResponse(apiResponse) != null) {
      response = ApiResponse.fromMap(apiResponse.response.data);
    }

    return response;
  }

  @override
  Future<List<PaymentHistoryResponse>> getPaymentHistory({
    int clientId,
    @required int pageNumber,
  }) async {
    List<PaymentHistoryResponse> _responseList = [];

    ParentApiResponse apiResponse = await apiService.getPaymentHistory(
        clientId: clientId, pageNumber: pageNumber);

    if (filterResponse(apiResponse) != null) {
      var list = apiResponse.response.data as List;

      for (Map singlePayment in list) {
        PaymentHistoryResponse singlePaymentResponse =
            PaymentHistoryResponse.fromJson(singlePayment);
        _responseList.add(singlePaymentResponse);
      }
    }

    return _responseList;
  }

  @override
  Future<PaymentListAggregate> getPaymentListAggregate({
    int clientId,
  }) async {
    PaymentListAggregate _response = PaymentListAggregate.zero();

    ParentApiResponse apiResponse = await apiService.getPaymentListAggregate(
      clientId: clientId,
    );

    if (filterResponse(apiResponse) != null) {
      _response = PaymentListAggregate.fromMap(apiResponse.response.data);
    }

    return _response;
  }
}
