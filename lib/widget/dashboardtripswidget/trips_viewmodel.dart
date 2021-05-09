import 'package:bml/bml.dart';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/trips/tripsdetailed/detailedTripsArgs.dart';

class TripsViewModel extends GeneralisedBaseViewModel {
  List<ConsignmentTrackingStatusResponse> _tripsList = [];

  List<ConsignmentTrackingStatusResponse> get tripsList => _tripsList;

  set tripsList(List<ConsignmentTrackingStatusResponse> value) {
    _tripsList = value;
  }

  void takeToUpcomingTripsDetailsView(
      {TripStatus tripStatus, Function onLoadComplete}) {
    navigationService
        .navigateTo(
          tripsDetailsPageRoute,
          arguments: DetailedTripsViewArgs(tripStatus: tripStatus),
        )
        .then((value) => onLoadComplete());
  }
}
