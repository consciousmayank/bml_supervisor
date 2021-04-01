import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'consignment_list_arguments.dart';

class ConsignmentListViewModel extends GeneralisedBaseViewModel {
  List<RecentConginmentResponse> recentConsignmentList = [];

  int clientId;
  String duration;

  void takeToDailyKilometersPage() {
    navigationService.navigateTo(viewEntryLogPageRoute);
  }

  void takeToConsignmentDetailsRoute(
      {@required ConsignmentDetailsArgument args}) {
    navigationService.navigateTo(
      consignmentListPageRoute,
      arguments: args,
    );
  }

  // getRecentConsignments({int clientId, String duration}) async {
  //   this.clientId = clientId;
  //   this.duration = duration;
  //   recentConsignmentList.clear();
  //   int selectedPeriodValue = duration == 'THIS MONTH' ? 1 : 2;
  //
  //   setBusy(true);
  //   notifyListeners();
  //   try {
  //     var res = await apiService.getRecentConsignments(
  //       clientId: clientId,
  //       period: selectedPeriodValue,
  //     );
  //     if (res.data is List) {
  //       var list = res.data as List;
  //       if (list.length > 0) {
  //         for (Map singleConsignment in list) {
  //           RecentConginmentResponse singleConsignmentResponse =
  //               RecentConginmentResponse.fromJson(singleConsignment);
  //           recentConsignmentList.add(singleConsignmentResponse);
  //         }
  //       }
  //     }
  //   } on DioError catch (e) {
  //     snackBarService.showSnackbar(message: e.message);
  //     setBusy(false);
  //   }
  //   notifyListeners();
  //   setBusy(false);
  // }

  void takeToAllConsignmentsPage() {
    navigationService.navigateTo(consignmentsListPageRoute,
        arguments: ConsignmentListArguments(
          clientId: this.clientId,
          duration: this.duration,
          isFulPageView: true,
        ));
  }
  getRecentDrivenKm({String clientId}) async {
    recentConsignmentList.clear();
    // int selectedPeriodValue = period.contains('THIS MONTH') ? 1 : 2;

    setBusy(true);
    notifyListeners();
    try {
      ParentApiResponse apiResponse = await apiService.getRecentDrivenKm(clientId: clientId);
      if (apiResponse.error == null) {
        if (apiResponse.isNoDataFound()) {
          snackBarService.showSnackbar(message: apiResponse.emptyResult);
        } else {
          if (apiResponse.response.data is List) {
            var list = apiResponse.response.data as List;
            if (list.length > 0) {
              for (Map singleConsignment in list) {
                RecentConginmentResponse singleConsignmentResponse =
                RecentConginmentResponse.fromJson(singleConsignment);
                recentConsignmentList.add(singleConsignmentResponse);
              }
            }
          }
        }
      } else {
        snackBarService.showSnackbar(message: apiResponse.getErrorReason());
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }
}
