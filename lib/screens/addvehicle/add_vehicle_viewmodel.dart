import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/add_vehicle_request.dart';
import 'package:bml_supervisor/screens/addvehicle/vehicle_apis.dart';
import 'package:bml_supervisor/utils/stringutils.dart';

class AddVehicleViewModel extends GeneralisedBaseViewModel {
  AddVehicleRequest _addVehicleRequest = AddVehicleRequest();
  VehicleApis _vehicleApis = locator<VehicleApisImpl>();

  AddVehicleRequest get addVehicleRequest => _addVehicleRequest;

  set addVehicleRequest(AddVehicleRequest addVehicleRequest) {
    _addVehicleRequest = addVehicleRequest;
    notifyListeners();
  }

  void registerVehicle() async {
    setBusy(true);
    print('Request :: ${addVehicleRequest.toJson()}');

    ApiResponse createConsignmentResponse =
        await _vehicleApis.addVehicle(request: addVehicleRequest);
    dialogService
        .showConfirmationDialog(
            title: createConsignmentResponse.message, description: "")
        .then((value) {
      if (createConsignmentResponse.status != 'failed') {
        navigationService.back();
      } else {
        navigationService.back();
      }
    });
    setBusy(false);
  }
}
