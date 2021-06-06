import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/single_pending_consignments_item.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class RecentConsignmentListViewModel extends GeneralisedBaseViewModel {
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
  Set<String> recentConsignmentsDateList = Set();
  List<SinglePendingConsignmentListItem> recentConsignmentsList = [];
  getRecentConsignmentsForCreateConsignment() async {
    setBusy(true);
    recentConsignmentsList = [];
    recentConsignmentsDateList = Set();
    List<SinglePendingConsignmentListItem> response =
        await _consignmentApis.getRecentConsignmentsForCreateConsignment(
            clientId: MyPreferences()?.getSelectedClient()?.clientId);

    response.forEach((element) {
      recentConsignmentsDateList.add(element.entryDate);
    });

    recentConsignmentsList = copyList(response);

    setBusy(false);
    notifyListeners();
  }

  List<SinglePendingConsignmentListItem> getConsolidatedData(int index) {
    return recentConsignmentsList
        .where((element) =>
            element.entryDate == recentConsignmentsDateList.elementAt(index))
        .toList();
  }
}
