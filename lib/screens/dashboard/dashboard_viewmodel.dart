import 'package:bml_supervisor/app_level/generalised_indextracking_view_model.dart';
import 'package:bml_supervisor/models/dashborad_tiles_response.dart';
import 'package:bml_supervisor/models/km_report_response.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:bml_supervisor/models/routes_driven_km_percetage.dart';
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
    Icons.access_alarm,
    Icons.payment,
  ];

  int colorArrayIndex = 0;

  List<Color> dashboardChartsColorArray = [
    Color(0xff68cfc6),
    Color(0xffd89cb8),
    Color(0xfffcce5e),
    Color(0xfffc8685),
    Color(0xff28a745),
    Color(0xffc3e6cb),
    Color(0xffdc3545),
    Color(0xff6c757d),
  ];
  List<List<RoutesDrivenKm>> data = List<List<RoutesDrivenKm>>();
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
    "View Routes",
    "View Consignments",
    "Payments",
    // "Add Entry 2.0",
    // "View Entry 2.0",
  ];

  List<RecentConginmentResponse> recentConsignmentList = [];
  List<RoutesDrivenKm> routesDrivenKmList = [];
  List<RoutesDrivenKmPercentage> routesDrivenKmPercentageList = [];
  List uniqueRoutes = [];
  double totalDrivenKmG = 0.0;

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
        }
        if (res.data is List) {
          var list = res.data as List;
          if (list.length > 0) {
            for (Map singleDay in list) {
              KilometerReportResponse singleDayReport =
                  KilometerReportResponse.fromJson(singleDay);
              kmReportListData.add(singleDayReport);
            }
          }
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

  void getRoutesDrivenKm() async {
    routesDrivenKmList.clear();

    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;

    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRoutesDrivenKm();
      if (res.data is List) {
        var list = res.data as List;
        if (list.length > 0) {
          for (Map value in list) {
            RoutesDrivenKm routesDrivenKmResponse =
                RoutesDrivenKm.fromJson(value);
            routesDrivenKmList.add(routesDrivenKmResponse);
          }
          routesDrivenKmList.forEach((routesDrivenKmObject) {
            if (!uniqueRoutes.contains(routesDrivenKmObject.routeId)) {
              uniqueRoutes.add(routesDrivenKmObject.routeId);
            }
          });

          uniqueRoutes.forEach(
            (singleRouteElement) {
              data.add(routesDrivenKmList
                  .where((routeDrivenKmObject) =>
                      routeDrivenKmObject.routeId == singleRouteElement)
                  .toList());
            },
          );

          // uniqueRoutes.forEach((singleRouteElement) {
          //   List<RoutesDrivenKm> tempList = [];
          //   routesDrivenKmList.forEach((singleRoutesDrivenKm) {
          //     if (singleRoutesDrivenKm.routeId == singleRouteElement) {
          //       tempList.add(singleRoutesDrivenKm);
          //     } else {
          //       tempList.add(RoutesDrivenKm(
          //           drivenKm: 0,
          //           entryDate: singleRoutesDrivenKm.entryDate,
          //           routeId: singleRoutesDrivenKm.routeId,
          //           vehicleId: singleRoutesDrivenKm.vehicleId,
          //           drivenKmG: singleRoutesDrivenKm.drivenKm,
          //           title: singleRoutesDrivenKm.title));
          //     }
          //   });

          //   data.add(tempList);
          // });

          //! For printing line chart data, coming from api
          // int i = 1;
          // data.forEach((element) {
          //   print('*****************Route R $i**********************');
          //   element.forEach((element2) {
          //     print("route id :: ${element2.routeId.toString()}");
          //     print("driven km :: ${element2.drivenKm.toString()}");
          //     print("Entrt Date :: ${element2.entryDate.toString()}");
          //   });
          //   print('*****************************************************');
          //   i++;
          // });
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  void getRoutesDrivenKmPercentage() async {
    routesDrivenKmPercentageList.clear();
    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRoutesDrivenKmPercentage();
      if (res.data is List) {
        var list = res.data as List;
        if (list.length > 0) {
          for (Map value in list) {
            RoutesDrivenKmPercentage routesDrivenKmPercentageResponse =
                RoutesDrivenKmPercentage.fromJson(value);
            routesDrivenKmPercentageResponse =
                routesDrivenKmPercentageResponse.copyWith(
              color: dashboardChartsColorArray[colorArrayIndex],
            );
            ++colorArrayIndex;
            totalDrivenKmG += routesDrivenKmPercentageResponse.drivenKmG;
            routesDrivenKmPercentageList.add(routesDrivenKmPercentageResponse);
          }
          routesDrivenKmPercentageList.forEach((element) {
            print(element.color);
            print(dashboardChartsColorArray[0]);
          });
          print('totalDrivenKmG: $totalDrivenKmG');
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  void takeToAllConsgnmentsPage() {
    print('taking to takeToAllConsgnmentsPage');
    navigationService.navigateTo(viewAllConsignmentsViewPageRoute,
        arguments: recentConsignmentList);
  }

  getRecentConsignments(String selectedDuration) async {
    recentConsignmentList.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;

    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRecentConsignments(selectedDurationValue);
      if (res.data is List) {
        var list = res.data as List;
        if (list.length > 0) {
          for (Map singleConsignment in list) {
            RecentConginmentResponse singleConsignmentResponse =
                RecentConginmentResponse.fromJson(singleConsignment);
            recentConsignmentList.add(singleConsignmentResponse);
          }
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
}
