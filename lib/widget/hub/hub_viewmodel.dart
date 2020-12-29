import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/add_consignment_request.dart';
import 'package:bml_supervisor/models/get_consignment_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class HubViewModel extends GeneralisedBaseViewModel {
  AddConsignmentRequest _addConsignmentRequest = AddConsignmentRequest();
  List<GetConsignmentResponse> _consignmentList = [];

  List<GetConsignmentResponse> get consignmentList => _consignmentList;

  set consignmentList(List<GetConsignmentResponse> value) {
    _consignmentList = value;
  }

  AddConsignmentRequest get addConsignmentRequest => _addConsignmentRequest;

  set addConsignmentRequest(AddConsignmentRequest value) {
    _addConsignmentRequest = value;
    notifyListeners();
  }

  HubResponse _hubResponse;

  HubResponse get hubResponse => _hubResponse;

  set hubResponse(HubResponse value) {
    _hubResponse = value;
    notifyListeners();
  }

  getHubData(Hubs hub) async {
    setBusy(true);
    var response = await apiService.getHubData(hub.hub);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      hubResponse = HubResponse.fromMap(apiResponse.data);
    }
    getConsignmentList(hubId: hub.hub.toString());
  }

  void getConsignmentList({
    @required String hubId,
  }) async {
    var response = await apiService.getConsignmentsList(
        hubId: hubId, date: getCurrentDate());

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      if (apiResponse.data is List) {
        List list = apiResponse.data as List;
        list.forEach((element) {
          GetConsignmentResponse temp = GetConsignmentResponse.fromMap(element);
          _consignmentList.add(temp);
        });

        for (int i = 0; i < _consignmentList.length; i++) {
          if (addConsignmentRequest.tag == _consignmentList[i].tag) {
            print(
                "=== === === === === === === === === === === === === === === === ===");
            print("addConsignmentRequest.tag :: ${addConsignmentRequest.tag}");
            print(" i :: $i");
            print("_consignmentList[i].tag :: ${_consignmentList[i].tag}");
            print(
                "=== === === === === === === === === === === === === === === === ===");

            addConsignmentRequest = AddConsignmentRequest(
                routeId: _consignmentList[i].routeId,
                hubId: _consignmentList[i].hubId,
                entryDate: _consignmentList[i].entryDate,
                title: _consignmentList[i].title,
                dropOff: _consignmentList[i].dropOff,
                payment: _consignmentList[i].payment,
                collect: _consignmentList[i].collect,
                tag: _consignmentList[i].tag);
          }
        }
      }
      // else {
      //   GetConsignmentResponse response =
      //       GetConsignmentResponse.fromMap(apiResponse.data);
      //   snackBarService.showSnackbar(message: response.message);
      // }
      notifyListeners();
    }
    setBusy(false);
  }

  Future saveConsignment({AddConsignmentRequest request}) async {
    var response = await apiService.addConsignmentDataToHub(request);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
      return false;
    } else {
      Response apiResponse = response;

      if (apiResponse.data['status'] == 'failed') {
        snackBarService.showSnackbar(message: apiResponse.data['message']);
        return false;
      } else {
        return request;
      }
    }
  }
}
