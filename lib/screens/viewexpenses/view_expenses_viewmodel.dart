// Added by Vikas
// Subject to change
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:dio/dio.dart';

class ViewExpensesViewModel extends GeneralisedBaseViewModel {
  double _totalExpenses = 0.0;
  List<ViewExpensesResponse> viewExpensesResponse = [];
  SearchByRegNoResponse _selectedSearchVehicle;
  SearchByRegNoResponse get selectedSearchVehicle => _selectedSearchVehicle;
  set selectedSearchVehicle(SearchByRegNoResponse selectedSearchVehicle) {
    _selectedSearchVehicle = selectedSearchVehicle;
    notifyListeners();
  }

  String _selectedDuration = "";
  String get selectedDuration => _selectedDuration;

  set selectedDuration(String selectedDuration) {
    _selectedDuration = selectedDuration;
    notifyListeners();
  }

  String _vehicleRegNumber;
  String get vehicleRegNumber => _vehicleRegNumber;
  set vehicleRegNumber(String vehicleRegNumber) {
    _vehicleRegNumber = vehicleRegNumber;
    notifyListeners();
  }

  String _expenseEntryDate;

  String get expenseEntryDate => _expenseEntryDate;
  set expenseEntryDate(String expenseEntryDate) {
    _expenseEntryDate = expenseEntryDate;
    notifyListeners();
  }

  String _expenseType;
  String get expenseType => _expenseType;
  set expenseType(String expenseType) {
    _expenseType = expenseType;
    notifyListeners();
  }

  String _expenseAmount;
  String get expenseAmount => _expenseAmount;
  set expenseAmount(String expenseAmount) {
    _expenseAmount = expenseAmount;
    notifyListeners();
  }

  String _expenseDesc;
  String get expenseDesc => _expenseDesc;
  set expenseDesc(String expenseDesc) {
    _expenseDesc = expenseDesc;
    notifyListeners();
  }

  DateTime _fromDate;
  DateTime get fromDate => _fromDate;
  set fromDate(DateTime fromDate) {
    _fromDate = fromDate;
    notifyListeners();
  }

  bool _emptyDateSelector = false;
  bool get emptyDateSelector => _emptyDateSelector;

  set emptyDateSelector(bool emptyDateSelector) {
    _emptyDateSelector = emptyDateSelector;
  }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse _selectedClient;
  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  // void takeToSearch() async {
  //   selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  // }

  getClients() async {
    setBusy(true);
    clientsList = [];
    // call client api
    // get the data as list
    // add Book my loading at 0
    // pupulate the clients dropdown
    var response = await apiService.getClientsList();

    setBusy(false);
    notifyListeners();
  }

  void getExpensesList(
      {String regNum, String selectedDuration, String clientId}) async {
    viewExpensesResponse.clear();
    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;
    print(
        '**selected client: $clientId selected duration: $selectedDuration, selected reg num $vehicleRegNumber');
    // final uptoDate =
    //     DateFormat('dd-MM-yyyy').format(DateTime.now()).toLowerCase();
    notifyListeners();
    setBusy(true);
    try {
      final res = await apiService.getExpensesList(
        registrationNumber: regNum,
        clientId: clientId,
        duration: selectedDurationValue.toString(),
      );

      if (res.data is! List) {
        print('data is not list');
        snackBarService.showSnackbar(message: "No Results found for $regNum");
      } else {
        if (res.statusCode == 200) {
          var list = res.data as List;
          if (list.length > 0) {
            for (Map singleItem in list) {
              ViewExpensesResponse singleSearchResult =
                  ViewExpensesResponse.fromMap(singleItem);
              viewExpensesResponse.add(singleSearchResult);
              _totalExpenses += singleSearchResult.expenseAmount;
            }
            print('total expenses before sending' + _totalExpenses.toString());

            takeToViewExpenseDetailedPage();
          } else {
            snackBarService.showSnackbar(
                message: "No Results found for \"$regNum\"");
          }
        }
      }
      // }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  void takeToViewExpenseDetailedPage() {
    print(
        'before sending - expense type: $viewExpensesResponse[0].expenseType');

    navigationService.navigateTo(
      viewExpensesDetailedViewPageRoute,
      arguments: {
        'viewExpensesDetailedList': viewExpensesResponse,
        'totalExpenses': _totalExpenses,
        'selectedClient':
            selectedClient == null ? 'All Clients' : selectedClient.title
      },
    ).then((value) {
      vehicleRegNumber = null;
      _totalExpenses = 0.0;
      // selectedDuration = null;
    });
  }
}
