import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/city_location_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/add_hubs/temp_add_hubs_view.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/hubs_list/temp_hubs_list_args.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/temp_hubs_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/screens/expenses/add/expenses_mobile_view.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
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

  void addToReturningHubsList(
      {SingleTempHub newHubObject, @required Function onErrorOccured}) async {
    if (validate(onErrorOccured: onErrorOccured)) {
      setBusy(true);

      enteredHub =
          enteredHub.copyWith(consignmentId: newHubObject.consignmentId);

      setBusy(false);
      notifyListeners();
      takeBackWithResponse();
    } else {}
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

  String titleError, itemUnitError, addressTypeError;

  bool validate({Function onErrorOccured}) {
    if (enteredHub.title == null) {
      makeSnackbarMessage(
          message: 'Please enter Hub title',
          onOkButtonclicked: onErrorOccured(ErrorWidgetType.TITLE));
      titleError = textRequired;
      return false;
    } else if (enteredHub.title.length < 8) {
      makeSnackbarMessage(
        message: 'Hub Title Length should be greater than 7',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.TITLE,
        ),
      );
      titleError = 'Hub Title Length should be greater than 7';
    } else if (enteredHub.itemUnit == null) {
      makeSnackbarMessage(
        message: 'Item unit is required.',
        onOkButtonclicked: null,
      );
      itemUnitError = textRequired;
    } else if ((enteredHub.dropOff == null || enteredHub.dropOff == 0) &&
        (enteredHub.collect == null || enteredHub.collect == 0)) {
      makeSnackbarMessage(
        message: 'Collect or Drop values are required',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.DROP_INPUT,
        ),
      );
    } else if (enteredHub.addressType == null) {
      makeSnackbarMessage(
        message: 'Please enter an address type',
        onOkButtonclicked: null,
      );
    } else if (enteredHub.addressLine1 == null ||
        enteredHub.addressLine1.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter House No/Building Name',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.HOUSE_N0_BUULDING_NAME,
        ),
      );
    } else if (enteredHub.addressLine2 == null ||
        enteredHub.addressLine2.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter Street',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.STREET,
        ),
      );
    } else if (enteredHub.locality == null ||
        enteredHub.addressLine2.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter Locality',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.LOCALITY,
        ),
      );
    } else if (enteredHub.city == null || enteredHub.city.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter city',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.CITY,
        ),
      );
    } else if (enteredHub.pincode == null ||
        enteredHub.pincode.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter an pincode',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.PINCODE,
        ),
      );
    } else if (enteredHub.contactPerson == null ||
        enteredHub.contactPerson.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter an contact person',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.CONTACT_PERSON,
        ),
      );
    } else if (enteredHub.mobile == null ||
        enteredHub.mobile.trim().length == 0) {
      makeSnackbarMessage(
        message: 'Please enter an contact number',
        onOkButtonclicked: onErrorOccured(
          ErrorWidgetType.CONTACT_NUMBER,
        ),
      );
    } else {
      return true;
    }
  }

  makeSnackbarMessage({
    @required String message,
    @required Function onOkButtonclicked,
  }) {
    snackBarService.showCustomSnackBar(
      variant: SnackbarType.ERROR,
      duration: Duration(seconds: 2),
      message: message,
      mainButtonTitle: onOkButtonclicked != null ? 'Ok' : null,
      onMainButtonTapped: onOkButtonclicked != null
          ? () {
              onOkButtonclicked.call();
            }
          : null,
    );
  }

  void resetForm() {
    enteredHub = SingleTempHub.empty();
    enteredHub = enteredHub.copyWith(
        clientId: MyPreferences().getSelectedClient().clientId);
    hubsList.clear();
    notifyListeners();
  }
}
