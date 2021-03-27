import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/screens/addhubs/add_hubs_apis.dart';
import 'package:flutter/material.dart';

import '../../app_level/generalised_base_view_model.dart';
import '../../app_level/locator.dart';
import '../../models/ApiResponse.dart';
import '../../models/cities_response.dart';
import '../../models/city_location_response.dart';
import '../../models/secured_get_clients_response.dart';
import '../../utils/stringutils.dart';
import '../../utils/widget_utils.dart';
import '../adddriver/driver_apis.dart';
import '../dashboard/dashboard_apis.dart';

class AddHubsViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  DriverApis _driverApis = locator<DriverApisImpl>();
  AddHubsApis _addHubsApis = locator<AddHubApisImpl>();
  TextEditingController pinCodeController = TextEditingController();
  FocusNode pinCodeFocusNode = FocusNode();

  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();

  TextEditingController stateController = TextEditingController();
  FocusNode stateFocusNode = FocusNode();

  TextEditingController countryController = TextEditingController();
  FocusNode countryFocusNode = FocusNode();
  CitiesResponse _selectedCity;

  CitiesResponse get selectedCity => _selectedCity;

  set selectedCity(CitiesResponse value) {
    _selectedCity = value;
    getPinCodeState();
  }

  DateTime _dateOfRegistration = DateTime.now();

  DateTime get dateOfRegistration => _dateOfRegistration;

  set dateOfRegistration(DateTime value) {
    _dateOfRegistration = value;
  }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<CitiesResponse> _cityList = [];

  List<String> getCitiesListForAutoComplete() {
    List<String> _citiesList = [];
    cityList.forEach((element) {
      _citiesList.add(element.city);
    });
    return _citiesList;
  }

  set cityList(List<CitiesResponse> value) {
    _cityList = value;
    notifyListeners();
  }

  List<CitiesResponse> get cityList => _cityList;

  getCities() async {
    var citiesList = await _driverApis.getCities();
    cityList = copyList(citiesList);
  }

  void getPinCodeState() async {
    cityLocation = await _driverApis.getCityLocation(cityId: selectedCity.id);
  }

  CityLocationResponse _cityLocation;

  // String imageBase64String = '';

  CityLocationResponse get cityLocation => _cityLocation;

  set cityLocation(CityLocationResponse value) {
    _cityLocation = value;
    stateController.text = value.state;
    pinCodeController.text = value.pincode;
    countryController.text = value.country;
    notifyListeners();
  }

  void addHub({AddHubRequest newHubObject}) async {

    ApiResponse _apiResponse = await _addHubsApis.addHub(request: newHubObject);
    dialogService.showConfirmationDialog(
        title:
            _apiResponse.isSuccessful() ? addHubSuccessful : addHubUnSuccessful,
        description: _apiResponse.message,
        barrierDismissible: false).then((value) {
      if (value.confirmed) {
        if (_apiResponse.isSuccessful()) {
          navigationService.back();
        }
      }
    });
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    List<GetClientsResponse> responseList =
    await _dashBoardApis.getClientList();
    this.clientsList = copyList(responseList);

    setBusy(false);
    notifyListeners();
  }
}
