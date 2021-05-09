import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/single_pending_consignments_item.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/review/review_consignment_args.dart';
import 'package:flutter/cupertino.dart';
import 'package:bml/bml.dart';

import '../consignment_api.dart';

class PendingConsignmentsListViewModel extends GeneralisedBaseViewModel {
  List<SinglePendingConsignmentListItem> pendingConsignmentsList = [];
  Set<String> pendingConsignmentsDateList = Set();
  int pageIndex = 0;

  getPendingConsignmentsList({@required showLoading}) async {
    ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
    if (showLoading) {
      setBusy(true);
      pendingConsignmentsList = [];
      pendingConsignmentsDateList = Set();
      pageIndex = 0;
    }

    List<SinglePendingConsignmentListItem> response =
        await _consignmentApis.getPendingConsignmentsList(
            clientId: preferences.getSelectedClient().clientId,
            pageIndex: pageIndex);
    response.forEach((element) {
      pendingConsignmentsDateList.add(element.entryDate);
    });
    if (pageIndex == 0) {
      pendingConsignmentsList = Utils().copyList(response);
    } else {
      pendingConsignmentsList.addAll(response);
    }

    pageIndex++;
    if (showLoading) setBusy(false);
    notifyListeners();
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
        getPendingConsignmentsList(
          showLoading: true,
        );
      }
    });
  }
}
