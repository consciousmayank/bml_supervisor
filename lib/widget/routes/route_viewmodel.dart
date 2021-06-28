import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/get_hub_details_response.dart';
import 'package:bml_supervisor/models/get_route_details_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/routes/route_details_bottomsheet.dart';
import 'package:bml_supervisor/widget/routes/routes_apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked_services/stacked_services.dart';

class RoutesViewModel extends GeneralisedBaseViewModel {
  int pageIndex = 1;
  bool shouldGetRoutesBeCalled = true;

  DashBoardApisImpl _dashBoardApis = locator<DashBoardApisImpl>();
  GetHubDetailsResponse _dstHub;
  GetHubDetailsResponse _hubResponse;
  GetRouteDetailsResponse _routeResponse;
  RoutesApis _routesApis = locator<RoutesApisImpl>();
  List<FetchRoutesResponse> _routesList = [];
  GetHubDetailsResponse _srcHub;

  List<FetchRoutesResponse> get routesList => _routesList;

  GetRouteDetailsResponse get routeResponse => _routeResponse;

  set routeResponse(GetRouteDetailsResponse value) {
    _routeResponse = value;
    notifyListeners();
  }

  GetHubDetailsResponse get srcHub => _srcHub;

  set srcHub(GetHubDetailsResponse value) {
    _srcHub = value;
    notifyListeners();
  }

  GetHubDetailsResponse get hubResponse => _hubResponse;

  set hubResponse(GetHubDetailsResponse value) {
    _hubResponse = value;
    notifyListeners();
  }

  set routesList(List<FetchRoutesResponse> value) {
    _routesList = value;
  }

  void getRouteDetailsByRouteId({@required int routeId}) async {
    setBusy(true);
    routeResponse =
        await _routesApis.getRouteDetailsByRouteId(routeId: routeId);
    if (routeResponse != null) {
      getSourceAndDestinationDetails(routeResponse);
    }
    setBusy(false);
    notifyListeners();
  }

  Future<GetHubDetailsResponse> getHubDetailsByRouteId(
      {@required int hubId}) async {
    // setBusy(true);
    hubResponse = await _routesApis.getHubDetailsByHubId(hubId: hubId);
    // setBusy(false);
    notifyListeners();
    return hubResponse;
  }

  void getSourceAndDestinationDetails(
      GetRouteDetailsResponse routeResponse) async {
    // setBusy(true);
    srcHub = await getHubDetailsByRouteId(hubId: routeResponse.srcLocation);
    dstHub = await getHubDetailsByRouteId(hubId: routeResponse.dstLocation);
    // setBusy(false);
    notifyListeners();
  }

  Future getRoutesForClient(int selectedClient, {int pageNumber = 1}) async {
    if (shouldGetRoutesBeCalled) {
      if (pageNumber <= 1) {
        setBusy(true);
      }
      List<FetchRoutesResponse> response = await _dashBoardApis.getRoutes(
          clientId: selectedClient, pageNumber: pageNumber);
      if (response.length == 0) {
        shouldGetRoutesBeCalled = false;
      }

      if (pageNumber <= 1) {
        this.routesList = copyList(response);
      } else {
        this.routesList.addAll(copyList(response));
      }
      pageIndex++;

      setBusy(false);
      notifyListeners();
    }
  }

  void onAddRouteClicked() {
    // navigationService.back();
    navigationService.navigateTo(addRoutesPageRoute);
  }

  Future<void> openRouteDetailsBottomSheet(
      {int index, FetchRoutesResponse route}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.ROUTE_DETAILS,
      customData: RouteDetailsBottomSheetInputArgs(
        routeId: routesList[index].routeId,
        route: route,
      ),
    );
  }

  takeToViewRoutesPage() {
    navigationService.navigateTo(viewRoutesPageRoute);
  }

  GetHubDetailsResponse get dstHub => _dstHub;

  set dstHub(GetHubDetailsResponse value) {
    _dstHub = value;
    notifyListeners();
  }
}
