import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/payments/payments_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class PaymentsViewModel extends GeneralisedBaseViewModel {
  PaymentsApis _paymentsApis = locator<PaymentsApisImpl>();
  int pageNumber = 1;
  double _totalAmt = 0.0;

  double get totalAmt => _totalAmt;

  set totalAmt(double value) {
    _totalAmt = value;
    notifyListeners();
  }

  int _noOfPayments = 0;

  int get noOfPayments => _noOfPayments;

  set noOfPayments(int value) {
    _noOfPayments = value;
    notifyListeners();
  }

  List<PaymentHistoryResponse> paymentHistoryResponseList = [];

  void onAddPaymentClicked() {
    navigationService.navigateTo(addPaymentPageRoute).then((value) {
      pageNumber = 1;
      notifyListeners();
      getPaymentHistory();
    });
  }

  getPaymentHistory() async {
    if (pageNumber <= 1) {
      setBusy(true);
      totalAmt = 0.0;
      noOfPayments = 0;
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
    pageNumber++;
    paymentHistoryResponseList.forEach((element) {
      totalAmt += element.amount;
      noOfPayments++;
    });
    notifyListeners();
    setBusy(false);
  }
}
