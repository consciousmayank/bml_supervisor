import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/consignment_details.dart';
import 'package:flutter/material.dart';

class ConsignmentDetailsViewModel extends GeneralisedBaseViewModel {
  List<ConsignmentDetailsResponse> _consignmentList = [];

  List<ConsignmentDetailsResponse> get consignmentList => _consignmentList;

  set consignmentList(List<ConsignmentDetailsResponse> value) {
    _consignmentList = value;
  }

  void getConsignments({
    @required int routeId,
    @required int clientId,
    @required String entryDate,
  }) async {
    setBusy(true);
    _consignmentList = [];
    var response = await apiService.getConsignmentsList(
      clientId: clientId,
      entryDate: entryDate,
      routeId: routeId,
    );

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      var apiResponse = response;
      try {
        var hubsList = apiResponse.data as List;

        hubsList.forEach((element) {
          ConsignmentDetailsResponse singleHub =
              ConsignmentDetailsResponse.fromMap(element);

          this.consignmentList.add(singleHub);
        });
      } catch (e) {
        snackBarService.showSnackbar(message: apiResponse.data['message']);
      }
    }
    setBusy(false);
    notifyListeners();
  }
}
