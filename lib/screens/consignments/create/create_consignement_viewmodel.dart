import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/fetch_hubs_response.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateConsignmentModel extends GeneralisedBaseViewModel {
  double _totalWeight = 0.00;

  double get totalWeight => _totalWeight;

  set totalWeight(double value) {
    _totalWeight = value;
  }

  DashBoardApis _dashBoardApis = locator<DashBoardApisImpl>();
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
  bool _isHubTitleEdited = false,
      _isDropCratesEdited = false,
      _isCollectCratesEdited = false,
      _isPaymentEdited = false,
      _isRemarksEdited = false;

  bool get isHubTitleEdited => _isHubTitleEdited;

  set isHubTitleEdited(bool value) {
    _isHubTitleEdited = value;
    notifyListeners();
  }

  String _itemUnit;

  String get itemUnit => _itemUnit;

  set itemUnit(String itemUnit) {
    _itemUnit = itemUnit;
    notifyListeners();
  }

  CreateConsignmentRequest _consignmentRequest;
  SearchByRegNoResponse _validatedRegistrationNumber;
  DateTime _entryDate;
  TimeOfDay _dispatchTime = TimeOfDay.now();

  TimeOfDay get dispatchTime => _dispatchTime;

  set dispatchTime(TimeOfDay value) {
    _dispatchTime = value;
    notifyListeners();
  }

  String _enteredTitle; //final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeyList = [];

  // double grandTotal = 0;
  List<GlobalKey<FormState>> get formKeyList => _formKeyList;

  CreateConsignmentRequest get consignmentRequest => _consignmentRequest;

  set consignmentRequest(CreateConsignmentRequest value) {
    _consignmentRequest = value;
    notifyListeners();
  }

  SearchByRegNoResponse get validatedRegistrationNumber =>
      _validatedRegistrationNumber;

  set validatedRegistrationNumber(SearchByRegNoResponse value) {
    _validatedRegistrationNumber = value;
    notifyListeners();
  }

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
    notifyListeners();
  }

  set entryDate(DateTime selectedDate) {
    _entryDate = selectedDate;
    validatedRegistrationNumber = null;
    consignmentRequest = null;
    notifyListeners();
  }

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse value) {
    _selectedClient = value;
    notifyListeners();
  }

  FetchRoutesResponse _selectedRoute;
  FetchRoutesResponse get selectedRoute => _selectedRoute;

  set selectedRoute(FetchRoutesResponse selectedRoute) {
    _selectedRoute = selectedRoute;
    notifyListeners();
  }

  getClients() async {
    setBusy(true);
    selectedClient = MyPreferences()?.getSelectedClient();
    setBusy(false);
  }

  getHubs() async {
    hubsList = [];
    List<FetchHubsResponse> hubList =
        await _dashBoardApis.getHubs(routeId: selectedRoute.routeId);
    this.hubsList = copyList(hubList);
    setBusy(false);
    notifyListeners();
  }

  void validateRegistrationNumber(String regNum) async {
    consignmentRequest = null;
    setBusy(true);
    validatedRegistrationNumber =
        await _consignmentApis.getVehicleDetails(registrationNumber: regNum);
    if (validatedRegistrationNumber != null) {
      initializeConsignments();
    } else {
      snackBarService.showSnackbar(
          message: 'Vehicle with registration number $regNum not found.');
    }
    setBusy(false);
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
            hubCity: element.city,
            hubContactPerson: element.contactPerson,
            hubGeoLatitude: element.geoLatitude,
            hubGeoLongitude: element.geoLongitude,
            hubTitle: element.title),
      );
    });

    consignmentRequest = CreateConsignmentRequest(
        itemUnit: itemUnit,
        weight: this.totalWeight,
        vehicleId: validatedRegistrationNumber.registrationNumber,
        clientId: selectedClient.clientId,
        routeId: selectedRoute.routeId,
        entryDate: getConvertedDate(entryDate),
        dispatchDateTime: getConvertedDateWithTime(DateTime(
            entryDate.year,
            entryDate.month,
            entryDate.day,
            dispatchTime.hour,
            dispatchTime.minute)),
        title: enteredTitle,
        routeTitle: selectedRoute.routeTitle,
        items: items);
  }

  void createConsignment({String consignmentTitle}) async {
    setBusy(true);
    consignmentRequest = consignmentRequest.copyWith(
      dropOff: consignmentRequest.items.last.dropOff,
      collect: consignmentRequest.items.first.collect,
      payment: consignmentRequest.getTotalPayment(),
      title: consignmentTitle,
      itemUnit: itemUnit,
      weight: this.totalWeight,
    );

    List<Item> tempItems = consignmentRequest.items;

    tempItems.forEach((element) {
      element.copyWith(
        paymentId: "NA",
        remarks: element?.remarks?.length == 0 ? "NA" : element.remarks,
        title: element.title.length == 0 ? "NA" : element.title,
      );
    });

    ApiResponse createConsignmentResponse = await _consignmentApis
        .createConsignment(createConsignmentRequest: consignmentRequest);

    bottomSheetService
        .showCustomSheet(
      customData: ConfirmationBottomSheetInputArgs(
        title: createConsignmentResponse.message,
      ),
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
    )
        .then(
      (value) {
        if (createConsignmentResponse.isSuccessful()) {
          navigationService.replaceWith(allotConsignmentsPageRoute);
        }
      },
    );

    setBusy(false);
  }

  get isDropCratesEdited => _isDropCratesEdited;

  set isDropCratesEdited(value) {
    _isDropCratesEdited = value;
    notifyListeners();
  }

  get isCollectCratesEdited => _isCollectCratesEdited;

  set isCollectCratesEdited(value) {
    _isCollectCratesEdited = value;
    notifyListeners();
  }

  get isPaymentEdited => _isPaymentEdited;

  set isPaymentEdited(value) {
    _isPaymentEdited = value;
    notifyListeners();
  }

  get isRemarksEdited => _isRemarksEdited;

  set isRemarksEdited(value) {
    _isRemarksEdited = value;
    notifyListeners();
  }

  void resetControllerBoolValue() {
    _isHubTitleEdited = _isDropCratesEdited =
        _isCollectCratesEdited = _isPaymentEdited = _isRemarksEdited = false;
  }

  List<ConsignmentsForSelectedDateAndClientResponse> _consignmentsList = [];

  List<ConsignmentsForSelectedDateAndClientResponse> get consignmentsList =>
      _consignmentsList;

  set consignmentsList(
      List<ConsignmentsForSelectedDateAndClientResponse> value) {
    _consignmentsList = value;
    notifyListeners();
  }

  getConsignmentListWithDate() async {
    setBusy(true);
    consignmentsList = [];
    List<ConsignmentsForSelectedDateAndClientResponse> response =
        await _consignmentApis.getConsignmentsForSelectedDateAndClient(
            date: getDateString(entryDate), clientId: selectedClient.clientId);

    consignmentsList = copyList(response);

    setBusy(false);
    notifyListeners();
  }

  Future consignmentsListBottomSheet() async {
    await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      barrierDismissible: true,
      customData: consignmentsList,
      variant: BottomSheetType.consignmentList,
    );
  }
}
