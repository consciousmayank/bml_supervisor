import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
import 'package:flutter/material.dart';

abstract class ChartsApi {
  Future<List<KilometerReportResponse>> getDailyDrivenKm({int clientId});

  Future<List<RoutesDrivenKm>> getRoutesDrivenKm({int clientId});

  Future<List<RoutesDrivenKmPercentage>> getRoutesDrivenKmPercentage(
      {int clientId});

  Future<ParentApiResponse> getExpensesListForPieChartAggregate({int clientId});
}

class ChartsApiImpl extends BaseApi implements ChartsApi {
  @override
  Future<List<KilometerReportResponse>> getDailyDrivenKm({int clientId}) async {
    List<KilometerReportResponse> dataList = [];

    ParentApiResponse apiResponse = await apiService.getDailyDrivenKm(
      client: clientId,
    );

    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var list = apiResponse.response.data as List;
      for (Map singleDay in list) {
        KilometerReportResponse singleDayReport =
            KilometerReportResponse.fromJson(singleDay);
        dataList.add(singleDayReport);
      }
    }

    return dataList;
  }

  //Get Client Route Driven Km (Line Chart)
  @override
  Future<List<RoutesDrivenKm>> getRoutesDrivenKm({int clientId}) async {
    List<RoutesDrivenKm> routesDrivenKmList = [];
    ParentApiResponse apiResponse =
        await apiService.getRoutesDrivenKm(clientId: clientId);
    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var list = apiResponse.response.data as List;
      for (Map value in list) {
        RoutesDrivenKm routesDrivenKmResponse = RoutesDrivenKm.fromJson(value);
        routesDrivenKmList.add(routesDrivenKmResponse);
      }
    }
    return routesDrivenKmList;
  }

  @override
  Future<List<RoutesDrivenKmPercentage>> getRoutesDrivenKmPercentage(
      {int clientId}) async {
    List<Color> pieChartsColorArray = [
      Color(0xff2f6497),
      Color(0xffee6868),
      Color(0xff698caf),
      Color(0xffe8743b),
      Color(0xffed4a7b),
      Color(0xff5899da),
      Color(0xff6c757d),
      Color(0xff945ecf),
    ];

    List<RoutesDrivenKmPercentage> responseList = [];

    ParentApiResponse apiResponse =
        await apiService.getRoutesDrivenKmPercentage(clientId: clientId);
    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var list = apiResponse.response.data as List;
      for (Map value in list) {
        RoutesDrivenKmPercentage routesDrivenKmResponse =
            RoutesDrivenKmPercentage.fromJson(value);
        routesDrivenKmResponse = routesDrivenKmResponse.copyWith(
          color: pieChartsColorArray[list.indexOf(value)],
        );
        responseList.add(routesDrivenKmResponse);
      }
    }

    return responseList;
  }

  @override
  Future<ParentApiResponse> getExpensesListForPieChartAggregate(
      {int clientId}) async {
    return await apiService.getExpensesListForPieChartAggregate(
        clientId: clientId);
  }
}
