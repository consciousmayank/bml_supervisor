import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ConsignmentAllotmentViewModel extends GeneralisedBaseViewModel {
  CreateConsignmentRequest consignmentRequest;
  SearchByRegNoResponse validatedRegistrationNumber;
  DateTime _entryDate;
  String _enteredTitle; //final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeyList = [];
  double grandTotal = 0;
  List<GlobalKey<FormState>> get formKeyList => _formKeyList;

  set formKeyList(List<GlobalKey<FormState>> value) {
    _formKeyList = value;
  }

  String get enteredTitle => _enteredTitle;

  set enteredTitle(String value) {
    _enteredTitle = value;
  }

  DateTime get entryDate => _entryDate;
  List<FetchHubsResponse> _hubsList = [];

  List<FetchHubsResponse> get hubsList => _hubsList;

  set hubsList(List<FetchHubsResponse> value) {
    _hubsList = value;
    grandTotal = 0;
    notifyListeners();
  }

  set entryDate(DateTime selectedDate) {
    _entryDate = selectedDate;
    notifyListeners();
  }

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
    notifyListeners();
  }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
  }

  GetRoutesResponse _selectedRoute;
  List<GetRoutesResponse> _routesList = [];

  List<GetRoutesResponse> get routesList => _routesList;

  set routesList(List<GetRoutesResponse> value) {
    _routesList = value;
    notifyListeners();
  }

  GetRoutesResponse get selectedRoute => _selectedRoute;

  set selectedRoute(GetRoutesResponse selectedRoute) {
    _selectedRoute = selectedRoute;
    notifyListeners();
  }

  getRoutes(int clientId) async {
    setBusy(true);
    routesList = [];
    hubsList = [];
    var response = await apiService.getRoutesForClient(clientId: clientId);

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      var routesList = apiResponse.data as List;

      routesList.forEach((element) {
        GetRoutesResponse getRoutesResponse =
            GetRoutesResponse.fromMap(element);

        this.routesList.add(getRoutesResponse);
      });
    }
    setBusy(false);
    notifyListeners();
  }

  getClientIds() async {
    var clientIdsResponse = await apiService.getClientsList();
    if (clientIdsResponse is String) {
      snackBarService.showSnackbar(message: clientIdsResponse);
    } else {
      Response apiResponse = clientIdsResponse;
      var clientsList = apiResponse.data as List;

      clientsList.forEach((element) {
        GetClientsResponse getClientsResponse =
            GetClientsResponse.fromMap(element);
        _clientsList.add(getClientsResponse);
      });
      notifyListeners();
    }
  }

  getHubs() async {
    hubsList = [];
    var consignmentResponse = await apiService.getHubsForRouteAndClientId(
        routeId: selectedRoute.id,
        clientId: selectedClient.id,
        entryDate: null);

    if (consignmentResponse is String) {
      snackBarService.showSnackbar(message: consignmentResponse);
    } else {
      Response apiResponse = consignmentResponse;
      List hubsList = apiResponse.data as List;
      hubsList.forEach((element) {
        _hubsList.add(FetchHubsResponse.fromMap(element));
      });
    }
    setBusy(false);
    notifyListeners();
  }

  void validateRegistrationNumber(String regNum) async {
    setBusy(true);

    var entryLog = await apiService.searchByRegistrationNumber(regNum);
    if (entryLog is String) {
      snackBarService.showSnackbar(message: entryLog);
    } else if (entryLog.data['status'].toString() == 'failed') {
      setBusy(false);
      snackBarService.showSnackbar(message: "No Results found for \"$regNum\"");
    } else {
      validatedRegistrationNumber =
          SearchByRegNoResponse.fromMap(entryLog.data);
      initializeConsignments();
      setBusy(false);
    }
  }

  void initializeConsignments() {
    List<Item> items = [];
    _hubsList.forEach((element) {
      _formKeyList.add(GlobalKey<FormState>());
      print("Element Flag :: ${element.flag}");
      items.add(
        Item(
          hubId: element.id,
          sequence: element.sequence,
          flag: element.flag,
        ),
      );
    });

    consignmentRequest = CreateConsignmentRequest(
        vehicleId: validatedRegistrationNumber.registrationNumber,
        clientId: selectedClient.id,
        routeId: selectedRoute.id,
        entryDate: getConvertedDate(entryDate),
        title: enteredTitle,
        items: items);
  }

  void createConsignment({String consignmentTitle}) async {
    consignmentRequest = consignmentRequest.copyWith(title: consignmentTitle);
    List<Item> tempItems = consignmentRequest.items;

    tempItems.forEach((element) {
      element.copyWith(
        paymentId: "NA",
        remarks: element.remarks.length == 0 ? "NA" : element.remarks,
        title: element.title.length == 0 ? "NA" : element.title,
      );
    });

    // var createConsignmentResponse =
    //     await apiService.createConsignment(consignmentRequest);
    // if (createConsignmentResponse is String) {
    //   snackBarService.showSnackbar(message: createConsignmentResponse);
    // } else {
    //   Response apiResponse = createConsignmentResponse;
    //   ApiResponse response = ApiResponse.fromMap(apiResponse.data);
    //   if (response.status == 'failed') {
    //     setBusy(false);
    //     snackBarService.showSnackbar(message: "${response.message}");
    //   } else {
    //     dialogService
    //         .showConfirmationDialog(
    //             title: response.message,
    //             description:
    //                 "You can edit the consignment, in View Consignment.")
    //         .then((value) => navigationService.back());
    //     setBusy(false);
    //   }
    // }
  }
}
