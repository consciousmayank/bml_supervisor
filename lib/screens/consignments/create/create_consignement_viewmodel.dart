import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/screens/consignments/create/create_consignment_params.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/screens/driver/driver_apis.dart';
import 'package:bml_supervisor/screens/temp_hubs/hubs_list/temp_hubs_list_args.dart';
import 'package:bml_supervisor/utils/datetime_converter.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateConsignmentModel extends GeneralisedBaseViewModel {
  double _totalWeight = 0.00;

  double get totalWeight => _totalWeight;

  set totalWeight(double value) {
    _totalWeight = value;
    notifyListeners();
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
  String consignmentTitle;

  String get itemUnit => _itemUnit;

  set itemUnit(String itemUnit) {
    _itemUnit = itemUnit;
    notifyListeners();
  }

  CreateConsignmentRequest _consignmentRequest;
  // SearchByRegNoResponse _validatedRegistrationNumber;
  DateTime _entryDate;
  TimeOfDay _dispatchTime;

  TimeOfDay get dispatchTime => _dispatchTime;

  set dispatchTime(TimeOfDay value) {
    _dispatchTime = value;
    notifyListeners();
  }

  List<GlobalKey<FormState>> _formKeyList = [];

  // double grandTotal = 0;
  List<GlobalKey<FormState>> get formKeyList => _formKeyList;

  CreateConsignmentRequest get consignmentRequest => _consignmentRequest;

  set consignmentRequest(CreateConsignmentRequest value) {
    _consignmentRequest = value;
    notifyListeners();
  }

  // SearchByRegNoResponse get validatedRegistrationNumber =>
  //     _validatedRegistrationNumber;

  // set validatedRegistrationNumber(SearchByRegNoResponse value) {
  //   _validatedRegistrationNumber = value;
  //   notifyListeners();
  // }

  set formKeyList(List<GlobalKey<FormState>> value) {
    _formKeyList = value;
  }

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime selectedDate) {
    _entryDate = selectedDate;
    // validatedRegistrationNumber = null;
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

  // getHubs() async {
  //   hubsList = [];
  //   List<FetchHubsResponse> hubList =
  //       await _dashBoardApis.getHubs(routeId: selectedRoute.routeId);
  //   this.hubsList = copyList(hubList);
  //   setBusy(false);
  //   notifyListeners();
  // }

  // void validateRegistrationNumber(String regNum) async {
  //   consignmentRequest = null;
  //   setBusy(true);
  //   validatedRegistrationNumber =
  //       await _consignmentApis.getVehicleDetails(registrationNumber: regNum);
  //   if (validatedRegistrationNumber != null) {
  //     initializeConsignments();
  //   } else {
  //     snackBarService.showSnackbar(
  //         message: 'Vehicle with registration number $regNum not found.');
  //   }
  //   setBusy(false);
  // }

  // this.hubTitle,
  // this.hubCity,
  // this.hubContactPerson,
  // this.hubGeoLatitude,
  // this.hubGeoLongitude,
  // this.hubId,
  // this.sequence,
  // this.title,
  // this.dropOff,
  // this.collect,
  // this.payment,
  // this.dropOffG,
  // this.collectG,
  // this.paymentG,
  // this.paymentMode,
  // this.paymentId,
  // this.remarks,
  // this.flag,
  // this.collectError = false,
  // this.dropOffError = false,
  // this.paymentError = false,
  // this.titleError = false,

  void initializeConsignments({
    List<SingleTempHub> hubsList,
  }) {
    List<Item> items = [];
    hubsList.forEach((element) {
      _formKeyList.add(GlobalKey<FormState>());

      items.add(
        Item(
          hubTitle: element.title,
          hubCity: element.city,
          hubContactPerson: element.contactPerson,
          hubGeoLatitude: element.geoLatitude,
          hubGeoLongitude: element.geoLongitude,
          hubId: element.consignmentId,
          sequence: hubsList.indexOf(element),
          title: 'NA',
          dropOff: element.dropOff.toInt(),
          collect: element.collect.toInt(),
          payment: 0,
          dropOffG: 0,
          collectG: 0,
          paymentG: 0,
          paymentMode: 0,
          paymentId: 'NA',
          remarks: "NA",
          flag: '',
        ),
      );
    });

    consignmentRequest = CreateConsignmentRequest(
      itemUnit: itemUnit,
      weight: this.totalWeight,
      vehicleId: selectedDriver.vehicleId,
      clientId: selectedClient.clientId,
      routeId: selectedRoute.routeId,
      entryDate: getConvertedDate(entryDate),
      dispatchDateTime: DateTimeToStringConverter.ddmmyyhhmmssaa(
              date: DateTime(entryDate.year, entryDate.month, entryDate.day,
                  dispatchTime.hour, dispatchTime.minute))
          .convert()
          .toUpperCase(),
      title: consignmentTitle,
      routeTitle: selectedRoute.routeTitle,
      items: items,
      dropOff: items.last.dropOff,
      collect: items.first.collect,
      payment: 0,
    );
  }

  void createConsignment() async {
    setBusy(true);

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

  //Get Driver
  DriverInfo selectedDriver;

  DriverApis _driverApis = locator<DriverApisImpl>();
  int pageNumber = 1;
  List<DriverInfo> _driversList = [];
  bool shouldCallGetDriverListApi = true;

  List<DriverInfo> get driversList => _driversList;

  set driversList(List<DriverInfo> driversList) {
    _driversList = driversList;
    notifyListeners();
  }

  getDriversList({@required bool showLoading}) async {
    if (shouldCallGetDriverListApi) {
      if (showLoading) {
        setBusy(true);
        driversList = [];
      }

      List<DriverInfo> response = await _driverApis.getDriversList(
        pageNumber: pageNumber,
      );
      if (response.length > 0) {
        if (pageNumber == 0) {
          driversList = copyList(response);
        } else {
          driversList.addAll(response);
        }

        pageNumber++;
      } else {
        shouldCallGetDriverListApi = false;
      }
      if (showLoading) setBusy(false);
      notifyListeners();
    }
  }

  void takeToAddHubsView() {
    navigationService
        .navigateTo(
      tempHubsListPostReviewConsigPageRoute,
      arguments: TempHubsListInputArguments(
        reviewedConsigId: 0,
        callingScreen: CallingScreen.CREATE_CONSIGNMENT,
      ),
    )
        .then((value) {
      if (value != null) {
        TempHubsListToCreateConsigmentArguments args = value;
        notifyListeners();
        initializeConsignments(hubsList: copyList(args.hubList));
        showSummaryBottomSheet();
      }
    });
  }

  showSummaryBottomSheet() async {
    locator<BottomSheetService>()
        .showCustomSheet(
      isScrollControlled: true,
      barrierDismissible: true,
      variant: BottomSheetType.createConsignmentSummary,
      // Which builder you'd like to call that was assigned in the builders function above.
      customData: CreateConsignmentDialogParams(
        selectedClient: selectedClient,
        selectedDriver: selectedDriver,
        consignmentRequest: consignmentRequest.copyWith(
          weight: totalWeight,
        ),
        selectedRoute: selectedRoute,
        itemUnit: itemUnit,
      ),
    )
        .then((value) {
      if (value != null && value.confirmed) {
        createConsignment();
      }
    });
  }
}
