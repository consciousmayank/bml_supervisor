import 'package:flutter/cupertino.dart';
import 'package:bml/enums/trip_statuses.dart';

class DetailedTripsViewArgs {
  final TripStatus tripStatus;

  DetailedTripsViewArgs({
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
