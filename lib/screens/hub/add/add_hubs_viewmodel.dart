import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/city_location_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/screens/hub/add_hubs_apis.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AddHubsViewModel extends GeneralisedBaseViewModel {
  String _alternateMobileNumber = '';

  String get alternateMobileNumber => _alternateMobileNumber;

  set alternateMobileNumber(String value) {
    _alternateMobileNumber = value;
    notifyListeners();
  }

  HubResponse _selectedExistingHubTitle;

  HubResponse get selectedExistingHubTitle => _selectedExistingHubTitle;

  set selectedExistingHubTitle(HubResponse value) {
    _selectedExistingHubTitle = value;
  }

  List<HubResponse> _existingHubsList = [];

  List<HubResponse> get existingHubsList => _existingHubsList;

  set existingHubsList(List<HubResponse> value) {
    _existingHubsList = value;
    notifyListeners();
  }

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

  List<String> getHubTitleListForAutoComplete() {
    List<String> _hubTitles = [];
    existingHubsList.forEach((element) {
      _hubTitles.add(element.title);
    });
    return _hubTitles;
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

  void checkForExistingHubTitleContainsApi(String hubTitle) async{
    // setBusy(true);
    var list  = await _addHubsApis.checkForExistingHubTitleContainsApi(hubTitle: hubTitle);
    existingHubsList = copyList(list);
    // setBusy(false);
    notifyListeners();
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
    setBusy(true);
    ApiResponse _apiResponse = await _addHubsApis.addHub(request: newHubObject);
    setBusy(false);

    bottomSheetService
        .showCustomSheet(
      customData: ConfirmationBottomSheetInputArgs(
        title:
            _apiResponse.isSuccessful() ? addHubSuccessful : addHubUnSuccessful,
      ),
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
    )
        .then((value) {
      if (_apiResponse.isSuccessful()) {
        navigationService.replaceWith(addHubRoute);
      }
    });
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    List<GetClientsResponse> responseList =
        await _dashBoardApis.getClientList(pageNumber: 1);
    this.clientsList = copyList(responseList);

    setBusy(false);
    notifyListeners();
  }
}
