import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';
import 'package:bml_supervisor/models/payment_list_aggregate.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/payments/payments_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class PaymentsViewModel extends GeneralisedBaseViewModel {
  PaymentsApis _paymentsApis = locator<PaymentsApisImpl>();
  int pageNumber = 1;
  PaymentListAggregate _paymentListAggregate;
  Set<String> paymentDates = Set();
  PaymentListAggregate get paymentListAggregate => _paymentListAggregate;

  set paymentListAggregate(PaymentListAggregate paymentListAggregate) {
    _paymentListAggregate = paymentListAggregate;
  }

  List<PaymentHistoryResponse> paymentHistoryResponseList = [];

  void onAddPaymentClicked() {
    navigationService.navigateTo(addPaymentPageRoute).then((value) {
      pageNumber = 1;
      notifyListeners();
      getPaymentHistory();
      getPaymentListAggregate();
    });
  }

  getPaymentHistory() async {
    if (pageNumber <= 1) {
      setBusy(true);
      paymentHistoryResponseList.clear();
    }

    notifyListeners();

    var response = await _paymentsApis.getPaymentHistory(
        clientId: MyPreferences().getSelectedClient().id,
        pageNumber: pageNumber);
    if (pageNumber <= 1) {
      paymentHistoryResponseList = copyList(response);
    } else {
      paymentHistoryResponseList.addAll(
        copyList(response),
      );
    }
    paymentHistoryResponseList.forEach((element) {
      paymentDates.add(element.entryDate);
    });
    pageNumber++;
    paymentHistoryResponseList.forEach((element) {});
    notifyListeners();
    setBusy(false);
  }

  void getPaymentListAggregate() async {
    setBusy(true);
    paymentListAggregate = await _paymentsApis.getPaymentListAggregate(
      clientId: MyPreferences().getSelectedClient().id,
    );
    getPaymentHistory();
  }

  List getConsolidatedList(int outerListIndex) {
    return paymentHistoryResponseList
        .where((element) =>
            element.entryDate == paymentDates.elementAt(outerListIndex))
        .toList();
  }
}
