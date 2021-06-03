import 'dart:collection';

import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/models/get_hub_details_response.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/dashboard/dashboard_apis.dart';
import 'package:bml_supervisor/utils/datetime_converter.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/gridViewBottomSheet/grid_view_bottomSheet.dart';
import 'package:bml_supervisor/widget/routes/routes_apis.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'detailed_trips_bottom_sheet.dart';

class DetailedTripsViewModel extends GeneralisedBaseViewModel {
  List<ConsignmentTrackingStatusResponse> _trips = [];
  List<ConsignmentTrackingStatusResponse> completedTrips = [];
  List<ConsignmentTrackingStatusResponse> verifiedTrips = [];
  Set<DateTime> completeTripsDate = Set();
  Set<DateTime> verifiedTripsDate = Set();
  DashBoardApis _dashboardApi = locator<DashBoardApisImpl>();
  RoutesApis _routesApis = locator<RoutesApisImpl>();
  GetHubDetailsResponse _srcHub;
  GetHubDetailsResponse _dstHub;

  GetHubDetailsResponse get srcHub => _srcHub;

  set srcHub(GetHubDetailsResponse value) {
    _srcHub = value;
    notifyListeners();
  }

  GetHubDetailsResponse _hubResponse;

  GetHubDetailsResponse get hubResponse => _hubResponse;

  set hubResponse(GetHubDetailsResponse value) {
    _hubResponse = value;
    notifyListeners();
  }

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

  void getSourceAndDestinationDetails(
      {int srcLocation,
      int dstLocation,
      ConsignmentTrackingStatusResponse selectedTrip}) async {
    setBusy(true);
    srcHub = await getHubDetailsByRouteId(hubId: srcLocation);
    dstHub = await getHubDetailsByRouteId(hubId: dstLocation);
    setBusy(false);

    notifyListeners();
    openDetailTripsBottomSheet(selectedTrip: selectedTrip);
  }

  Future<GetHubDetailsResponse> getHubDetailsByRouteId(
      {@required int hubId}) async {
    // setBusy(true);
    hubResponse = await _routesApis.getHubDetailsByHubId(hubId: hubId);
    // setBusy(false);
    notifyListeners();
    return hubResponse;
  }

  void getCompletedAndVerifiedTrips() async {
    setBusy(true);
    List<ConsignmentTrackingStatusResponse> response;
    response = await _dashboardApi.getConsignmentTrackingStatus(
        tripStatus: TripStatus.COMPLETED,
        clientId: MyPreferences()?.getSelectedClient()?.clientId);
    completedTrips = copyList(response);
    completedTrips.forEach((element) {
      completeTripsDate.add(
        StringToDateTimeConverter.ddmmyy(date: element.consignmentDate)
            .convert(),
      );
    });

    completeTripsDate =
        sortDateTimeSet(set: completeTripsDate, ascending: true);

    response = await _dashboardApi.getConsignmentTrackingStatus(
        tripStatus: TripStatus.APPROVED,
        clientId: MyPreferences()?.getSelectedClient()?.clientId);
    verifiedTrips = copyList(response);
    verifiedTrips.forEach((element) {
      verifiedTripsDate.add(
          StringToDateTimeConverter.ddmmyy(date: element.consignmentDate)
              .convert());
    });

    verifiedTripsDate =
        sortDateTimeSet(set: verifiedTripsDate, ascending: false);
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

  // void openBottomSheet({ConsignmentTrackingStatusResponse selectedTrip}) async {
  //   SheetResponse sheetResponse = await bottomSheetService.showCustomSheet(
  //     barrierDismissible: false,
  //     isScrollControlled: false,
  //     customData: DetailedTripsBottomSheetInputArgs(clickedTrip: selectedTrip),
  //     variant: BottomSheetType.upcomingTrips,
  //   );
  //
  //   if (sheetResponse != null) {
  //     if (sheetResponse.confirmed) {
  //       DetailedTripsBottomSheetOutputArgs args = sheetResponse.responseData;
  //       if (args != null) {
  //         reviewTrip(trip: args.clickedTrip);
  //       }
  //     }
  //   }
  // }

  String getHubDetailsForBottomSheet(GetHubDetailsResponse hub) {
    String hubDetails = hub.title;
    hubDetails = hubDetails + ', ' + hub.locality;
    if (hub.locality != hub.city) hubDetails = hubDetails + ', ' + hub.city;
    return hubDetails;
  }



  void openDetailTripsBottomSheet(
      {ConsignmentTrackingStatusResponse selectedTrip}) {

    List<GridViewHelper> footerList = [
      GridViewHelper(
        label: 'Remark',
        value: selectedTrip?.remark?.toString(),
        onValueClick: null,
      ),
    ];

    List<GridViewHelper> headerList = [
      GridViewHelper(
        label: 'Consignment Title',
        value: selectedTrip.consignmentTitle,
        onValueClick: null,
      ),

      GridViewHelper(
        label: 'Route Id',
        value: selectedTrip.routeId.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Route Title',
        value: selectedTrip.routeTitle,
        onValueClick: null,
      ),

      GridViewHelper(
        label: 'Route Description',
        value: selectedTrip.routeDesc,
        onValueClick: null,
      ),

      GridViewHelper(
        label: 'Source',
        value: getHubDetailsForBottomSheet(srcHub),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Destination',
        value: getHubDetailsForBottomSheet(dstHub),
        onValueClick: null,
      ),


    ];

    List<GridViewHelper> helperList = [

      GridViewHelper(
        label: 'Dispatch Time',
        value: selectedTrip.dispatchDateTime.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Item',
        value:
            '${selectedTrip.itemWeight.toString()} ${selectedTrip.itemUnit.toString()}',
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Collect (${selectedTrip.itemUnit})',
        value: selectedTrip.itemCollect.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Drop (${selectedTrip.itemUnit})',
        value: selectedTrip.itemDrop.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Payment',
        value: selectedTrip.payment.toString(),
        onValueClick: null,
      ),
      GridViewHelper(
        label: 'Vehicle Number',
        value: selectedTrip.vehicleId.toString(),
        onValueClick: null,
      ),


    ];

    bottomSheetService.showCustomSheet(
      customData: GridViewBottomSheetInputArgument(
        title: 'C#${selectedTrip.consignmentId}',
        gridList: helperList,
        footerList: footerList,
        headerList: headerList,
      ),
      barrierDismissible: true,
      isScrollControlled: true,
      variant: BottomSheetType.UPCOMING_TRIPS,
    );
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

  Set<DateTime> sortDateTimeSet(
      {@required Set<DateTime> set, bool ascending = true}) {
    Set<DateTime> sortedSet = Set();
    sortedSet = SplayTreeSet.from(
      set,
      (a, b) => ascending ? a.compareTo(b) : b.compareTo(a),
    );

    return sortedSet;
  }

  Set<ConsignmentTrackingStatusResponse>
      sortConsignmentTrackingStatusResponseSet(
          {@required Set<ConsignmentTrackingStatusResponse> set}) {
    Set<ConsignmentTrackingStatusResponse> sortedSet = Set();
    sortedSet = SplayTreeSet.from(set, (a, b) => a.compareTo(b));

    return sortedSet;
  }

  GetHubDetailsResponse get dstHub => _dstHub;

  set dstHub(GetHubDetailsResponse value) {
    _dstHub = value;
    notifyListeners();
  }
}
