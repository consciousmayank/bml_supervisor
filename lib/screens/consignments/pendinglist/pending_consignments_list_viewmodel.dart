import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/single_pending_consignments_item.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/review/review_consignment_args.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';

import '../consignment_api.dart';

class PendingConsignmentsListViewModel extends GeneralisedBaseViewModel {
  List<SinglePendingConsignmentListItem> pendingConsignmentsList = [];
  Set<String> pendingConsignmentsDateList = Set();
  int pageIndex = 1;
  bool shouldCallPendingConsignmentsList = true;
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();

  getPendingConsignmentsList({@required showLoading}) async {
    if (shouldCallPendingConsignmentsList) {
      if (showLoading) {
        setBusy(true);
        pendingConsignmentsList = [];
        pendingConsignmentsDateList = Set();
        pageIndex = 1;
      }

      List<SinglePendingConsignmentListItem> response =
          await _consignmentApis.getPendingConsignmentsList(
              clientId: MyPreferences()?.getSelectedClient()?.clientId,
              pageIndex: pageIndex);

      if (response.length > 0) {
        if (pageIndex == 0) {
          pendingConsignmentsList = copyList(response);
        } else {
          pendingConsignmentsList.addAll(response);
        }
        response.forEach((element) {
          pendingConsignmentsDateList.add(element.entryDate);
        });
        pageIndex++;
      } else {
        shouldCallPendingConsignmentsList = false;
      }

      if (showLoading) setBusy(false);
      notifyListeners();
    }
  }

  List<SinglePendingConsignmentListItem> getConsolidatedData(int index) {
    return pendingConsignmentsList
        .where((element) =>
            element.entryDate == pendingConsignmentsDateList.elementAt(index))
        .toList();
  }

  void takeToReviewConsignment(
      {SinglePendingConsignmentListItem selectedConsignment}) {
    navigationService
        .navigateTo(
      viewConsignmentsPageRoute,
      arguments:
          ReviewConsignmentArgs(selectedConsignment: selectedConsignment),
    )
        .then((value) {
      if (value) {
        shouldCallPendingConsignmentsList = true;
        getPendingConsignmentsList(
          showLoading: true,
        );
      }
    });
  }
}
