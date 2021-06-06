import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_vehicle_request.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/vehicle/vehicle_apis.dart';
import 'package:flutter/material.dart';

class AddVehicleViewModel extends GeneralisedBaseViewModel {
  AddVehicleRequest _addVehicleRequest = AddVehicleRequest();
  VehicleApis _vehicleApis = locator<VehicleApisImpl>();
  AddVehicleRequest get addVehicleRequest => _addVehicleRequest;

  final controller = ScrollController();
  final TextEditingController registrationUptoController =
      TextEditingController();
  final TextEditingController registrationDateController =
      TextEditingController();

  set addVehicleRequest(AddVehicleRequest addVehicleRequest) {
    _addVehicleRequest = addVehicleRequest;
    notifyListeners();
  }

  void registerVehicle() async {
    setBusy(true);
    ApiResponse createConsignmentResponse =
        await _vehicleApis.addVehicle(request: addVehicleRequest);

    addVehicleRequest = AddVehicleRequest();
    notifyListeners();
    bottomSheetService
        .showCustomSheet(
      customData: ConfirmationBottomSheetInputArgs(
          title: createConsignmentResponse.message),
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
    )
        .then(
      (value) {
        if (createConsignmentResponse.isSuccessful()) {
          navigationService.replaceWith(addVehiclePageRoute);
        }
      },
    );

    setBusy(false);
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 200), () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 400),
      );
    });
  }

  void scrollToTop() {
    Future.delayed(Duration(milliseconds: 50), () {
      controller.animateTo(
        controller.position.minScrollExtent,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 100),
      );
    });
  }
}
