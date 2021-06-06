import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/hub/add_hubs_apis.dart';
import 'package:bml_supervisor/screens/hub/view/hubs_list_details_botomsheet.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class HubsListViewModel extends GeneralisedBaseViewModel {
  AddHubsApis _addHubsApis = locator<AddHubApisImpl>();
  int pageNumber = 1;
  List<HubResponse> _hubsList = [];

  List<HubResponse> get hubsList => _hubsList;

  set hubsList(List<HubResponse> value) {
    _hubsList = value;
    notifyListeners();
  }

  bool shouldCallGetHubListApi = true;

  // List<HubResponse> get hubList => _hubsList;

  gethubList({@required bool showLoading}) async {
    if (shouldCallGetHubListApi) {
      if (showLoading) {
        setBusy(true);
        hubsList = [];
      }

      List<HubResponse> response = await _addHubsApis.getAllHubsForClient(
          pageNumber: pageNumber,
          clientId: MyPreferences()?.getSelectedClient()?.clientId);
      if (response.length > 0) {
        if (pageNumber == 0) {
          hubsList = copyList(response);
        } else {
          hubsList.addAll(response);
        }

        pageNumber++;
      } else {
        shouldCallGetHubListApi = false;
      }
      if (showLoading) setBusy(false);
      notifyListeners();
    }
  }

  void onAddHubClicked() {
    // navigationService.back();
    navigationService.navigateTo(addHubRoute, arguments: hubsList);
  }

  List<String> getVehicleNumberForAutoComplete(List<HubResponse> hubsList) {
    List<String> hubNames = [];
    hubsList.forEach((element) {
      hubNames.add(element.title);
    });
    return hubNames;
  }

  Future<void> openDriverDetailsBottomSheet({int selectedDriverIndex}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.HUBS_DETAILS,
      customData: HubsListDetailsBottomSheetInputArgs(
        singleHubInfo: hubsList[selectedDriverIndex],
      ),
    );
  }
}
