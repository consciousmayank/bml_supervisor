import 'dart:typed_data';

import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/models/dashborad_tiles_response.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/delivery_route/list/delivery_hubs/view_routes_arguments.dart';
import 'package:bml_supervisor/screens/payments/payment_args.dart';
import 'package:bml_supervisor/screens/trips/tripsdetailed/detailedTripsArgs.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class DashBoardScreenViewModel extends GeneralisedBaseViewModel {
  List<ConsignmentTrackingStatusResponse> _upcomingTrips = [];
  List<ConsignmentTrackingStatusResponse> _ongoingTrips = [];
  bool _isGettingTripsStatus = false;

  List<ConsignmentTrackingStatusResponse> _completedTrips = [];
  bool openConsignmentGroup = false;
  DashBoardApis _dashboardApi = locator<DashBoardApisImpl>();
  LoginResponse _userProfile;
  Uint8List _image;

  Uint8List get image => _image;

  set image(Uint8List value) {
    _image = value;
  }

  bool get isGettingTripsStatus => _isGettingTripsStatus;

  set isGettingTripsStatus(bool value) {
    _isGettingTripsStatus = value;
    notifyListeners();
  }

  LoginResponse get userProfile => _userProfile;

  set userProfile(LoginResponse value) {
    _userProfile = value;
  }

  LoginResponse _savedUser;

  LoginResponse get savedUser => _savedUser;

  set savedUser(LoginResponse value) {
    _savedUser = value;
    notifyListeners();
  }

  void getSavedUser() {
    savedUser = MyPreferences().getUserLoggedIn();
  }

  List<IconData> optionsIcons = [
    Icons.phone,
    Icons.clear,
    Icons.label,
    Icons.search,
    Icons.date_range,
    Icons.list,
    Icons.access_alarm,
    Icons.payment,
  ];

  String _selectedDuration = "";

  String get selectedDuration => _selectedDuration;

  set selectedDuration(String selectedDuration) {
    _selectedDuration = selectedDuration;
    notifyListeners();
  }

  DashboardTilesStatsResponse _singleClientTileData;

  DashboardTilesStatsResponse get singleClientTileData => _singleClientTileData;

  set singleClientTileData(DashboardTilesStatsResponse singleClientTileData) {
    _singleClientTileData = singleClientTileData;
    notifyListeners();
  }

  RecentConginmentResponse _singleConsignmentData;

  RecentConginmentResponse get singleConsignmentData => _singleConsignmentData;

  set singleConsignmentData(RecentConginmentResponse singleConsignmentData) {
    _singleConsignmentData = singleConsignmentData;
    notifyListeners();
  }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<RecentConginmentResponse> recentConsignmentList = [];

  // getClients() async {
  //   setBusy(true);
  //   clientsList = [];
  //   //* get bar graph data too when populating the client dropdown
  //
  //   List<GetClientsResponse> responseList = await _dashboardApi.getClientList();
  //   this.clientsList = copyList(responseList);
  //
  //   this.selectedClient = clientsList.first;
  //   setBusy(false);
  //   notifyListeners();
  // }

  void getClientDashboardStats() async {
    setBusy(true);

    singleClientTileData = await _dashboardApi.getDashboardTilesStats(
        clientId: selectedClient.clientId);
    setBusy(false);
    notifyListeners();
  }

  void onDashboardDrawerTileClicked() {
    navigationService.back();
  }

  void onDailyKilometersDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(viewEntryLogPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onUserProfileTileClicked() {
    navigationService.back();
    navigationService.navigateTo(userProfileRoute).then(
          (value) => reloadPage(),
        );
  }

  void takeToViewExpensesPage() {
    navigationService.back();
    navigationService.navigateTo(viewExpensesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onAllotConsignmentsDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(allotConsignmentsPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onListConsignmentTileClick() {
    navigationService.back();
    navigationService.navigateTo(consignmentListByDatePageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onReviewConsignmentsDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(viewConsignmentsPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onPendingConsignmentsListDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(pendingConsignmentsListPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onViewRoutesDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(viewRoutesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onViewHubsListDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(hubsListViewPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onTransactionsDrawerTileClicked() {
    PaymentArgs _paymentArgs = PaymentArgs(
        totalKm: singleClientTileData.totalKm,
        dueKm: singleClientTileData.dueKm);
    navigationService.back();
    navigationService
        .navigateTo(paymentsPageRoute, arguments: _paymentArgs)
        .then(
          (value) => reloadPage(),
        );
  }

  void onAddDriverDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(addDriverPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onAddHubTileClick() {
    navigationService.back();
    navigationService.navigateTo(addHubRoute).then(
          (value) => reloadPage(),
        );
  }

  void onAddRoutesTileClick() {
    navigationService.back();
    navigationService.navigateTo(addRoutesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onAddVehicleTileClick() {
    navigationService.back();
    navigationService.navigateTo(addVehiclePageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onViewVehicleTileClick() {
    navigationService.back();
    navigationService.navigateTo(viewVehiclesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void onViewDriverTileClick() {
    navigationService.back();
    navigationService.navigateTo(viewDriversPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void reloadPage() {
    // getClients();
    getClientDashboardStats();
    getConsignmentTrackingStatus();
  }

  takeToDistributorsPage() {
    navigationService.navigateTo(hubsListViewPageRoute).then(
          (value) => reloadPage(),
        );
  }

  takeToViewEntryPage() {
    navigationService.navigateTo(viewEntryLogPageRoute).then(
          (value) => reloadPage(),
        );
  }

  takeToViewExpensePage() {
    navigationService.navigateTo(viewExpensesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  takeToHubsView({FetchRoutesResponse clickedRoute}) {
    navigationService
        .navigateTo(hubsViewPageRoute,
            arguments: ViewRoutesArguments(
              clickedRoute: clickedRoute,
            ))
        .then(
          (value) => reloadPage(),
        );
  }

  void takeToViewRoutesPage() {
    navigationService.navigateTo(viewRoutesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void takeToPaymentsPage() {
    PaymentArgs _paymentArgs = PaymentArgs(
        totalKm: singleClientTileData.totalKm,
        dueKm: singleClientTileData.dueKm);
    navigationService
        .navigateTo(paymentsPageRoute, arguments: _paymentArgs)
        .then(
          (value) => reloadPage(),
        );
  }

  void onExpensesDrawerTileClicked() {
    navigationService.back();
    navigationService.navigateTo(viewExpensesPageRoute).then(
          (value) => reloadPage(),
        );
  }

  void changeConsignmentGroupVisibility() {
    openConsignmentGroup = !openConsignmentGroup;
    notifyListeners();
  }

  Future getUserProfile() async {
    setBusy(true);
    LoginResponse loggedInUserDetails = MyPreferences().getUserLoggedIn();
    if (loggedInUserDetails != null) {
      userProfile = loggedInUserDetails;
      image = getImageFromBase64String(base64String: userProfile.photo);
    }
    notifyListeners();
    setBusy(false);
  }

  void showClientSelectBottomSheet() async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      barrierDismissible: true,
      customData: MyPreferences().getSelectedClient(),
      variant: BottomSheetType.clientSelect,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        GetClientsResponse bottomSheetSelectedClient =
            sheetResponse.responseData;
        selectedClient = bottomSheetSelectedClient;
        reloadPage();
      }
    }
  }

  void getConsignmentTrackingStatus() async {
    isGettingTripsStatus = true;
    List<ConsignmentTrackingStatusResponse> response;
    response = await _dashboardApi.getConsignmentTrackingStatus(
        clientId: selectedClient.clientId, tripStatus: TripStatus.UPCOMING);
    upcomingTrips = copyList(response);

    response = await _dashboardApi.getConsignmentTrackingStatus(
        clientId: selectedClient.clientId, tripStatus: TripStatus.ONGOING);
    ongoingTrips = copyList(response);
    response = await _dashboardApi.getConsignmentTrackingStatus(
        clientId: selectedClient.clientId, tripStatus: TripStatus.COMPLETED);
    completedTrips = copyList(response);
    response = await _dashboardApi.getConsignmentTrackingStatus(
        clientId: selectedClient.clientId, tripStatus: TripStatus.APPROVED);
    _completedTrips.addAll(
      copyList(response),
    );
    isGettingTripsStatus = false;
    // notifyListeners();
  }

  get completedTrips => _completedTrips;

  set completedTrips(value) {
    _completedTrips = value;
  }

  get ongoingTrips => _ongoingTrips;

  set ongoingTrips(value) {
    _ongoingTrips = value;
  }

  List<ConsignmentTrackingStatusResponse> get upcomingTrips => _upcomingTrips;

  set upcomingTrips(List<ConsignmentTrackingStatusResponse> value) {
    _upcomingTrips = value;
  }

  void takeToUpcomingTripsDetailsView({@required TripStatus tripStatus}) {
    navigationService.back();
    navigationService
        .navigateTo(
          tripsDetailsPageRoute,
          arguments: DetailedTripsViewArgs(tripStatus: tripStatus),
        )
        .then((value) => reloadPage());
  }
}

class LeftDrawerItem {
  int id;
  String headerName;
}
