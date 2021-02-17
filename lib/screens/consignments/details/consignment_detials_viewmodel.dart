import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';

class ConsignmentDetailsViewModel extends GeneralisedBaseViewModel {
  ConsignmentDetailResponseNew _consignmentDetailResponseNew;

  ConsignmentDetailResponseNew get consignmentDetailResponseNew =>
      _consignmentDetailResponseNew;

  set consignmentDetailResponseNew(ConsignmentDetailResponseNew value) {
    _consignmentDetailResponseNew = value;
  }

  void getConsignmentWithId(String consignmentId) async {
    setBusy(true);
    var response =
        await apiService.getConsignmentWithId(consignmentId: consignmentId);
    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else if (response.data['status'].toString() == 'failed') {
      // setBusy(false);
      snackBarService.showSnackbar(message: response.data['message']);
    } else {
      try {
        consignmentDetailResponseNew =
            ConsignmentDetailResponseNew.fromJson(response.data);
      } catch (e) {
        snackBarService.showSnackbar(message: e.toString());
      }
    }
    setBusy(false);
    notifyListeners();
  }
}
