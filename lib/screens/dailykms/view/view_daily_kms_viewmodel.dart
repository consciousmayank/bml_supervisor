import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/models/view_entry_request.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/screens/dailykms/daily_entry_api.dart';
import 'package:bml_supervisor/screens/dailykms/view/view_daily_kms_bottom_sheet.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/gridViewBottomSheet/grid_view_bottomSheet.dart';
// import 'package:bml_supervisor/widget/gridViewBottomSheet/bottomsheet_grid_view.dart';

class ViewDailyKmsViewModel extends GeneralisedBaseViewModel {
  DailyEntryApis _dailyEntryApis = locator<DailyEntryApisImpl>();
  int _totalKm = 0;
  Set _datesSet = Set();

  int get totalKm => _totalKm;
  int _totalKmGround = 0;

  int _kmDifference = 0;

  double _totalFuelInLtr = 0.0;

  double _avgPerLitre = 0.0;

  double _totalFuelAmt = 0.0;

  int _entryCount = 0;

  int get entryCount => _entryCount;

  set entryCount(int value) {
    _entryCount = value;
  }

  GetClientsResponse _selectedClient;

  GetClientsResponse get selectedClient => _selectedClient;

  set selectedClient(GetClientsResponse selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<ViewEntryResponse> vehicleEntrySearchResponseList = [];

  List<SearchByRegNoResponse> searchResponse = [];

  String _selectedRegistrationNumber = "";

  String get selectedRegistrationNumber => _selectedRegistrationNumber;

  set selectedRegistrationNumber(String selectedRegistrationNumber) {
    _selectedRegistrationNumber = selectedRegistrationNumber;
    notifyListeners();
  }

  SearchByRegNoResponse _selectedVehicle;

  SearchByRegNoResponse get selectedVehicle => _selectedVehicle;

  set selectedVehicle(SearchByRegNoResponse selectedVehicle) {
    _selectedVehicle = selectedVehicle;
    notifyListeners();
  }

  ViewEntryResponse _vehicleLog; // _vehicleLog -> _viewEntryResponse

  ViewEntryResponse get vehicleLog => _vehicleLog;

  set vehicleLog(ViewEntryResponse vehicleLog) {
    _vehicleLog = vehicleLog;
    notifyListeners();
  }

  int getSelectedDurationValue(String selectedDuration) {
    switch (selectedDuration) {
      case 'THIS MONTH':
        return 1;
      case 'LAST MONTH':
        return 2;
      default:
        return 1;
    }
  }

  getClients() async {
    selectedClient = MyPreferences()?.getSelectedClient();
  }

  void vehicleEntrySearch({String regNum, int clientId}) async {
    entryCount = 0;
    vehicleEntrySearchResponseList.clear();
    _vehicleLog = null;
    notifyListeners();
    setBusy(true);

    final List<ViewEntryResponse> res = await _dailyEntryApis.getDailyEntries(
      viewEntryRequest: ViewEntryRequest(
        clientId: clientId ?? "",
        vehicleId: regNum ?? "",
      ),
    );

    vehicleEntrySearchResponseList = copyList(res);
    vehicleEntrySearchResponseList.forEach((element) {
      _datesSet.add(element.entryDate);
      _totalKmGround += element.drivenKmGround;
      _totalFuelInLtr += element.fuelLtr;
      _totalKm += element.drivenKm;
      _totalFuelAmt += element.amountPaid;
      entryCount++;
    });
    if (!(_totalKm == 0 && _totalKmGround == 0)) {
      _kmDifference = _totalKmGround - _totalKm;
    }
    if ((_totalKm != 0 && _totalFuelInLtr != 0)) {
      _avgPerLitre = _totalKm / _totalFuelInLtr;
    }
    // takeToViewEntryDetailedPage2Point0();

    notifyListeners();
    setBusy(false);
  }

  Set get datesSet => _datesSet;

  int get totalKmGround => _totalKmGround;

  int get kmDifference => _kmDifference;

  double get totalFuelInLtr => _totalFuelInLtr;

  double get avgPerLitre => _avgPerLitre;

  double get totalFuelAmt => _totalFuelAmt;

  Future showMonthYearBottomSheet() async {
    await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: true,
      // customData: tempList,
      customData: DailyKmPeriodBottomSheetInputArgs(
        sheetTitle: 'Daily Km Period',
        options: tempList,
        selectedOption: tempList.first,
      ),
      variant: BottomSheetType.VIEW_ENTRY_PERIOD,
    );
  }

  void openDailyEntryDetailsBottomSheet({ViewEntryResponse clickedDailyEntry}) {
    List<GridViewHelper> helperList = [
      GridViewHelper(
        label: 'Vehicle Number',
        value: clickedDailyEntry.vehicleId.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Entry Date',
        value: clickedDailyEntry.entryDate.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Start Reading',
        value: clickedDailyEntry.startReading.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Start Reading (G)',
        value: clickedDailyEntry.startReadingGround.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'End Reading',
        value: clickedDailyEntry.endReading.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Trips',
        value: clickedDailyEntry.trips.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Driven KM',
        value: clickedDailyEntry.drivenKm.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Driven KM (G)',
        value: clickedDailyEntry.drivenKmGround.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Fuel (Ltr)',
        value: clickedDailyEntry.fuelLtr.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Fuel Meter Reading',
        value: clickedDailyEntry.fuelMeterReading.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Rate Per Ltr',
        value: clickedDailyEntry.ratePerLtr.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Amount Paid',
        value: clickedDailyEntry.amountPaid.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Login Time',
        value: clickedDailyEntry.loginTime.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Logout Time',
        value: clickedDailyEntry.logoutTime.toString(),
        onValueClick: null,
      ),
    ];

    List<GridViewHelper> footerListEx = [
      GridViewHelper(
        label: 'Description',
        value: clickedDailyEntry.remarks,
        onValueClick: null,
      ),
    ];

    bottomSheetService.showCustomSheet(
      customData: GridViewBottomSheetInputArgument(
        headerList: [],
        title: 'Entry Details',
        footerList: footerListEx,
        gridList: helperList,
      ),
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.VIEW_ENTRY_DETAILS,
    );
  }
}
