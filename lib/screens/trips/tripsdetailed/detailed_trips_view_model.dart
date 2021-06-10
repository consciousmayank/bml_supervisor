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
  int _tabselected = 0;

  int get tabselected => _tabselected;

  set tabselected(int tabselected) {
    _tabselected = tabselected;
    notifyListeners();
    print('Current Selected Tab :: $tabselected');
  }

  Set<DateTime> completeTripsDate = Set();
  List<ConsignmentTrackingStatusResponse> completedTrips = [];
  int completedTripsPageNumber = 1,
      verifiedTripsPageNumber = 1,
      otherTripsPageNumber = 1;

  bool isGetHubDetailsByRouteIdApiBeingCalled = false;
  List<ConsignmentTrackingStatusResponse> verifiedTrips = [];
  Set<DateTime> verifiedTripsDate = Set();

  DashBoardApis _dashboardApi = locator<DashBoardApisImpl>();
  GetHubDetailsResponse _dstHub;
  GetHubDetailsResponse _hubResponse;
  RoutesApis _routesApis = locator<RoutesApisImpl>();
  ConsignmentTrackingStatusResponse _selectedTripForEndingTrip;
  GetHubDetailsResponse _srcHub;
  List<ConsignmentTrackingStatusResponse> _trips = [];

  GetHubDetailsResponse get srcHub => _srcHub;

  set srcHub(GetHubDetailsResponse value) {
    _srcHub = value;
    notifyListeners();
  }

  GetHubDetailsResponse get hubResponse => _hubResponse;

  set hubResponse(GetHubDetailsResponse value) {
    _hubResponse = value;
    notifyListeners();
  }

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
    isGetHubDetailsByRouteIdApiBeingCalled = true;
    setBusy(true);
    srcHub = await getHubDetailsByRouteId(hubId: srcLocation);
    dstHub = await getHubDetailsByRouteId(hubId: dstLocation);
    setBusy(false);
    isGetHubDetailsByRouteIdApiBeingCalled = false;
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

  void getCompletedTrips({int page = 1}) async {
    if (page <= 1) setBusy(true);

    List<ConsignmentTrackingStatusResponse> response;
    response = await _dashboardApi.getConsignmentTrackingStatus(
        tripStatus: TripStatus.COMPLETED,
        clientId: MyPreferences()?.getSelectedClient()?.clientId,
        pageNumber: page);
    if (page <= 1) {
      completedTrips = copyList(response);
    } else {
      completedTrips.addAll(copyList(response));
    }
    completedTripsPageNumber++;
    completedTrips.forEach((element) {
      completeTripsDate.add(
        StringToDateTimeConverter.ddmmyy(date: element.consignmentDate)
            .convert(),
      );
    });
    notifyListeners();
    setBusy(false);
  }

  void getVerifiedTrips({int page = 1}) async {
    if (page <= 1) setBusy(true);
    List<ConsignmentTrackingStatusResponse> response;
    response = await _dashboardApi.getConsignmentTrackingStatus(
      tripStatus: TripStatus.APPROVED,
      clientId: MyPreferences()?.getSelectedClient()?.clientId,
      pageNumber: page,
    );

    if (page <= 1) {
      verifiedTrips = copyList(response);
    } else {
      verifiedTrips.addAll(copyList(response));
    }
    verifiedTripsPageNumber++;
    verifiedTrips.forEach((element) {
      verifiedTripsDate.add(
          StringToDateTimeConverter.ddmmyy(date: element.consignmentDate)
              .convert());
    });
    notifyListeners();
    setBusy(false);
  }

  bool shouldCallGetConsignmentTrackingStatus = true;

  void getConsignmentTrackingStatus(
      {TripStatus tripStatus, int page = 1}) async {
    if (shouldCallGetConsignmentTrackingStatus) {
      if (page <= 1) setBusy(true);
      List<ConsignmentTrackingStatusResponse> response =
          await _dashboardApi.getConsignmentTrackingStatus(
              tripStatus: tripStatus,
              clientId: MyPreferences()?.getSelectedClient()?.clientId,
              pageNumber: page);
      if (response.length == 0) {
        shouldCallGetConsignmentTrackingStatus = false;
      }
      if (page <= 1) {
        trips = copyList(response);
      } else {
        trips.addAll(copyList(response));
      }
      otherTripsPageNumber++;
      setBusy(false);
      notifyListeners();
    }
  }

  String getHubDetailsForBottomSheet(GetHubDetailsResponse hub) {
    String hubDetails = hub.title;
    hubDetails = hubDetails + ', ' + hub.locality;
    if (hub.locality != hub.city) hubDetails = hubDetails + ', ' + hub.city;
    return hubDetails;
  }

  void openDetailTripsBottomSheet(
      {ConsignmentTrackingStatusResponse selectedTrip}) {
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
        label: 'Date',
        value: selectedTrip.consignmentDate.toString(),
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
      GridViewHelper(
        label: '',
        value: '',
        onValueClick: null,
      ),
    ];

    bottomSheetService.showCustomSheet(
      customData: GridViewBottomSheetInputArgument(
          title: 'C#${selectedTrip.consignmentId}',
          gridList: helperList,
          headerList: headerList,
          footerList: []),
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
      getCompletedTrips();
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

  // Set<DateTime> sortDateTimeSet(
  //     {@required Set<DateTime> set, bool ascending = true}) {
  //   Set<DateTime> sortedSet = Set();
  //   sortedSet = SplayTreeSet.from(
  //     set,
  //     (a, b) => ascending ? a.compareTo(b) : b.compareTo(a),
  //   );

  //   return sortedSet;
  // }

  // Set<ConsignmentTrackingStatusResponse>
  //     sortConsignmentTrackingStatusResponseSet(
  //         {@required Set<ConsignmentTrackingStatusResponse> set}) {
  //   Set<ConsignmentTrackingStatusResponse> sortedSet = Set();
  //   sortedSet = SplayTreeSet.from(set, (a, b) => a.compareTo(b));

  //   return sortedSet;
  // }

  GetHubDetailsResponse get dstHub => _dstHub;

  set dstHub(GetHubDetailsResponse value) {
    _dstHub = value;
    notifyListeners();
  }
}
