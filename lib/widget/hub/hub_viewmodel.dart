import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/add_consignment_request.dart';
import 'package:bml_supervisor/models/get_consignment_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class HubViewModel extends GeneralisedBaseViewModel {
  AddConsignmentRequest _addConsignmentRequest;
  List<GetConsignmentResponse> _consignmentList = [];

  Hubs hub;

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

  getHubData(Hubs hub, int routeId) async {
    this.hub = hub;
    setBusy(true);
    var response = await apiService.getHubData(hub.hub);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      hubResponse = HubResponse.fromMap(apiResponse.data);
    }
    getConsignmentList(routeId: routeId, hubId: hub.hub.toString());
  }

  void getConsignmentList({
    @required String hubId,
    int routeId,
  }) async {
    var response =
        await apiService.getConsignmentsList(routeId: routeId, hubId: hubId);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      if (apiResponse.data is List) {
        List list = apiResponse.data as List;
        list.forEach((element) {
          GetConsignmentResponse temp = GetConsignmentResponse.fromMap(element);
          print(temp.toJson());
          _consignmentList.add(temp);
        });

        // switch (_consignmentList.length) {
        //   case 0:
        //     addConsignmentRequest = AddConsignmentRequest(
        //       routeId: routeId,
        //       hubId: int.parse(hubId),
        //       // entryDate: _consignmentList.first.entryDate,
        //       // title: _consignmentList.first.title,
        //       dropOff: null,
        //       payment: null,
        //       collect: null,
        //       // tag: _consignmentList.first.tag
        //     );
        //     break;
        //
        //   case 1:
        //     if (_consignmentList.first.tag == 1) {
        //       print("aasdasd :: ${getIndexWhereTag(1)}");
        //       addConsignmentRequest = AddConsignmentRequest(
        //           routeId: _consignmentList[getIndexWhereTag(1)].routeId,
        //           hubId: _consignmentList[getIndexWhereTag(1)].hubId,
        //           entryDate: _consignmentList[getIndexWhereTag(1)].entryDate,
        //           title: _consignmentList[getIndexWhereTag(1)].title,
        //           dropOff: _consignmentList[getIndexWhereTag(1)].dropOff,
        //           payment: _consignmentList[getIndexWhereTag(1)].payment,
        //           collect: _consignmentList[getIndexWhereTag(1)].collect,
        //           tag: _consignmentList[getIndexWhereTag(1)].tag);
        //     } else if (_consignmentList.first.tag == 0) {
        //       print("aasdasd :: ${getIndexWhereTag(0)}");
        //       addConsignmentRequest = AddConsignmentRequest(
        //           routeId: _consignmentList[getIndexWhereTag(0)].routeId,
        //           hubId: _consignmentList[getIndexWhereTag(0)].hubId,
        //           entryDate: _consignmentList[getIndexWhereTag(0)].entryDate,
        //           title: _consignmentList[getIndexWhereTag(0)].title,
        //           dropOff: _consignmentList[getIndexWhereTag(0)].dropOff,
        //           payment: _consignmentList[getIndexWhereTag(0)].payment,
        //           collect: _consignmentList[getIndexWhereTag(0)].collect,
        //           tag: _consignmentList[getIndexWhereTag(0)].tag);
        //     }
        //
        //     break;
        //
        //   case 2:
        //     if (_consignmentList.first.tag == 1) {
        //       print("aasdasd :: ${getIndexWhereTag(1)}");
        //       addConsignmentRequest = AddConsignmentRequest(
        //           routeId: _consignmentList[getIndexWhereTag(1)].routeId,
        //           hubId: _consignmentList[getIndexWhereTag(1)].hubId,
        //           entryDate: _consignmentList[getIndexWhereTag(1)].entryDate,
        //           title: _consignmentList[getIndexWhereTag(1)].title,
        //           dropOff: _consignmentList[getIndexWhereTag(1)].dropOff,
        //           payment: _consignmentList[getIndexWhereTag(1)].payment,
        //           collect: _consignmentList[getIndexWhereTag(1)].collect,
        //           tag: _consignmentList[getIndexWhereTag(1)].tag);
        //     } else if (_consignmentList.first.tag == 2) {
        //       print("aasdasd :: ${getIndexWhereTag(2)}");
        //       addConsignmentRequest = AddConsignmentRequest(
        //           routeId: _consignmentList[getIndexWhereTag(2)].routeId,
        //           hubId: _consignmentList[getIndexWhereTag(2)].hubId,
        //           entryDate: _consignmentList[getIndexWhereTag(2)].entryDate,
        //           title: _consignmentList[getIndexWhereTag(2)].title,
        //           dropOff: _consignmentList[getIndexWhereTag(2)].dropOff,
        //           payment: _consignmentList[getIndexWhereTag(2)].payment,
        //           collect: _consignmentList[getIndexWhereTag(2)].collect,
        //           tag: _consignmentList[getIndexWhereTag(2)].tag);
        //     }
        // }
        print("Consignment Length         :: ${_consignmentList.length}");
        print("Hub Details                :: ${hub.toJson()}");
        for (int i = 0; i < _consignmentList.length; i++) {
          print(
              "=== === === === === === === === === === === === === === === === ===");
          print("Consignment Details    :: ${_consignmentList[i].toJson()}");
          print(
              "=== === === === === === === === === === === === === === === === ===");

          if (this.hub.tag == _consignmentList[i].tag) {
            print("---------------------------------------------------------");
            print(
                "Consignment Details Inside if   :: ${_consignmentList[i].toJson()}");
            print("---------------------------------------------------------");
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

  int getIndexWhereTag(int tag) {
    _consignmentList.forEach((element) {
      if (tag == element.tag) {
        print("index :: ${_consignmentList.indexOf(element)}");
        return _consignmentList.indexOf(element);
      }
    });
    print("index :: 0");
    return 0;
  }
}
