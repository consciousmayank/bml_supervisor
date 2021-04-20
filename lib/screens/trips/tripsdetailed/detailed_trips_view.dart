import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/screens/trips/tripsdetailed/detailed_trips_view_model.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/single_trip_item.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'detailedTripsArgs.dart';

class DetailedTripsView extends StatefulWidget {
  final DetailedTripsViewArgs args;

  const DetailedTripsView({Key key, @required this.args}) : super(key: key);

  @override
  _DetailedTripsViewState createState() => _DetailedTripsViewState();
}

class _DetailedTripsViewState extends State<DetailedTripsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailedTripsViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.trips = widget.args.tripsList;
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            getTitle(widget.args.tripStatus),
            style: AppTextStyles.appBarTitleStyle,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    SingleTripItem(
                  status: widget.args.tripStatus,
                  onCheckBoxTapped: (
                    bool value,
                    ConsignmentTrackingStatusResponse tappedTrip,
                  ) {},
                  singleListItem: viewModel.trips[index],
                  onTap: () {
                    switch (widget.args.tripStatus) {
                      case TripStatus.UPCOMING:
                      case TripStatus.ONGOING:
                        viewModel.openBottomSheet(trip: viewModel.trips[index]);
                        break;
                      case TripStatus.COMPLETED:
                        viewModel.reviewTrip(trip: viewModel.trips[index]);
                        break;
                    }
                  },
                ),
                itemCount: viewModel.trips.length,
              ),
            ),
            viewModel.selectedTripForEndingTrip != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      right: 4,
                      left: 4,
                    ),
                    child: SizedBox(
                      height: buttonHeight,
                      child: AppButton(
                        borderColor: AppColors.primaryColorShade11,
                        onTap: () {},
                        background: AppColors.primaryColorShade5,
                        buttonText: 'End Trip',
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
      viewModelBuilder: () => DetailedTripsViewModel(),
    );
  }

  String getTitle(TripStatus tripStatus) {
    switch (tripStatus) {
      case TripStatus.UPCOMING:
        return 'Upcoming Trips';
        break;
      case TripStatus.ONGOING:
        return 'Ongoing Trips';
        break;
      case TripStatus.COMPLETED:
        return 'Completed Trips';
        break;
      default:
        return 'Trips';
    }
  }
}
