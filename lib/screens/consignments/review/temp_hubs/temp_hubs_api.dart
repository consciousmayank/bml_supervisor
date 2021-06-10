import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:flutter/material.dart';

abstract class AddTempHubsApis extends BaseApi {
  Future<List<SingleTempHub>> getTransientHubsListBasedOn(
      {@required String searchString});
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
}
