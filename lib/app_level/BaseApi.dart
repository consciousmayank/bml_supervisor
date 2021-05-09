import 'package:bml/bml.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/services/api_service.dart';

class BaseApi {
  SnackbarService snackBarService = locator<SnackbarService>();
  ApiService apiService = locator<ApiService>();
  SharedPreferencesService preferences = locator<SharedPreferencesService>();

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
      if (showSnackBar)
        snackBarService.showSnackbar(
          message: apiResponse.getErrorReason(),
        );
    }

    return returningResponse;
  }
}
