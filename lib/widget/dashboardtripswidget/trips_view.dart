import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dashboardtripswidget/trips_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../app_notification_row.dart';

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
        viewModel.tripsList = copyList(widget.tripsList);
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
        return consignmentIcon;
        break;
      case TripStatus.ONGOING:
        return blueRouteIcon;
        break;
      case TripStatus.COMPLETED:
        return completedTripsIcon;
        break;

      default:
        return blueRouteIcon;
    }
  }
}
