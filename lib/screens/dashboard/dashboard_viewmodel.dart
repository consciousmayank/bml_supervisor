import 'package:bml_supervisor/app_level/generalised_indextracking_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/dashborad_tiles_response.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class DashBoardScreenViewModel extends GeneralisedIndexTrackingViewModel {
  DashBoardApisImpl _dashboardApi = locator<DashBoardApisImpl>();

  PreferencesSavedUser _savedUser;

  PreferencesSavedUser get savedUser => _savedUser;

  set savedUser(PreferencesSavedUser value) {
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

  List<String> optionsTitle = [
    "Add Entry",
    "View Entry",
    "Add Expense",
    "View Expenses",
    "Allot Consignments",
    "View Routes",
    "View Consignments",
    "Payments",
    // "Add Entry 2.0",
    // "View Entry 2.0",
  ];

  List<RecentConginmentResponse> recentConsignmentList = [];

  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    List<GetClientsResponse> responseList = await _dashboardApi.getClientList();
    this.clientsList = copyList(responseList);
    setBusy(false);
    notifyListeners();
  }

  void getDashboardTilesStats() async {
    setBusy(true);
    singleClientTileData = await _dashboardApi.getDashboardTilesStats();
    setBusy(false);
    notifyListeners();
  }

  void takeToAllConsignmentsPage() {
    print('taking to takeToAllConsignmentsPage');
    navigationService.navigateTo(viewAllConsignmentsViewPageRoute,
        arguments: recentConsignmentList);
  }

  getRecentConsignments({int clientId, String period}) async {
    recentConsignmentList.clear();
    int selectedPeriodValue = period == 'THIS MONTH' ? 1 : 2;

    // setBusy(true);
    // notifyListeners();
    // try {
    //   var res = await apiService.getRecentConsignments(
    //     clientId: clientId,
    //     period: selectedPeriodValue,
    //   );
    //   if (res.data is List) {
    //     var list = res.data as List;
    //     if (list.length > 0) {
    //       for (Map singleConsignment in list) {
    //         RecentConginmentResponse singleConsignmentResponse =
    //             RecentConginmentResponse.fromJson(singleConsignment);
    //         recentConsignmentList.add(singleConsignmentResponse);
    //       }
    //     }
    //   }
    // } on DioError catch (e) {
    //   snackBarService.showSnackbar(message: e.message);
    //   setBusy(false);
    // }
    // notifyListeners();
    // setBusy(false);
  }

  takeToAddEntryPage() {
    navigationService.navigateTo(addEntryLogPageRoute);
  }

  takeToBlankPage() {
    navigationService.navigateTo(blankPageRoute);
  }

  takeToAddExpensePage() {
    navigationService.navigateTo(addExpensesPageRoute);
  }

  takeToViewEntryPage() {
    navigationService.navigateTo(viewEntryLogPageRoute);
  }

  takeToViewExpensePage() {
    navigationService.navigateTo(viewExpensesPageRoute);
  }

  takeToAllotConsignmentsPage() {
    navigationService.navigateTo(allotConsignmentsPageRoute);
  }

  takeToPaymentsPage() {
    navigationService.navigateTo(paymentsPageRoute);
  }

  takeToViewRoutesPage() {
    navigationService.navigateTo(viewRoutesPageRoute);
  }

  //! For testing purpose it is navigating to searchPageRoute
  takeToViewConsignmentsPage() {
    navigationService.navigateTo(viewConsignmentsPageRoute);
  }

  void getClientDashboardStats(PreferencesSavedUser savedUser) async {
    setBusy(true);
    // var tilesData = await apiService.getClientDashboardStats(savedUser);
    // if (tilesData is String) {
    //   snackBarService.showSnackbar(message: tilesData);
    // } else {
    //   singleClientTileData =
    //       DashboardTilesStatsResponse.fromJson(tilesData.data);
    //   print('single Client Tile data-----${singleClientTileData.hubCount}');
    //   setBusy(false);
    //   notifyListeners();
    // }
  }
}
