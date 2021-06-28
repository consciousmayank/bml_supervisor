import 'dart:convert';

import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/temp_hubs/search_for_hubs/search_for_hubs_view.dart';
import 'package:flutter/material.dart';

abstract class AddTempHubsApis extends BaseApi {
  Future<List<SingleTempHub>> getTransientHubsListBasedOn(
      {@required String searchString});

  Future<List<SingleTempHub>> getTransientHubsList({
    @required int clientId,
    @required int pageNumber,
    @required ApiToHit apiToHit,
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
    ApiToHit apiToHit = ApiToHit.GET_TRANSIENT_HUBS,
  }) async {
    List<SingleTempHub> responseList = [];
    ParentApiResponse response;
    switch (apiToHit) {
      case ApiToHit.GET_TRANSIENT_HUBS:
        response = await apiService.getTransientHubsList(
          clientId: clientId,
          pageNumber: pageNumber,
        );
        break;
      case ApiToHit.GET_HUBS:
        response = await apiService.getHubsList(
          clientId: clientId,
          page: pageNumber,
        );
        break;
    }

    if (filterResponse(response, showSnackBar: false) != null) {
      var list = response.response.data as List;

      for (Map item in list) {
        SingleTempHub singleDayReport;
        if (apiToHit == ApiToHit.GET_HUBS) {
          FetchHubsResponse singleHub = FetchHubsResponse.fromMap(item);
          singleDayReport = SingleTempHub(
            clientId: clientId,
            consignmentId: singleHub.id,
            itemUnit: '',
            dropOff: -1,
            collect: -1,
            title: singleHub.title,
            contactPerson: singleHub.contactPerson,
            mobile: singleHub.mobile,
            addressType: '',
            addressLine1: '',
            addressLine2: '',
            locality: '',
            nearby: '',
            city: singleHub.city,
            state: '',
            country: '',
            pincode: '',
            geoLatitude: singleHub.geoLatitude,
            geoLongitude: singleHub.geoLongitude,
            remarks: '',
          );
        } else {
          singleDayReport = SingleTempHub.fromMap(item);
        }

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
