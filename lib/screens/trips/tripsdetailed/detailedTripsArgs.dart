import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statistics_response.dart';
import 'package:flutter/cupertino.dart';

class DetailedTripsViewArgs {
  final TripStatus tripStatus;
  final ConsignmentTrackingStatisticsResponse consignmentTrackingStatistics;

  DetailedTripsViewArgs({
    @required this.tripStatus,
    @required this.consignmentTrackingStatistics,
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
