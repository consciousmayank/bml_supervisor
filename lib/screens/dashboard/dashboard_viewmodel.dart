import 'package:bml_supervisor/app_level/generalised_indextracking_view_model.dart';
import 'package:bml_supervisor/models/dashborad_tiles_response.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';

class DashBoardScreenViewModel extends GeneralisedIndexTrackingViewModel {
  List<IconData> optionsIcons = [
    Icons.phone,
    Icons.clear,
    Icons.label,
    Icons.search,
    Icons.date_range,
    Icons.list,
    Icons.title,
    Icons.access_alarm,
    Icons.access_time,
    Icons.payment,
  ];

  bool _isShowBarChart = false;

  bool get isShowBarChart => _isShowBarChart;

  set isShowBarChart(bool isShowBarChart) {
    _isShowBarChart = isShowBarChart;
    notifyListeners();
  }

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

  GetClientsResponse _selectedClientForTiles;
  GetClientsResponse get selectedClientForTiles => _selectedClientForTiles;

  set selectedClientForTiles(GetClientsResponse selectedClientForTiles) {
    _selectedClientForTiles = selectedClientForTiles;
    notifyListeners();
  }

  List<String> optionsTitle = [
    "Add Entry",
    "View Entry",
    "Add Expense",
    "View Expenses",
    "Allot Consignments",
    "View Consignments",
    "Payments",
    // "Add Entry 2.0",
    // "View Entry 2.0",
  ];

  List<RecentConginmentResponse> _recentConsignmentList = [];

  List<RecentConginmentResponse> get recentConsignmentList =>
      _recentConsignmentList;

  set recentConsignmentList(
      List<RecentConginmentResponse> recentConsignmentList) {
    _recentConsignmentList = recentConsignmentList;
    notifyListeners();
  }

  List<KilometerReportResponse> _kmReportListData = [];

  List<KilometerReportResponse> get kmReportListData => _kmReportListData;

  set kmReportListData(List<KilometerReportResponse> kmReportListData) {
    _kmReportListData = kmReportListData;
    notifyListeners();
  }

  Future getBarGraphKmReport(String selectedDuration) async {
    kmReportListData.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    notifyListeners();
    try {
      final res = await apiService.getBarGraphKmReport(selectedDurationValue);
      if (res.statusCode == 200) {
        if (res is String) {
          snackBarService.showSnackbar(message: res.toString());
        } else if (res.data is List) {
          var list = res.data as List;
          if (list.length > 0) {
            for (Map singleDay in list) {
              KilometerReportResponse singleDayReport =
                  KilometerReportResponse.fromJson(singleDay);
              kmReportListData.add(singleDayReport);
            }
            print('*******************');
            print(
                'No of bars in getBarGraphKmRepost view model call ---- ${kmReportListData.length}');
            print('*******************');
          }
        } else {
          snackBarService.showSnackbar(message: 'No Data');
        }
      }
      notifyListeners();
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    var response = await apiService.getClientsList();
    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      var clientsList = apiResponse.data as List;

      clientsList.forEach((element) {
        GetClientsResponse getClientsResponse =
            GetClientsResponse.fromMap(element);
        this.clientsList.add(getClientsResponse);
      });
    }
    setBusy(false);
    notifyListeners();
  }

  getDashboardTilesStats(String clientId) async {
    setBusy(true);
    var tilesData = await apiService.getDashboardTilesStats(clientId);
    if (tilesData is String) {
      snackBarService.showSnackbar(message: tilesData);
    } else {
      singleClientTileData =
          DashboardTilesStatsResponse.fromJson(tilesData.data);
      print('single Client Tile data-----${singleClientTileData.hubCount}');
      setBusy(false);
      notifyListeners();
    }
  }

  getRecentConsignments() async {
    recentConsignmentList.clear();
    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRecentConsignments();
      if (res.statusCode == 200) {
        // snackBarService.showSnackbar(message: res.toString());
      } else if (res.data is List) {
        var list = res.data as List;
        if (list.length > 0) {
          for (Map singleConsignment in list) {
            RecentConginmentResponse singleConsignmentResponse =
                RecentConginmentResponse.fromJson(singleConsignment);
            recentConsignmentList.add(singleConsignmentResponse);
          }
          print('in dash view model==========$recentConsignmentList');
        } else {
          snackBarService.showSnackbar(message: 'No Consignments');
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  takeToAddEntryPage() {
    navigationService.navigateTo(addEntryLogPageRoute);
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

  //! For testing purpose it is navigating to searchPageRoute
  takeToViewConsignmentsPage() {
    navigationService.navigateTo(searchPageRoute);
  }
}
