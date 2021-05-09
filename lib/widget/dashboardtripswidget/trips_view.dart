import 'package:bml/bml.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/widget/dashboardtripswidget/trips_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TripsView extends StatefulWidget {
  final TripStatus tripStatus;
  final List<ConsignmentTrackingStatusResponse> tripsList;
  final Function onReload;

  const TripsView(
      {Key key,
      this.tripStatus = TripStatus.UPCOMING,
      this.tripsList,
      @required this.onReload})
      : super(key: key);

  @override
  _TripsViewState createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TripsViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.tripsList = Utils().Utils().copyList(widget.tripsList);
      },
      builder: (context, viewModel, child) => NotificationTile(
        iconName: getIcon(),
        notificationTitle: getTitle(),
        taskNumber: '${widget.tripsList.length}',
        onTap: viewModel.tripsList != null && viewModel.tripsList.length > 0
            ? () {
                viewModel.takeToUpcomingTripsDetailsView(
                  tripStatus: widget.tripStatus,
                  onLoadComplete: () {
                    widget.onReload.call();
                  },
                );
              }
            : null,
      ),
      viewModelBuilder: () => TripsViewModel(),
    );
  }

  getTitle() {
    switch (widget.tripStatus) {
      case TripStatus.UPCOMING:
        return 'Upcoming Trips';
        break;
      case TripStatus.ONGOING:
        return 'OnGoing Trips';
        break;
      case TripStatus.COMPLETED:
        return 'Completed Trips';
        break;

      default:
        return 'Trips';
    }
  }

  getIcon() {
    switch (widget.tripStatus) {
      case TripStatus.UPCOMING:
        return ImageConfigs().consignmentIcon;
        break;
      case TripStatus.ONGOING:
        return ImageConfigs().blueRouteIcon;
        break;
      case TripStatus.COMPLETED:
        return ImageConfigs().completedTripsIcon;
        break;

      default:
        return ImageConfigs().blueRouteIcon;
    }
  }
}
