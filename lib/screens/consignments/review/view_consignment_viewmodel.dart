import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml_supervisor/models/consignment_details.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart';
import 'package:bml_supervisor/models/review_consignment_request.dart'
    as reviewConsignment;
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/screens/dailykms/daily_entry_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:bml/bml.dart';

class ViewConsignmentViewModel extends GeneralisedBaseViewModel {
  DailyEntryApisImpl _dailyEntryApis = locator<DailyEntryApisImpl>();
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();

  bool isInitiallyDataSet = false;
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

  String _itemUnitG;

  String get itemUnitG => _itemUnitG;

  set itemUnitG(String itemUnitG) {
    _itemUnitG = itemUnitG;
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

  getClientIds() async {
    setBusy(true);
    selectedClient = preferences.getSelectedClient();
    setBusy(false);
  }

  getRoutes(String clientId) async {
    setBusy(true);
    routesList = [];
    hubList = [];
    List<RoutesForSelectedClientAndDateResponse> response =
        await _dailyEntryApis.getRoutesForSelectedClientAndDate(
      clientId: clientId,
      date: Utils().getDateString(entryDate),
    );
    this.routesList = Utils().copyList(response);
    setBusy(false);
    notifyListeners();
  }

  // get Consignments' list for it's dropdown

  getConsignmentListWithDate() async {
    setBusy(true);
    consignmentsList = [];
    List<ConsignmentsForSelectedDateAndClientResponse> response =
        await _consignmentApis.getConsignmentsForSelectedDateAndClient(
            date: Utils().getDateString(entryDate),
            clientId: selectedClient.clientId);

    consignmentsList = Utils().copyList(response);

    setBusy(false);
    notifyListeners();
  }

  Future getConsignmentWithId({@required String consignmentId}) async {
    setBusy(true);
    reviewConsignmentRequest = ReviewConsignmentRequest();
    reviewConsignmentRequest.reviewedItems = [];
    consignmentDetailResponseNew = await _consignmentApis.getConsignmentWithId(
        consignmentId: consignmentId);

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

    setBusy(false);
    notifyListeners();
  }

  void updateConsignment() async {
    // hit the update Consignment api
    reviewConsignmentRequest = reviewConsignmentRequest.copyWith(
      assessBy: preferences.getUserLoggedIn().userName,
    );
    reviewConsignmentRequest.reviewedItems.forEach((element) {
      element.copyWith(
        paymentId: 'NA',
        remarks: element.remarks.length == 0 ? 'NA' : element.remarks,
        title: element.title.length == 0 ? 'NA' : element.title,
      );
    });
    ApiResponse apiResponse = await _consignmentApis.updateConsignment(
      consignmentId: consignmentDetailResponseNew.id,
      putRequest: reviewConsignmentRequest,
    );

    if (apiResponse.status == 'failed') {
      setBusy(false);
      snackBarService.showSnackbar(message: '${apiResponse.message}');
    } else {
      // print('')
      dialogService
          .showConfirmationDialog(
              title: apiResponse.message, description: 'Consignment Reviewed.')
          .then((value) => navigationService.back(result: true));
      setBusy(false);
    }
  }
}
