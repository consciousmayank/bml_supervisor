import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/temp_hubs_api.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

class SharedPreferencesServiceMock extends Mock implements MyPreferences {}

class NavigationServiceMock extends Mock implements NavigationService {}

class SnackbarServiceMock extends Mock implements SnackbarService {}

class BottomSheetServiceMock extends Mock implements BottomSheetService {}

class AddTempHubsApisMock extends Mock implements AddTempHubsApisImpl {}

class DriverApisMock extends Mock implements DriverApisImpl {}

class ApiServiceMock extends Mock implements ApiService {}

NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  var service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MyPreferences getAndRegisterSharedPreferencesServiceMock() {
  var pref = MyPreferences();
  return pref;
}

SnackbarService getAndRegisterSnackbarServiceMock() {
  _removeRegistrationIfExists<SnackbarService>();
  var service = SnackbarServiceMock();
  locator.registerSingleton<SnackbarService>(service);
  return service;
}

BottomSheetService getAndRegisterBottomSheetServiceMock() {
  _removeRegistrationIfExists<BottomSheetService>();
  var service = BottomSheetServiceMock();
  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

ApiService getAndRegisterApiServiceMock() {
  _removeRegistrationIfExists<ApiService>();
  var service = ApiServiceMock();
  locator.registerSingleton<ApiService>(service);
  return service;
}

void registerServices() {
  getAndRegisterSharedPreferencesServiceMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterSnackbarServiceMock();
  getAndRegisterBottomSheetServiceMock();
  getAndRegisterApiServiceMock();
}

void unregisterServices() {
  locator.unregister<SnackbarService>();
  locator.unregister<NavigationService>();
  locator.unregister<BottomSheetService>();
  locator.unregister<ApiService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
