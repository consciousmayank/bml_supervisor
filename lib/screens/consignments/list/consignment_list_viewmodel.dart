import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';

import 'consignment_list_arguments.dart';

class ConsignmentListViewModel extends GeneralisedBaseViewModel {
  List<RecentConginmentResponse> recentConsignmentList = [];

  int clientId;
  String duration;

  getRecentConsignments({int clientId, String duration}) async {
    this.clientId = clientId;
    this.duration = duration;
    recentConsignmentList.clear();
    int selectedPeriodValue = duration == 'THIS MONTH' ? 1 : 2;

    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRecentConsignments(
        clientId: clientId,
        period: selectedPeriodValue,
      );
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

  void takeToAllConsignmentsPage() {
    navigationService.navigateTo(consignmentsListPageRoute,
        arguments: ConsignmentListArguments(
          clientId: this.clientId,
          duration: this.duration,
          isFulPageView: true,
        ));
  }
}
