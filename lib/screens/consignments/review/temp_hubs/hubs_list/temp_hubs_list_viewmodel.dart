import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/add_hubs/temp_add_hubs_view.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/hubs_list/temp_hubs_list_args.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/temp_hubs_api.dart';
import 'package:flutter/material.dart';

class TempHubsListViewModel extends GeneralisedBaseViewModel {
  AddTempHubsApis _addHubsApis = locator<AddTempHubsApisImpl>();
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
        TempHubsListOutputArguments arguments = value;
        hubsList.add(arguments.enteredHub);
        notifyListeners();
      }
    });
  }

  void addTrasientHubs() async {
    setBusy(true);
    ApiResponse response =
        await _addHubsApis.addTransientHubs(hubList: hubsList);
    setBusy(false);
    if (response.isSuccessful()) {
      bottomSheetService
          .showCustomSheet(
        customData: ConfirmationBottomSheetInputArgs(
          title: response.message,
        ),
        barrierDismissible: false,
        isScrollControlled: true,
        variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
      )
          .then((value) {
        if (value != null) {
          if (response.isSuccessful()) {
            navigationService.back(result: true);
          }
        }
      });
    }
  }

  void showConfirmationBottomSheet() {
    bottomSheetService
        .showCustomSheet(
      customData: ConfirmationBottomSheetInputArgs(
          title: 'You have not added any hubs.',
          description: 'You want to continue?',
          positiveButtonTitle: 'Yes',
          negativeButtonTitle: 'No'),
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
    )
        .then((value) {
      if (value != null) {
        navigationService.back(result: true);
      }
    });
  }
}
