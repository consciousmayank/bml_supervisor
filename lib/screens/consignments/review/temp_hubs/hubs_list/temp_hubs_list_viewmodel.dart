import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/add_hubs/temp_add_hubs_view.dart';
import 'package:flutter/material.dart';

class TempHubsListViewModel extends GeneralisedBaseViewModel {
  List<SingleTempHub> hubsList = [];
  void onAddHubClicked({@required int reviewedConsigId}) {
    navigationService
        .navigateTo(
      tempAddHubsPostReviewConsigPageRoute,
      arguments: TempAddHubsViewArguments(
        reviewedConsigId: reviewedConsigId,
      ),
    )
        .then((value) {
      if (value != null) {
        snackBarService.showSnackbar(message: 'True');
      } else {
        snackBarService.showSnackbar(message: 'False');
      }
    });
  }
}
