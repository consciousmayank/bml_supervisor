import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/payment_history_response.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:dio/dio.dart';

class PaymentsViewModel extends GeneralisedBaseViewModel {
  double _totalAmt = 0.0;
  int _page = 1;
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

  ApiResponse _savePaymentResponse;

  ApiResponse get savePaymentResponse => _savePaymentResponse;

  set savePaymentResponse(ApiResponse savePaymentResponse) {
    _savePaymentResponse = savePaymentResponse;
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
    var response = await apiService.addNewPayment(savePaymentRequest);
    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else if (response is Response) {
      savePaymentResponse = ApiResponse.fromMap(response.data);
      if (savePaymentResponse.status == "success") {
        snackBarService.showSnackbar(message: "Payment Added Successfully.");
      } else {
        snackBarService.showSnackbar(message: savePaymentResponse.message);
      }
    }
    setBusy(false);
  }

  getClients() async {
    setBusy(true);
    clientsList = [];
    print('selected client: $selectedClientForTransactionList');
    var response = await apiService.getClientsList();

    setBusy(false);
    notifyListeners();
  }

  getPaymentHistory(int clientId) async {
    totalAmt = 0.0;
    noOfPayments = 0;
    paymentHistoryResponseList.clear();
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.getPaymentHistory(
          clientId: clientId, pageNumber: _page);
      if (res.statusCode == 200) {
        if (res is String) {
          snackBarService.showSnackbar(message: res.toString());
        } else if (res.data is List) {
          var list = res.data as List;
          if (list.length > 0) {
            for (Map singlePayment in list) {
              PaymentHistoryResponse singlePaymentResponse =
                  PaymentHistoryResponse.fromJson(singlePayment);
              paymentHistoryResponseList.add(singlePaymentResponse);
              totalAmt += singlePaymentResponse.amount;
              noOfPayments++;
            }
            print('in view model:=========$paymentHistoryResponseList');
          }
        } else {
          snackBarService.showSnackbar(message: 'No Payments');
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }
}
