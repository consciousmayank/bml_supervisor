import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';

class DistributorsScreenViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  List<GetDistributorsResponse> distributorsResponseList = [];

  GetClientsResponse _selectedClientForTransactionList;

  GetClientsResponse get selectedClientForTransactionList =>
      _selectedClientForTransactionList;

  set selectedClientForTransactionList(
      GetClientsResponse selectedClientForTransactionList) {
    _selectedClientForTransactionList = selectedClientForTransactionList;
    notifyListeners();
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

  getClients() async {
    setBusy(true);
    clientsList = [];
    //* get bar graph data too when populating the client dropdown

    List<GetClientsResponse> responseList =
        await _dashBoardApis.getClientList();
    this.clientsList = Utils().copyList(responseList);

    setBusy(false);
    notifyListeners();
  }

  void getDistributors({@required GetClientsResponse selectedClient}) async {
    distributorsResponseList.clear();
    setBusy(true);
    notifyListeners();
    var response =
        await _dashBoardApis.getDistributors(clientId: selectedClient.clientId);
    distributorsResponseList = Utils().copyList(response);
    notifyListeners();
    setBusy(false);
  }
}
