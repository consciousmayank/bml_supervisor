import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/expense_response.dart';
import 'package:bml_supervisor/models/get_daily_kilometers_info.dart';
import 'package:bml_supervisor/models/save_expense_request.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/consignments/consignment_api.dart';
import 'package:bml_supervisor/screens/dailykms/daily_entry_api.dart';
import 'package:bml_supervisor/screens/expenses/add/add_expense_arguments.dart';
import 'package:bml_supervisor/screens/expenses/add/expenses_mobile_view.dart';
import 'package:bml_supervisor/screens/expenses/expenses_api.dart';
import 'package:bml_supervisor/utils/datetime_converter.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ExpensesViewModel extends GeneralisedBaseViewModel {
  String entryDateError = '',
      vehicleIdError = '',
      expenseTypeError = '',
      totalAmountError = '',
      descriptionError = '',
      fuelRateError = '',
      fuelLitreError = '',
      fuelMeterReadingError = '';
  double fuelRate, fuelLitre;
  int fuelMeterReading;
  int pageNumber = 1;
  double expenseAmount = -1.0;
  String expenseDescription = '';
  bool _callGetEntriesApi = true;
  List<GetClientsResponse> _clientsList = [];
  ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
  DailyEntryApis _dailyEntryApis = locator<DailyEntryApisImpl>();
  List<GetDailyKilometerInfo> _dailyKmInfoList = [];
  DateTime _entryDate;
  String _expenseType;
  ExpensesApi _expensesApi = locator<ExpensesApisImpl>();
  List<ExpenseResponse> _expensesList = [];
  bool _getLastSevenDaysExpenses = false;
  bool _isExpenseListLoading = false;
  bool _isRegNumCorrect = false;
  ApiResponse _saveExpenseResponse;
  GetClientsResponse _selectedClient;
  GetDailyKilometerInfo _selectedDailyKmInfo = GetDailyKilometerInfo(
    vehicleId: null,
    clientId: MyPreferences().getSelectedClient().clientId,
    routeId: 0,
    routeTitle: '',
  );

  SearchByRegNoResponse _selectedSearchVehicle;
  bool _showSubmitForm = false;
  SearchByRegNoResponse _validatedRegistrationNumber;

  List<String> expenseTypes;

  SearchByRegNoResponse get validatedRegistrationNumber =>
      _validatedRegistrationNumber;

  set validatedRegistrationNumber(SearchByRegNoResponse value) {
    _validatedRegistrationNumber = value;
    notifyListeners();
  }

  List<GetDailyKilometerInfo> get dailyKmInfoList => _dailyKmInfoList;

  set dailyKmInfoList(List<GetDailyKilometerInfo> value) {
    _dailyKmInfoList = value;
    notifyListeners();
  }

  GetDailyKilometerInfo get selectedDailyKmInfo => _selectedDailyKmInfo;

  set selectedDailyKmInfo(GetDailyKilometerInfo value) {
    _selectedDailyKmInfo = value;
  }

  bool get isRegNumCorrect => _isRegNumCorrect;

  set isRegNumCorrect(bool isRegNumCorrect) {
    _isRegNumCorrect = isRegNumCorrect;
    notifyListeners();
  }

  DateTime get entryDate => _entryDate;

  List<ExpenseResponse> get expensesList => _expensesList;

  set expensesList(List<ExpenseResponse> expensesList) {
    _expensesList = expensesList;
    notifyListeners();
  }

  bool get isExpenseListLoading => _isExpenseListLoading;

  set isExpenseListLoading(bool isExpenseListLoading) {
    _isExpenseListLoading = isExpenseListLoading;
    notifyListeners();
  }

  bool get callGetEntriesApi => _callGetEntriesApi;

  set callGetEntriesApi(bool callGetEntriesApi) {
    _callGetEntriesApi = callGetEntriesApi;
    notifyListeners();
  }

  bool get getLastSevenDaysExpenses => _getLastSevenDaysExpenses;

  ApiResponse get saveExpenseResponse => _saveExpenseResponse;

  set saveExpenseResponse(ApiResponse saveExpenseResponse) {
    _saveExpenseResponse = saveExpenseResponse;
    notifyListeners();
  }

  set entryDate(DateTime entryDate) {
    _entryDate = entryDate;
    // fromDate = entryDate.add(Duration(days: -7));
    pageNumber = 1;
    // getExpensesList();
    notifyListeners();
  }

  bool get showSubmitForm => _showSubmitForm;

  set showSubmitForm(bool showSubmitForm) {
    _showSubmitForm = showSubmitForm;
    notifyListeners();
  }

  // DateTime get fromDate => _fromDate;

  String get expenseType => _expenseType;

  set expenseType(String expenseType) {
    _expenseType = expenseType;
    notifyListeners();
  }

  SearchByRegNoResponse get selectedSearchVehicle => _selectedSearchVehicle;

  set selectedSearchVehicle(SearchByRegNoResponse selectedSearchVehicle) {
    _selectedSearchVehicle = selectedSearchVehicle;
    notifyListeners();
  }

  List<GetClientsResponse> get clientsList => _clientsList;

  set clientsList(List<GetClientsResponse> value) {
    _clientsList = value;
    notifyListeners();
  }

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  void takeToSearch() async {
    selectedSearchVehicle = await navigationService.navigateTo(searchPageRoute);
  }

  void saveExpense() async {
    SaveExpenseRequest saveExpenseRequest = SaveExpenseRequest(
      clientId: selectedDailyKmInfo.clientId,
      vehicleId: selectedDailyKmInfo.vehicleId,
      entryDate: DateTimeToStringConverter.ddmmyy(date: entryDate).convert(),
      expenseType: expenseType,
      expenseAmount: expenseAmount,
      expenseDesc: expenseDescription,
      fuelLtr: fuelLitre ?? 0.00,
      fuelMeterReading: fuelMeterReading ?? 0,
      ratePerLtr: fuelRate ?? 0,
    );

    setBusy(true);
    isExpenseListLoading = true;
    ApiResponse response =
        await _expensesApi.addExpense(saveExpenseRequest: saveExpenseRequest);

    if (response.isSuccessful()) {
      bottomSheetService
          .showCustomSheet(
        customData: ConfirmationBottomSheetInputArgs(
          title: response.message,
        ),
        barrierDismissible: false,
        isScrollControlled: true,
        variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
      )
          .then(
        (value) {
          if (response.isSuccessful()) {
            navigationService.replaceWith(addExpensesPageRoute, arguments: AddExpenseArguments(
            expensesTypes: expenseTypes,
          ));
          }
        },
      );
    }
    setBusy(false);
    isExpenseListLoading = false;
  }

  void getInfo() async {
    setBusy(true);
    var response = await _dailyEntryApis.getDailyKmInfo(
      date: getDateString(entryDate),
    );
    dailyKmInfoList = copyList(response);
    setBusy(false);
  }

  void validateRegistrationNumber({@required String regNum}) async {
    setBusy(true);
    validatedRegistrationNumber =
        await _consignmentApis.getVehicleDetails(registrationNumber: regNum);
    if (validatedRegistrationNumber == null) {
      snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(
          seconds: 4,
        ),
        message: 'Vehicle with registration number $regNum not found.',
      );
    }
    notifyListeners();
    setBusy(false);
  }

  bool validateViews({@required Function onErrorOccured}) {
    if (entryDate == null) {
      snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(seconds: 4),
        message: 'Please select entry date',
        mainButtonTitle: 'Ok',
        onMainButtonTapped: () {
          onErrorOccured(WidgetType.ENTRY_DATE_WIDGET);
        },
      );
      entryDateError = textRequired;
      return false;
    }
    if (selectedDailyKmInfo.vehicleId == null) {
      snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(seconds: 4),
        message: 'Please select a vehicle',
        mainButtonTitle: 'Ok',
        onMainButtonTapped: () {
          onErrorOccured(WidgetType.VEHICLE_SEARCH_WIDGET);
        },
      );
      vehicleIdError = textRequired;
      return false;
    } else if (expenseType == null) {
      snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(seconds: 4),
        message: 'Please select an expense type',
        mainButtonTitle: 'Ok',
        onMainButtonTapped: () {},
      );
      expenseTypeError = textRequired;
      return false;
    } else if (expenseAmount < 0) {
      snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(seconds: 4),
        message: 'Please enter expense amount',
        mainButtonTitle: 'Ok',
        onMainButtonTapped: () {
          onErrorOccured(WidgetType.AMOUNT_WIDGET);
        },
      );
      totalAmountError = textRequired;
      return false;
    } else if (expenseAmount == 0) {
      snackBarService.showCustomSnackBar(
        variant: SnackbarType.ERROR,
        duration: Duration(seconds: 4),
        message: 'Please check expense amount',
        mainButtonTitle: 'Ok',
        onMainButtonTapped: () {
          onErrorOccured(WidgetType.AMOUNT_WIDGET);
        },
      );
      totalAmountError = 'Amount cannot be 0';
      return false;
    } else if (expenseDescription.length == 0) {
      expenseDescription = 'NA';
      return true;
    } else if (expenseType == "FUEL") {
      if (fuelMeterReading == null) {
        snackBarService.showCustomSnackBar(
          variant: SnackbarType.ERROR,
          duration: Duration(seconds: 4),
          message: 'Selected expense \'Fuel\' requires meter reading.',
          mainButtonTitle: 'Ok',
          onMainButtonTapped: () {
            onErrorOccured(WidgetType.FUEL_METER_READING);
          },
        );
        fuelMeterReadingError = textRequired;
        return false;
      } else if (fuelMeterReading != null && fuelMeterReading == 0) {
        snackBarService.showCustomSnackBar(
          variant: SnackbarType.ERROR,
          duration: Duration(seconds: 4),
          message: 'Selected expense \'Fuel\' requires meter reading.',
          mainButtonTitle: 'Ok',
          onMainButtonTapped: () {
            onErrorOccured(WidgetType.FUEL_METER_READING);
          },
        );
        fuelMeterReadingError = 'Meter reading cannot be 0';
        return false;
      } else if (fuelLitre == null) {
        snackBarService.showCustomSnackBar(
          variant: SnackbarType.ERROR,
          duration: Duration(seconds: 4),
          message: 'Selected expense \'Fuel\' requires fuel added in liters.',
          mainButtonTitle: 'Ok',
          onMainButtonTapped: () {
            onErrorOccured(WidgetType.FUEL_LITERS);
          },
        );
        fuelMeterReadingError = textRequired;
        return false;
      } else if (fuelLitre != null && fuelLitre == 0) {
        snackBarService.showCustomSnackBar(
          variant: SnackbarType.ERROR,
          duration: Duration(seconds: 4),
          message: 'Selected expense \'Fuel\' requires fuel added in liters.',
          mainButtonTitle: 'Ok',
          onMainButtonTapped: () {
            onErrorOccured(WidgetType.FUEL_LITERS);
          },
        );
        fuelMeterReadingError = 'Added fuel cannot be 0';
        return false;
      } else if (fuelRate == null) {
        snackBarService.showCustomSnackBar(
          variant: SnackbarType.ERROR,
          duration: Duration(seconds: 4),
          message: 'Selected expense \'Fuel\' requires fuel rate.',
          mainButtonTitle: 'Ok',
          onMainButtonTapped: () {
            onErrorOccured(WidgetType.FUEL_RATE);
          },
        );
        fuelMeterReadingError = textRequired;
        return false;
      } else if (fuelRate != null && fuelRate == 0) {
        snackBarService.showCustomSnackBar(
          variant: SnackbarType.ERROR,
          duration: Duration(seconds: 4),
          message: 'Selected expense \'Fuel\' requires fuel rate.',
          mainButtonTitle: 'Ok',
          onMainButtonTapped: () {
            onErrorOccured(WidgetType.FUEL_RATE);
          },
        );
        fuelMeterReadingError = 'Fuel rate cannot be 0';
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
    
  }
}
