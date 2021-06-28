import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/temp_hubs/add_hubs/temp_add_hubs_view.dart';
import 'package:bml_supervisor/screens/temp_hubs/search_for_hubs/search_for_hubs_values_bottomSheet.dart';
import 'package:bml_supervisor/screens/temp_hubs/search_for_hubs/search_for_hubs_view.dart';
import 'package:bml_supervisor/screens/temp_hubs/temp_hubs_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchForHubsViewModel extends GeneralisedBaseViewModel {
  AddTempHubsApis _addTempHubsApis = locator<AddTempHubsApisImpl>();
  List<SingleTempHub> hubsList = [];
  List<SingleTempHub> transientHubsList = [];

  ApiToHit apiToHit;

  void checkForExistingHubTitleContainsApi(String searchString) async {
    // setBusy(true);
    List<SingleTempHub> list = await _addTempHubsApis
        .getTransientHubsListBasedOn(searchString: searchString.trim());
    hubsList = copyList(list);
    notifyListeners();
  }

  void takeToAddTransietHubs({
    @required String title,
    @required int consignmentId,
  }) {
    navigationService.replaceWith(
      tempAddHubsPostReviewConsigPageRoute,
      arguments: TempAddHubsViewArguments(
          reviewedConsigId: consignmentId, hubTitle: title, hubsList: []),
    );
  }

  void openBottomSheet({SingleTempHub selectedHub}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.TEMP_SEARCH_HUBS_ENTER_VALUES,
      barrierDismissible: false,
      isScrollControlled: true,
      customData: SeachForHubsBottomSheetInputArgument(
          bottomSheetTitle: 'Enter following values'),
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        SeachForHubsBottomSheetOutputArguments returnedArgs =
            sheetResponse.responseData;
        selectedHub = selectedHub.copyWith(
            itemUnit: returnedArgs.itemUnit,
            dropOff: returnedArgs.drop,
            collect: returnedArgs.collect);
        navigationService.back(
          result: SearchForHubsViewOutpuArguments(selectedHub: selectedHub),
        );
      }
    }
  }

  bool shouldCallGetHubListApi = true;
  int pageNumber = 1;

  getHubList({@required bool showLoading}) async {
    if (shouldCallGetHubListApi) {
      if (showLoading) {
        setBusy(true);
        hubsList = [];
      }

      List<SingleTempHub> response =
          await _addTempHubsApis.getTransientHubsList(
        pageNumber: pageNumber,
        clientId: MyPreferences()?.getSelectedClient()?.clientId,
        apiToHit: apiToHit,
      );
      if (response.length > 0) {
        if (pageNumber == 0) {
          transientHubsList = copyList((response));
        } else {
          transientHubsList.addAll((response));
        }

        pageNumber++;
      } else {
        shouldCallGetHubListApi = false;
      }
      if (showLoading) setBusy(false);
      changeListViewHubsList(hubListType: HubListType.TRANSIENT_HUBS_LIST);
      notifyListeners();
    }
  }

  void changeListViewHubsList({@required HubListType hubListType}) {
    switch (hubListType) {
      case HubListType.TRANSIENT_HUBS_LIST:
        hubsList = copyList(transientHubsList);
        break;

      case HubListType.TRANSIENT_HUBS_WITH_ENTERED_NAME:
        break;
    }
  }
}

enum HubListType {
  TRANSIENT_HUBS_LIST,
  TRANSIENT_HUBS_WITH_ENTERED_NAME,
}
