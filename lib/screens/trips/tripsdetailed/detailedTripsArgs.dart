import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:flutter/cupertino.dart';

class DetailedTripsViewArgs {
  List<ConsignmentTrackingStatusResponse> tripsList;
  final TripStatus tripStatus;

  DetailedTripsViewArgs({
    @required this.tripsList,
    @required this.tripStatus,
  });
}

class ReturnDetailedTripsViewArgs {
  bool success;
  final TripStatus tripStatus;

  ReturnDetailedTripsViewArgs({
    @required this.success,
    @required this.tripStatus,
  });
}
