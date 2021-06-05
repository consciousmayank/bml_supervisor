import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class RoutesListBottomSheetViewModel extends GeneralisedBaseViewModel {
  List<FetchRoutesResponse> routeList = [];
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  int pageIndex = 1;
  bool shouldGetRoutes = true;
  getRoutes({int pageNumber = 1}) async {
    if (shouldGetRoutes) {
      if (pageNumber <= 1) {
        setBusy(true);
        routeList = [];
      }

      List<FetchRoutesResponse> response = await _dashBoardApis.getRoutes(
        clientId: MyPreferences().getSelectedClient().clientId,
        pageNumber: pageIndex,
      );
      if (response.length == 0) {
        shouldGetRoutes = false;
      }
      if (pageNumber <= 1) {
        this.routeList = copyList(response);
      } else {
        this.routeList.addAll(
              copyList(response),
            );
      }
      pageIndex++;

      setBusy(false);
      notifyListeners();
    }
  }
}
