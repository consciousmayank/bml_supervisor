import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/screens/driver/view/driver_details_botomsheet.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class DriversListViewModel extends GeneralisedBaseViewModel {
  DriverApis _driverApis = locator<DriverApisImpl>();
  int pageNumber = 1;
  List<DriverInfo> _driversList = [];
  bool shouldCallGetDriverListApi = true;

  List<DriverInfo> get driversList => _driversList;

  set driversList(List<DriverInfo> driversList) {
    _driversList = driversList;
    notifyListeners();
  }

  getDriversList({@required bool showLoading}) async {
    if (shouldCallGetDriverListApi) {
      if (showLoading) {
        setBusy(true);
        driversList = [];
      }

      List<DriverInfo> response = await _driverApis.getDriversList(
        pageNumber: pageNumber,
      );
      if (response.length > 0) {
        if (pageNumber == 0) {
          driversList = copyList(response);
        } else {
          driversList.addAll(response);
        }

        pageNumber++;
      } else {
        shouldCallGetDriverListApi = false;
      }
      if (showLoading) setBusy(false);
      notifyListeners();
    }
  }

  void onAddDriverClicked() {
    // navigationService.back();
    navigationService.navigateTo(addDriverPageRoute);
  }


  List<String> getDriverNameForAutoComplete(
      List<DriverInfo> hubsList) {
    List<String> hubNames = [];
    hubsList.forEach((element) {
      hubNames.add(element.firstName);
    });
    return hubNames;
  }
  Future<void> openDriverDetailsBottomSheet({int selectedDriverIndex}) async {
    await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.DRIVER_DETAILS,
      customData: DriverDetailsBottomSheetInputArgs(
        driverInfo: driversList[selectedDriverIndex],
      ),
    );
  }
}
