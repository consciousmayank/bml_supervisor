import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/city_location_response.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:flutter/cupertino.dart';

abstract class DriverApis {
  Future<List<CitiesResponse>> getCities();
  Future<CityLocationResponse> getCityLocation({@required String cityId});
  Future<ApiResponse> addDriver({@required AddDriverRequest request});
  Future<List<DriverInfo>> getDriversList({@required int pageNumber});
}

class DriverApisImpl extends BaseApi implements DriverApis {
  @override
  Future<List<CitiesResponse>> getCities() async {
    List<CitiesResponse> _responseList = [];

    ParentApiResponse _response = await apiService.getCities();

    if (filterResponse(_response, showSnackBar: false) != null) {
      var list = _response.response.data as List;
      for (Map value in list) {
        CitiesResponse singleCity = CitiesResponse.fromMap(value);
        _responseList.add(singleCity);
      }
    }

    return _responseList;
  }

  @override
  Future<CityLocationResponse> getCityLocation(
      {@required String cityId}) async {
    CityLocationResponse _responseLocation;

    ParentApiResponse _response =
        await apiService.getCityLocation(cityId: cityId);

    if (filterResponse(_response, showSnackBar: false) != null) {
      _responseLocation = CityLocationResponse.fromMap(_response.response.data);
    }

    return _responseLocation;
  }

  @override
  Future<ApiResponse> addDriver({AddDriverRequest request}) async {
    ApiResponse _apiResponse =
        ApiResponse(status: 'failed', message: 'Failed to add Driver');

    ParentApiResponse _parentApiResponse =
        await apiService.addDriver(request: request);
    if (filterResponse(_parentApiResponse) != null) {
      _apiResponse = ApiResponse.fromMap(_parentApiResponse.response.data);
    }

    return _apiResponse;
  }

  @override
  Future<List<DriverInfo>> getDriversList({@required int pageNumber}) async {
    List<DriverInfo> response = [];
    ParentApiResponse apiResponse =
        await apiService.getDriversListPageWise(pageIndex: pageNumber);

    if (filterResponse(apiResponse, showSnackBar: false) != null) {
      var responseList = apiResponse.response.data as List;
      responseList.forEach((element) {
        DriverInfo singleDriverInfo = DriverInfo.fromMap(element);
        response.add(singleDriverInfo);
      });
    }

    return response;
  }
}
