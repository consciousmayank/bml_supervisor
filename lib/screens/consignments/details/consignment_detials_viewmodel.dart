import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';

class ConsignmentDetailsViewModel extends GeneralisedBaseViewModel {
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
  ConsignmentDetailResponseNew _consignmentDetailResponseNew;

  ConsignmentDetailResponseNew get consignmentDetailResponseNew =>
      _consignmentDetailResponseNew;

  set consignmentDetailResponseNew(ConsignmentDetailResponseNew value) {
    _consignmentDetailResponseNew = value;
  }

  void getConsignmentWithId(String consignmentId) async {
    setBusy(true);
    consignmentDetailResponseNew = await _consignmentApis.getConsignmentWithId(
        consignmentId: consignmentId);
    setBusy(false);
    notifyListeners();
  }
}
