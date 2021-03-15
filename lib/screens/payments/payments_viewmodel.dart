import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/payments/payments_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

class PaymentsViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  PaymentsApis _paymentsApis = locator<PaymentsApisImpl>();

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

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  List<PaymentHistoryResponse> paymentHistoryResponseList = [];

  DateTime _entryDate;

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime registrationDate) {
    _entryDate = registrationDate;
    notifyListeners();
  }

  bool _emptyDateSelector = false;

  bool get emptyDateSelector => _emptyDateSelector;

  set emptyDateSelector(bool emptyDateSelector) {
    _emptyDateSelector = emptyDateSelector;
    notifyListeners();
  }

  String _selectedDuration = "";

  String get selectedDuration => _selectedDuration;

  set selectedDuration(String selectedDuration) {
    _selectedDuration = selectedDuration;
    notifyListeners();
  }

  GetClientsResponse _selectedClientForTransactionList;

  GetClientsResponse get selectedClientForTransactionList =>
      _selectedClientForTransactionList;

  set selectedClientForTransactionList(
      GetClientsResponse selectedClientForTransactionList) {
    _selectedClientForTransactionList = selectedClientForTransactionList;
    notifyListeners();
  }

  GetClientsResponse _selectedClientForNewTransaction;

  GetClientsResponse get selectedClientForNewTransaction =>
      _selectedClientForNewTransaction;

  set selectedClientForNewTransaction(
      GetClientsResponse selectedClientForNewTransaction) {
    _selectedClientForNewTransaction = selectedClientForNewTransaction;
    notifyListeners();
  }

  Future addNewPayment(SavePaymentRequest savePaymentRequest) async {
    setBusy(true);
    ApiResponse response = await _paymentsApis.addNewPayment(
        savePaymentRequest: savePaymentRequest);
    snackBarService.showSnackbar(message: response.message);
    setBusy(false);
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    print('selected client: $selectedClientForTransactionList');
    _clientsList = copyList(await _dashBoardApis.getClientList());

    setBusy(false);
    notifyListeners();
  }

  getPaymentHistory(String clientId) async {
    totalAmt = 0.0;
    noOfPayments = 0;
    paymentHistoryResponseList.clear();
    notifyListeners();
    setBusy(true);
    var response = await _paymentsApis.getPaymentHistory(clientId: clientId);
    paymentHistoryResponseList = copyList(response);

    paymentHistoryResponseList.forEach((element) {
      totalAmt += element.amount;
      noOfPayments++;
    });

    notifyListeners();
    setBusy(false);
  }
}
