import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';
import 'package:bml_supervisor/models/single_pending_consignments_item.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/foundation.dart';

class ConsignmentListByDateViewModel extends GeneralisedBaseViewModel {
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
  double _grandPayment = 0.0;
  List<SinglePendingConsignmentListItem> pendingConsignmentsList = [];
  Set<String> pendingConsignmentsDateList = Set();
  int pageIndex = 0;

  double get grandPayment => _grandPayment;

  set grandPayment(double value) {
    _grandPayment = value;
  }

  List<ConsignmentsForSelectedDateAndClientResponse> _consignmentsList = [];

  List<ConsignmentsForSelectedDateAndClientResponse> get consignmentsList =>
      _consignmentsList;

  set consignmentsList(
      List<ConsignmentsForSelectedDateAndClientResponse> value) {
    _consignmentsList = value;
    notifyListeners();
  }

  ConsignmentsForSelectedDateAndClientResponse _selectedConsignment;

  ConsignmentsForSelectedDateAndClientResponse get selectedConsignment =>
      _selectedConsignment;

  set selectedConsignment(ConsignmentsForSelectedDateAndClientResponse value) {
    _selectedConsignment = value;
  }

  DateTime _entryDate = DateTime.now();

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime value) {
    _entryDate = value;
    notifyListeners();
  }

  getConsignmentListWithDate() async {
    setBusy(true);
    consignmentsList = [];
    grandPayment = 0;

    var response =
        await _consignmentApis.getConsignmentsForSelectedDateAndClient(
      clientId: MyPreferences().getSelectedClient().clientId,
      date: getDateString(entryDate),
    );

    consignmentsList = copyList(response);

    setBusy(false);
    notifyListeners();
  }

  getConsignmentListPageWise({
    @required showLoading,
  }) async {
    // ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
    if (showLoading) {
      setBusy(true);
      pendingConsignmentsList = [];
      pendingConsignmentsDateList = Set();
    }

    List<SinglePendingConsignmentListItem> response =
        await _consignmentApis.getConsignmentListPageWise(
            clientId: MyPreferences().getSelectedClient().clientId,
            pageIndex: pageIndex);
    response.forEach((element) {
      pendingConsignmentsDateList.add(element.entryDate);
    });
    if (pageIndex == 0) {
      pendingConsignmentsList = copyList(response);
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

  void takeToConsignmentDetailPage({ConsignmentDetailsArgument args}) async {
    navigationService.navigateTo(consignmentDetailsPageRoute, arguments: args);
  }
}
