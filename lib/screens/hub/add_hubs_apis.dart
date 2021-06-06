import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/material.dart';

abstract class AddHubsApis {
  Future<ApiResponse> addHub({@required AddHubRequest request});

  Future<List<HubResponse>> getAllHubsForClient(
      {@required int clientId, @required int pageNumber});

  Future<List<HubResponse>> checkForExistingHubTitleContainsApi(
      {@required String hubTitle});
}

class AddHubApisImpl extends BaseApi implements AddHubsApis {
  @override
  Future<ApiResponse> addHub({AddHubRequest request}) async {
    ApiResponse _apiResponse =
        ApiResponse(status: 'failed', message: 'Failed to add Hub');
    ParentApiResponse _parentApiResponse =
        await apiService.addHub(request: request);
    if (filterResponse(_parentApiResponse) != null) {
      _apiResponse = ApiResponse.fromMap(_parentApiResponse.response.data);
    }

    return _apiResponse;
  }

  @override
  Future<List<HubResponse>> getAllHubsForClient(
      {@required int clientId, @required int pageNumber}) async {
    List<HubResponse> response = [];
    ParentApiResponse apiResponse = await apiService.getAllHubsForClient(
        pageIndex: pageNumber, clientId: clientId);

    if (filterResponse(apiResponse, showSnackBar: true) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        HubResponse singleHubData = HubResponse.fromMap(element);
        response.add(singleHubData);
      });
    }

    return response;
  }

  @override
  Future<List<HubResponse>> checkForExistingHubTitleContainsApi(
      {@required String hubTitle}) async {
    List<HubResponse> response = [];
    ParentApiResponse apiResponse = await apiService
        .checkForExistingHubTitleContainsApi(hubTitle: hubTitle);

    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        HubResponse singleHubData = HubResponse.fromMap(element);
        response.add(singleHubData);
      });
    }

    return response;
  }
}
