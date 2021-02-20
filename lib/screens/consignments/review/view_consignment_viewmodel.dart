import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml_supervisor/models/consignment_details.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart'
    as reviewConsignment;
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ViewConsignmentViewModel extends GeneralisedBaseViewModel {
  // CreateConsignmentRequest consignmentRequest;
  // SearchByRegNoResponse validatedRegistrationNumber;
  ReviewConsignmentRequest reviewConsignmentRequest =
      ReviewConsignmentRequest();
  bool _isConsignmentAvailable = false;

  bool get isConsignmentAvailable => _isConsignmentAvailable;

  set isConsignmentAvailable(bool value) {
    _isConsignmentAvailable = value;
    notifyListeners();
  }

  DateTime _entryDate;
  GetClientsResponse _selectedClient;
  List<ConsignmentsForSelectedDateAndClientResponse> _consignmentsList = [];

  List<ConsignmentsForSelectedDateAndClientResponse> get consignmentsList =>
      _consignmentsList;

  set consignmentsList(
      List<ConsignmentsForSelectedDateAndClientResponse> value) {
    _consignmentsList = value;
    notifyListeners();
  }

  List<RoutesForSelectedClientAndDateResponse> _routesList = [];
  List<ConsignmentDetailsResponse> _hubList = [];

  List<ConsignmentDetailsResponse> get hubList => _hubList;

  set hubList(List<ConsignmentDetailsResponse> value) {
    _hubList = value;
  }

  ConsignmentDetailResponseNew _consignmentDetailResponseNew;

  ConsignmentDetailResponseNew get consignmentDetailResponseNew =>
      _consignmentDetailResponseNew;

  set consignmentDetailResponseNew(ConsignmentDetailResponseNew value) {
    _consignmentDetailResponseNew = value;
    notifyListeners();
  }

  List<GlobalKey<FormState>> _formKeyList = [];

  List<GlobalKey<FormState>> get formKeyList => _formKeyList;

  set formKeyList(List<GlobalKey<FormState>> value) {
    _formKeyList = value;
    notifyListeners();
  }

  ConsignmentsForSelectedDateAndClientResponse _selectedConsignment;

  ConsignmentsForSelectedDateAndClientResponse get selectedConsignment =>
      _selectedConsignment;

  set selectedConsignment(ConsignmentsForSelectedDateAndClientResponse value) {
    _selectedConsignment = value;
  }

  RoutesForSelectedClientAndDateResponse _selectedRoute;

  RoutesForSelectedClientAndDateResponse get selectedRoute => _selectedRoute;

  set selectedRoute(RoutesForSelectedClientAndDateResponse value) {
    _selectedRoute = value;
    notifyListeners();
  }

  List<RoutesForSelectedClientAndDateResponse> get routesList => _routesList;

  set routesList(List<RoutesForSelectedClientAndDateResponse> value) {
    _routesList = value;
  }

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
    notifyListeners();
  }

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime value) {
    _entryDate = value;
    notifyListeners();
  }

  List<GetClientsResponse> _clientsList = [];

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
  }

  getClientIds() async {
    var clientIdsResponse = await apiService.getClientsList();
  }

  getRoutes(int clientId) async {
    setBusy(true);
    routesList = [];
    hubList = [];
    var response = await apiService.getRoutesForSelectedClientAndDate(
      clientId: clientId,
      date: getDateString(entryDate),
    );

    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;

      try {
        var routesList = apiResponse.data as List;

        routesList.forEach((element) {
          RoutesForSelectedClientAndDateResponse routes =
              RoutesForSelectedClientAndDateResponse.fromMap(element);

          this.routesList.add(routes);
        });
      } catch (e) {
        snackBarService.showSnackbar(message: apiResponse.data['message']);
      }
    }
    setBusy(false);
    notifyListeners();
  }

  // get Consignments' list for it's dropdown

  getConsignmentListWithDate() async {
    setBusy(true);
    consignmentsList = [];
    print(getDateString(entryDate));
    var response = await apiService.getConsignmentListWithDate(
      entryDate: getDateString(entryDate),
    );
    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else {
      Response apiResponse = response;
      try {
        var responseList = apiResponse.data as List;
        responseList.forEach((element) {
          ConsignmentsForSelectedDateAndClientResponse consignment =
              ConsignmentsForSelectedDateAndClientResponse.fromMap(element);
          consignmentsList.add(consignment);
        });
        notifyListeners();
      } catch (e) {
        snackBarService.showSnackbar(message: apiResponse.data['message']);
      }
    }
    setBusy(false);
    notifyListeners();
  }

  void getConsignmentWithId(String consignmentId) async {
    setBusy(true);
    reviewConsignmentRequest = ReviewConsignmentRequest();
    reviewConsignmentRequest.reviewedItems = [];
    var response =
        await apiService.getConsignmentWithId(consignmentId: consignmentId);
    if (response is String) {
      snackBarService.showSnackbar(message: response);
    } else if (response.data['status'].toString() == 'failed') {
      // setBusy(false);
      snackBarService.showSnackbar(message: response.data['message']);
    } else {
      try {
        consignmentDetailResponseNew =
            ConsignmentDetailResponseNew.fromJson(response.data);
        consignmentDetailResponseNew.items.forEach((element) {
          reviewConsignmentRequest.reviewedItems.add(reviewConsignment.Item(
            consignmentId: element.consignmentId,
            title: element.title,
            payment: element.payment,
            collect: element.collect,
            dropOff: element.dropOff,
            flag: element.flag,
            hubId: element.hubId,
            paymentId: element.paymentId,
            paymentMode: element.paymentMode,
            remarks: element.remarks,
            sequence: element.sequence,
          ));
          _formKeyList.add(GlobalKey<FormState>());
        });
      } catch (e) {
        snackBarService.showSnackbar(message: e.toString());
      }
    }
    setBusy(false);
    notifyListeners();
  }

  void updateConsignment() async {
    // hit the update Consignment api
    //Todo: accessBy should be initialized by Username
    //TODO has to be changed post security
    reviewConsignmentRequest = reviewConsignmentRequest.copyWith(
      assessBy: 'Vikas',
    );
    reviewConsignmentRequest.reviewedItems.forEach((element) {
      element.copyWith(
        paymentId: 'NA',
        remarks: element.remarks.length == 0 ? 'NA' : element.remarks,
        title: element.title.length == 0 ? 'NA' : element.title,
      );
    });
    var updateConsignmentResponse = await apiService.updateConsignment(
      consignmentId: consignmentDetailResponseNew.id,
      putRequest: reviewConsignmentRequest,
    );

    if (updateConsignmentResponse is String) {
      print('i am string');
      snackBarService.showSnackbar(message: updateConsignmentResponse);
    } else {
      print('i am else');

      Response response = updateConsignmentResponse;
      print(response);
      ApiResponse apiResponse = ApiResponse.fromMap(response.data);
      if (apiResponse.status == 'failed') {
        setBusy(false);
        snackBarService.showSnackbar(message: '${apiResponse.message}');
      } else {
        // print('')
        dialogService
            .showConfirmationDialog(
                title: apiResponse.message,
                description: 'Consignment Reviewed.')
            .then((value) => navigationService.back());
        setBusy(false);
      }
    }
  }
}
