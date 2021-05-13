import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/vehicle_info.dart';
import 'package:bml_supervisor/screens/vehicle/vehicle_apis.dart';
import 'package:bml_supervisor/screens/vehicle/view/vehicle_details_botomsheet.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class VehiclesListViewModel extends GeneralisedBaseViewModel {
  VehicleApis _vehicleApis = locator<VehicleApisImpl>();
  int pageNumber = 1;
  List<VehicleInfo> _vehiclesList = [];
  bool shouldCallGetDriverListApi = true;

  List<VehicleInfo> get vehiclesList => _vehiclesList;

  set vehiclesList(List<VehicleInfo> vehiclesList) {
    _vehiclesList = vehiclesList;
    notifyListeners();
  }

  getVehiclesList({@required bool showLoading}) async {
    if (shouldCallGetDriverListApi) {
      if (showLoading) {
        setBusy(true);
        vehiclesList = [];
      }

      List<VehicleInfo> response = await _vehicleApis.getVehiclesList(
        pageNumber: pageNumber,
      );
      if (response.length > 0) {
        if (pageNumber == 0) {
          vehiclesList = copyList(response);
        } else {
          vehiclesList.addAll(response);
        }

        pageNumber++;
      } else {
        shouldCallGetDriverListApi = false;
      }
      if (showLoading) setBusy(false);
      notifyListeners();
    }
  }

  Future<void> openDriverDetailsBottomSheet({int selectedDriverIndex}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.VEHICLE_DETAILS,
      customData: VehicleDetailsBottomSheetInputArgs(
        vehicleInfo: vehiclesList[selectedDriverIndex],
      ),
    );
  }
}
