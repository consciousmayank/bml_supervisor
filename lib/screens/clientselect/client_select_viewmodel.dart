import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ClientSelectViewModel extends GeneralisedBaseViewModel {
  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  List<GetClientsResponse> _clientsList = [];
  bool shouldCallGetClientListApi = true;
  int pageNumber = 1;
  GetClientsResponse _preSelectedClient;

  GetClientsResponse get preSelectedClient => _preSelectedClient;

  set preSelectedClient(GetClientsResponse value) {
    _preSelectedClient = value;
    notifyListeners();
  }

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  getClientList({@required bool showLoading}) async {
    if (shouldCallGetClientListApi) {
      if (showLoading) {
        setBusy(true);
        clientsList = [];
      }
      List<GetClientsResponse> responseList =
          await _dashBoardApis.getClientList(pageNumber: pageNumber);

      if (responseList.length > 0) {
        if (pageNumber == 0) {
          clientsList = copyList(responseList);
        } else {
          clientsList.addAll(responseList);
        }
        pageNumber++;
      } else {
        shouldCallGetClientListApi = false;
      }
      if (showLoading) setBusy(false);
      notifyListeners();
    }
  }

  void takeToDashBoard() {
    navigationService.replaceWith(dashBoardPageRoute);
  }
}
