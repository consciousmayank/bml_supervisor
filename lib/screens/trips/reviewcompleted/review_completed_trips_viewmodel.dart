import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/completed_trips_details.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/screens/dailykms/daily_entry_api.dart';
import 'package:bml_supervisor/screens/trips/reviewcompleted/review_remarks_bottom_sheet.dart';
import 'package:bml_supervisor/screens/trips/trips_apis.dart';
import 'package:bml_supervisor/screens/trips/tripsdetailed/detailedTripsArgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked_services/stacked_services.dart';

class ReviewCompletedTripsViewModel extends GeneralisedBaseViewModel {
  CompletedTripsDetailsResponse _completedTripsDetails;
  DailyEntryApisImpl _dailyEntryApis = locator<DailyEntryApisImpl>();

  int _startReading, _endReading;

  int get startReading => _startReading;

  set startReading(int value) {
    _startReading = value;
    notifyListeners();
  }

  CompletedTripsDetailsResponse get completedTripsDetails =>
      _completedTripsDetails;

  set completedTripsDetails(CompletedTripsDetailsResponse value) {
    _completedTripsDetails = value;
  }

  TripsApis _tripsApis = locator<TripsApisImpl>();

  getCompletedTripsWithId({
    @required int consignmentId,
  }) async {
    setBusy(true);
    completedTripsDetails = await _tripsApis.getCompletedTripsWithId(
      consignmentId: consignmentId,
    );
    startReading = completedTripsDetails.startReading;
    endReading = completedTripsDetails.endReading;
    setBusy(false);
    notifyListeners();
  }

  getKmDiff() {
    int difference =
        completedTripsDetails.endReading - completedTripsDetails.startReading;
    return difference;
  }

  submitVehicleEntry(EntryLog entryLogRequest) async {
    setBusy(true);
    ApiResponse apiResponse = await _dailyEntryApis.submitVehicleEntry(
        entryLogRequest: entryLogRequest);

    if (apiResponse.isSuccessful()) {
      var dialogResponse =
          await locator<DialogService>().showConfirmationDialog(
        title: 'Congratulations...',
        description: apiResponse.message,
      );
      if (dialogResponse == null || dialogResponse.confirmed) {
        navigationService.back(
            result: ReturnDetailedTripsViewArgs(
                success: true, tripStatus: TripStatus.COMPLETED));
      }
    }
    setBusy(false);
  }

  showConfirmationBottomSheet({@required EntryLog entryLogRequest}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: false,
      variant: BottomSheetType.COMPLETED_TRIP_REVIEW_REMARKS,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        ReviewRemarksBottomSheetOutputArgs args = sheetResponse.responseData;
        if (args != null) {
          submitVehicleEntry(
            entryLogRequest.copyWith(remarks: args.remarks),
          );
        }
      }
    }
  }

  showRejectConfirmationBottomSheet({@required int consignmentId}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      isScrollControlled: false,
      variant: BottomSheetType.REJECT_DRIVER_TRIP,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        rejectSelectedTrip(
          consignmentId: consignmentId,
        );
      }
    }
  }

  get endReading => _endReading;

  set endReading(value) {
    _endReading = value;
    notifyListeners();
  }

  void rejectSelectedTrip({@required int consignmentId}) async {
    setBusy(true);
    ApiResponse apiResponse = await _tripsApis.rejectCompletedTripWithId(
        consignmentId: consignmentId);
    setBusy(false);
    if (apiResponse.isSuccessful()) {
      var dialogResponse =
          await locator<DialogService>().showConfirmationDialog(
        title: 'Congratulations...',
        description: apiResponse.message,
      );
      if (dialogResponse == null || dialogResponse.confirmed) {
        navigationService.back(
            result: ReturnDetailedTripsViewArgs(
                success: true, tripStatus: TripStatus.COMPLETED));
      }
    }
  }
}
