import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_hub_request.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/city_location_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/temp_hubs_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/screens/hub/add_hubs_apis.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class TempAddHubsViewModel extends GeneralisedBaseViewModel {
  SingleTempHub enteredHub = SingleTempHub.empty().copyWith(
    clientId: MyPreferences().getSelectedClient().clientId,
  );
  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();
  TextEditingController countryController = TextEditingController();
  FocusNode countryFocusNode = FocusNode();
  List<SingleTempHub> hubsList = [];
  TextEditingController pinCodeController = TextEditingController();
  FocusNode pinCodeFocusNode = FocusNode();
  TextEditingController stateController = TextEditingController();
  FocusNode stateFocusNode = FocusNode();

  AddTempHubsApis _addHubsApis = locator<AddTempHubsApisImpl>();
  String _alternateMobileNumber = '';
  List<CitiesResponse> _cityList = [];
  CityLocationResponse _cityLocation;
  List<GetClientsResponse> _clientsList = [];
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
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
    getPinCodeState();
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

  void checkForExistingHubTitleContainsApi(String searchString) async {
    // setBusy(true);
    List<SingleTempHub> list = await _addHubsApis.getTransientHubsListBasedOn(
        searchString: searchString);
    hubsList = copyList(list);
    // setBusy(false);
    notifyListeners();
  }

  void getPinCodeState() async {
    cityLocation = await _driverApis.getCityLocation(cityId: selectedCity.id);
  }

  // String imageBase64String = '';

  CityLocationResponse get cityLocation => _cityLocation;

  set cityLocation(CityLocationResponse value) {
    _cityLocation = value;
    stateController.text = value.state;
    pinCodeController.text = value.pincode;
    countryController.text = value.country;
    notifyListeners();
  }

  List<SingleTempHub> returningHubsList = [];

  void addToReturningHubsList({SingleTempHub newHubObject}) async {
    setBusy(true);
    returningHubsList.add(newHubObject);
    navigationService.replaceWith(addHubRoute);
    snackBarService.showCustomSnackBar(
      variant: SnackbarType.NORMAL,
      message: 'Hub Added',
    );
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
