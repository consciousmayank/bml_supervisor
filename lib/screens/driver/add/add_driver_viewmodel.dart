import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/models/city_location_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/driver/add/address_type_bottomsheet.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AddDriverViewModel extends GeneralisedBaseViewModel {
  String _alternatePhNo = '';
  String _whatsAppNo = '';
  String get whatsAppNo => _whatsAppNo;
  String selectedAddressTypes = '';
  set whatsAppNo(String value) {
    _whatsAppNo = value;
    notifyListeners();
  }

  String get alternatePhNo => _alternatePhNo;

  set alternatePhNo(String value) {
    _alternatePhNo = value;
    notifyListeners();
  }

  TextEditingController pinCodeController = TextEditingController();
  FocusNode pinCodeFocusNode = FocusNode();

  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();

  TextEditingController stateController = TextEditingController();
  FocusNode stateFocusNode = FocusNode();

  TextEditingController countryController = TextEditingController();
  FocusNode countryFocusNode = FocusNode();

  DriverApis _driverApis = locator<DriverApisImpl>();
  DateTime _dateOfBirth = DateTime.now();
  List<CitiesResponse> _cityList = [];
  CityLocationResponse _cityLocation;

  String imageBase64String = '';

  CityLocationResponse get cityLocation => _cityLocation;

  set cityLocation(CityLocationResponse value) {
    _cityLocation = value;
    stateController.text = value.state;
    pinCodeController.text = value.pincode;
    countryController.text = value.country;
    notifyListeners();
  }

  List<CitiesResponse> get cityList => _cityList;

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

  String _selectedGender = '';
  String _selectedBloodGroup = '';

  String get selectedBloodGroup => _selectedBloodGroup;

  set selectedBloodGroup(String value) {
    _selectedBloodGroup = value;
    notifyListeners();
  }

  CitiesResponse _selectedCity;

  CitiesResponse get selectedCity => _selectedCity;

  set selectedCity(CitiesResponse value) {
    _selectedCity = value;
    getPinCodeState();
  }

  String get selectedGender => _selectedGender;

  set selectedGender(String value) {
    _selectedGender = value;
    notifyListeners();
  }

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
  }

  DateTime get dateOfBirth => _dateOfBirth;

  getCities() async {
    var citiesList = await _driverApis.getCities();
    cityList = copyList(citiesList);
  }

  void getPinCodeState() async {
    cityLocation = await _driverApis.getCityLocation(cityId: selectedCity.id);
  }

  void addDriver({AddDriverRequest newDriverObject}) async {
    setBusy(true);
    ApiResponse _apiResponse =
        await _driverApis.addDriver(request: newDriverObject);

    // if (_apiResponse.isSuccessful()) {
    pinCodeController.clear();
    cityController.clear();
    countryController.clear();
    stateController.clear();
    bottomSheetService
        .showCustomSheet(
      customData: ConfirmationBottomSheetInputArgs(
          title: _apiResponse.isSuccessful()
              ? addDriverSuccessful
              : addDriverUnSuccessful,
          description: _apiResponse?.message ?? null),
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
    )
        .then((value) {
      if (_apiResponse.isSuccessful()) {
        navigationService.replaceWith(addDriverPageRoute);
      }
    });
    // }
    setBusy(false);
  }

  String getSalutation() {
    if (genders.first == selectedGender || genders.last == selectedGender) {
      return 'Mr';
    } else {
      return 'Mrs';
    }
  }

  openAddressSelectorBottomSheet() {
    bottomSheetService
        .showCustomSheet(
      customData: AddressTypeBottomSheetInputArgs(
        allowedAddressTypes: addressTypes,
        preSelectedAddressTypes: selectedAddressTypes,
      ),
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.ADDRESS_TYPE,
    )
        .then((value) {
      if (value != null && value.confirmed) {
        AddressTypeBottomSheetOutputArgs args = value.responseData;
        selectedAddressTypes = args.selectedAddressTypes;
        notifyListeners();
      }
    });
  }
}
