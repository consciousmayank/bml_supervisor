import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:stacked_services/stacked_services.dart';

class BaseApi {
  SnackbarService snackBarService = locator<SnackbarService>();
  BottomSheetService bottomSheetService = locator<BottomSheetService>();
  ApiService apiService = locator<ApiService>();

  ParentApiResponse filterResponse(ParentApiResponse apiResponse,
      {bool showSnackBar = true}) {
    ParentApiResponse returningResponse;
    if (apiResponse.error == null) {
      if (apiResponse.isNoDataFound()) {
        if (showSnackBar)
          snackBarService.showSnackbar(
              message: ParentApiResponse().emptyResult);
      } else {
        returningResponse = ParentApiResponse(
            error: apiResponse.error, response: apiResponse.response);
      }
    } else {
      if (apiResponse.error.response.statusCode == 401) {
        if (MyPreferences().getUserLoggedIn() != null) {
          MyPreferences().setLoggedInUser(null);
          MyPreferences().saveCredentials(null);
          MyPreferences().saveSelectedClient(null);
          locator<NavigationService>().clearStackAndShow(logInPageRoute);
          snackBarService.showSnackbar(
              message: ParentApiResponse().badCredentials);
          return null;
        }
      } else if (apiResponse.error.response.statusCode == 400) {
        bottomSheetService.showCustomSheet(
          customData: ConfirmationBottomSheetInputArgs(
              title: apiResponse.error.response.data['message']),
          barrierDismissible: false,
          isScrollControlled: true,
          variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
        );
      } else {
        if (showSnackBar)
          snackBarService.showSnackbar(
            message: apiResponse.getErrorReason(),
          );
      }
    }

    return returningResponse;
  }
}
