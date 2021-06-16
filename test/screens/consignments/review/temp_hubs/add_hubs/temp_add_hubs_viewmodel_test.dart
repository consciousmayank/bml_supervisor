import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/add_hubs/temp_add_hubs_viewmodel.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/temp_hubs_api.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../setup/test_helpers.dart';

void main() {
  group('TempAddHubsViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    test('Add hubs Test', () {
      var sharedPref = SharedPreferencesServiceMock();
      var addTempApisMockService = AddTempHubsApisMock();
      var driverApisMock = DriverApisMock();

      locator.registerSingleton<MyPreferences>(sharedPref);
      locator.registerSingleton<AddTempHubsApisImpl>(addTempApisMockService);
      locator.registerSingleton<DriverApisImpl>(driverApisMock);

      var model = TempAddHubsViewModel();
      model.enteredHub = SingleTempHub(
        clientId: 2,
        consignmentId: 123,
        itemUnit: 'kilograms',
        dropOff: 0,
        collect: 2,
        title: 'Title',
        contactPerson: 'contact',
        mobile: '9611886339',
        addressType: 'Residential',
        addressLine1: 'House no',
        addressLine2: 'street',
        locality: 'locality',
        nearby: 'nearby',
        city: 'city',
        state: 'state',
        country: 'country',
        pincode: 'pincode',
        geoLatitude: 10.20,
        geoLongitude: 10.30,
        remarks: 'remarks',
      );

      expect(model.validate(onErrorOccured: () {}), false);
    });
  });
}
