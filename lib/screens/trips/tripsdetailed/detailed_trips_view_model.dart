import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:stacked_services/stacked_services.dart';

import 'detailed_trips_bottom_sheet.dart';

class DetailedTripsViewModel extends GeneralisedBaseViewModel {
  List<ConsignmentTrackingStatusResponse> _trips = [];
  List<ConsignmentTrackingStatusResponse> completedTrips = [];
  List<ConsignmentTrackingStatusResponse> verifiedTrips = [];
  Set<String> completeTripsDate = Set();
  Set<String> verifiedTripsDate = Set();
  DashBoardApis _dashboardApi = locator<DashBoardApisImpl>();
  ConsignmentTrackingStatusResponse _selectedTripForEndingTrip;

  ConsignmentTrackingStatusResponse get selectedTripForEndingTrip =>
      _selectedTripForEndingTrip;

  set selectedTripForEndingTrip(ConsignmentTrackingStatusResponse value) {
    _selectedTripForEndingTrip = value;
  }

  List<ConsignmentTrackingStatusResponse> get trips => _trips;

  set trips(List<ConsignmentTrackingStatusResponse> value) {
    _trips = value;
  }

  void getCompletedAndVerifiedTrips() async {
    setBusy(true);
    List<ConsignmentTrackingStatusResponse> response;
    response = await _dashboardApi.getConsignmentTrackingStatus(
        tripStatus: TripStatus.COMPLETED,
        clientId: MyPreferences()?.getSelectedClient()?.clientId);
    completedTrips = copyList(response);
    completedTrips.forEach((element) {
      completeTripsDate.add(element.consignmentDate);
    });

    response = await _dashboardApi.getConsignmentTrackingStatus(
        tripStatus: TripStatus.APPROVED,
        clientId: MyPreferences()?.getSelectedClient()?.clientId);
    verifiedTrips = copyList(response);
    verifiedTrips.forEach((element) {
      verifiedTripsDate.add(element.consignmentDate);
    });
    setBusy(false);
    notifyListeners();
  }

  void getConsignmentTrackingStatus({TripStatus tripStatus}) async {
    setBusy(true);
    List<ConsignmentTrackingStatusResponse> response =
        await _dashboardApi.getConsignmentTrackingStatus(
            tripStatus: tripStatus,
            clientId: MyPreferences()?.getSelectedClient()?.clientId);
    trips = copyList(response);
    setBusy(false);
    notifyListeners();
  }

  void openBottomSheet({ConsignmentTrackingStatusResponse selectedTrip}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: false,
      isScrollControlled: false,
      customData: DetailedTripsBottomSheetInputArgs(clickedTrip: selectedTrip),
      variant: BottomSheetType.upcomingTrips,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        DetailedTripsBottomSheetOutputArgs args = sheetResponse.responseData;
        if (args != null) {
          reviewTrip(trip: args.clickedTrip);
        }
      }
    }
  }

  void reviewTrip({ConsignmentTrackingStatusResponse trip}) {
    navigationService
        .navigateTo(reviewCompletedTripsPageRoute, arguments: trip)
        .then((value) {
      completeTripsDate.clear();
      verifiedTripsDate.clear();
      getCompletedAndVerifiedTrips();
      // if (value != null) {
      //   ReturnDetailedTripsViewArgs returningArgs = value;
      //   if (returningArgs.success &&
      //       returningArgs.tripStatus == TripStatus.COMPLETED) {
      //     trips.clear();
      //     getConsignmentTrackingStatus();
      //   }
      // }
    });
  }

  void openWarningBottomSheet(
      {ConsignmentTrackingStatusResponse selectedTrip}) async {
    SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.REVIEW_TRIPS_WARNING,
    );

    if (sheetResponse != null) {
      if (sheetResponse.confirmed) {
        reviewTrip(trip: selectedTrip);
      }
    }
  }
}
