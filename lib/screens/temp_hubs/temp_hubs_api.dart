import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:flutter/material.dart';

abstract class AddTempHubsApis extends BaseApi {
  Future<List<SingleTempHub>> getTransientHubsListBasedOn(
      {@required String searchString});

  Future<List<SingleTempHub>> getTransientHubsList({
    @required int clientId,
    @required int pageNumber,
  });

  Future<ApiResponse> addTransientHubs({
    @required List<SingleTempHub> hubList,
  });
}

class AddTempHubsApisImpl extends AddTempHubsApis {
  @override
  Future<List<SingleTempHub>> getTransientHubsListBasedOn(
      {String searchString}) async {
    List<SingleTempHub> responseList = [];

    ParentApiResponse response = await apiService.getTransientHubsListBasedOn(
        searchString: searchString);

    if (filterResponse(response, showSnackBar: false) != null) {
      var list = response.response.data as List;

      for (Map item in list) {
        SingleTempHub singleDayReport = SingleTempHub.fromMap(item);
        responseList.add(singleDayReport);
      }
    }

    return responseList;
  }

  @override
  Future<List<SingleTempHub>> getTransientHubsList({
    @required int clientId,
    @required int pageNumber,
  }) async {
    List<SingleTempHub> responseList = [];

    ParentApiResponse response = await apiService.getTransientHubsList(
      clientId: clientId,
      pageNumber: pageNumber,
    );

    if (filterResponse(response, showSnackBar: false) != null) {
      var list = response.response.data as List;

      for (Map item in list) {
        SingleTempHub singleDayReport = SingleTempHub.fromMap(item);
        responseList.add(singleDayReport);
      }
    }

    return responseList;
  }

  @override
  Future<ApiResponse> addTransientHubs({List<SingleTempHub> hubList}) async {
    ApiResponse apiResponse = ApiResponse(message: '', status: 'failed');
    ParentApiResponse response = await apiService.addTransientHubs(
      body: hubList,
    );

    if (filterResponse(response, showSnackBar: false) != null) {
      apiResponse = ApiResponse.fromMap(response.response.data);
    }
    return apiResponse;
  }
}
