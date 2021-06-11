import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/city_location_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/hubs_list/temp_hubs_list_args.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/temp_hubs_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class TempAddHubsViewModel extends GeneralisedBaseViewModel {
  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();
  TextEditingController countryController = TextEditingController();
  FocusNode countryFocusNode = FocusNode();
  SingleTempHub enteredHub = SingleTempHub.empty().copyWith(
    clientId: MyPreferences().getSelectedClient().clientId,
  );
  List<SingleTempHub> hubsList = [];
  TextEditingController pinCodeController = TextEditingController();
  FocusNode pinCodeFocusNode = FocusNode();
  String proposedhubTitle = '';

  TextEditingController stateController = TextEditingController();
  FocusNode stateFocusNode = FocusNode();

  AddTempHubsApis _addHubsApis = locator<AddTempHubsApisImpl>();
  String _alternateMobileNumber = '';
  List<CitiesResponse> _cityList = [];
  CityLocationResponse _cityLocation;
  List<GetClientsResponse> _clientsList = [];
  DateTime _dateOfRegistration = DateTime.now();
  DriverApis _driverApis = locator<DriverApisImpl>();
  CitiesResponse _selectedCity;
  GetClientsResponse _selectedClient;

  String get alternateMobileNumber => _alternateMobileNumber;

  set alternateMobileNumber(String value) {
    _alternateMobileNumber = value;
    notifyListeners();
  }

  CitiesResponse get selectedCity => _selectedCity;

  set selectedCity(CitiesResponse value) {
    _selectedCity = value;
    // getPinCodeState();
  }

  DateTime get dateOfRegistration => _dateOfRegistration;

  set dateOfRegistration(DateTime value) {
    _dateOfRegistration = value;
  }

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

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

  void getPinCodeState({
    @required String cityId,
  }) async {
    cityLocation = await _driverApis.getCityLocation(cityId: cityId);
  }

  // String imageBase64String = '';

  CityLocationResponse get cityLocation => _cityLocation;

  set cityLocation(CityLocationResponse value) {
    enteredHub = enteredHub.copyWith(
      state: value.state,
      pincode: value.pincode,
      country: value.country,
    );

    _cityLocation = value;
    stateController.text = value.state;
    pinCodeController.text = value.pincode;
    countryController.text = value.country;
    notifyListeners();
  }

  void addToReturningHubsList({SingleTempHub newHubObject}) async {
    setBusy(true);

    enteredHub = enteredHub.copyWith(consignmentId: newHubObject.consignmentId);

    setBusy(false);
    notifyListeners();
    takeBackWithResponse();
  }

  void checkForExistingHubTitleContainsApi(String searchString) async {
    // setBusy(true);
    List<SingleTempHub> list = await _addHubsApis.getTransientHubsListBasedOn(
        searchString: searchString.trim());
    proposedhubTitle = searchString;
    enteredHub = enteredHub.copyWith(title: searchString);
    hubsList = copyList(list);
    notifyListeners();
  }

  void takeBackWithResponse() {
    navigationService.back(
        result: TempHubsListOutputArguments(
      enteredHub: enteredHub,
    ));
  }
}
