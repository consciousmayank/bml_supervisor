import 'package:bml/model/single_trip_model.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/screens/trips/tripsdetailed/detailed_trips_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml/bml.dart';

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
        widget.args.tripStatus == TripStatus.COMPLETED
            ? viewModel.getCompletedAndVerifiedTrips()
            : viewModel.getConsignmentTrackingStatus(
                tripStatus: widget.args.tripStatus);
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            getTitle(widget.args.tripStatus),
            style: AppTextStyles.appBarTitleStyle,
          ),
          centerTitle: true,
        ),
        body: viewModel.isBusy
            ? ShimmerContainer(
                itemCount: 20,
              )
            : widget.args.tripStatus == TripStatus.COMPLETED
                ? TabbedBody(
                    viewModel: viewModel,
                    tripStatus: widget.args.tripStatus,
                  )
                : NormalBody(
                    viewModel: viewModel,
                    tripStatus: widget.args.tripStatus,
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
        return 'Trips';
        break;
      default:
        return 'Trips';
    }
  }
}

class NormalBody extends StatefulWidget {
  final DetailedTripsViewModel viewModel;
  final TripStatus tripStatus;

  const NormalBody({
    Key key,
    @required this.viewModel,
    @required this.tripStatus,
  }) : super(key: key);
  @override
  _NormalBodyState createState() => _NormalBodyState();
}

class _NormalBodyState extends State<NormalBody> {
  @override
  Widget build(BuildContext context) {
    return widget.viewModel.trips.length == 0
        ? Container(
            child: Center(
              child: Text('No Trips as of yet.'),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      SingleTripItem(
                    status: widget.tripStatus,
                    onCheckBoxTapped: (
                      bool value,
                      ConsignmentTrackingStatusResponse tappedTrip,
                    ) {},
                    singleListItem: SingleTripModel(
                      dstLocation: widget.viewModel.trips[index].dstLocation,
                      consignmentDate:
                          widget.viewModel.trips[index].consignmentDate,
                      itemUnit: widget.viewModel.trips[index].itemUnit,
                      consignmentId:
                          widget.viewModel.trips[index].consignmentId,
                      routeTitle: widget.viewModel.trips[index].routeTitle,
                      srcLocation: widget.viewModel.trips[index].srcLocation,
                      itemDrop: widget.viewModel.trips[index].itemDrop,
                      dispatchDateTime:
                          widget.viewModel.trips[index].dispatchDateTime,
                      routeId: widget.viewModel.trips[index].routeId,
                      itemCollect: widget.viewModel.trips[index].itemCollect,
                      consignmentTitle:
                          widget.viewModel.trips[index].consignmentTitle,
                      payment: widget.viewModel.trips[index].payment,
                      vehicleId: widget.viewModel.trips[index].vehicleId,
                      itemWeight: widget.viewModel.trips[index].itemWeight,
                      statusCode: widget.viewModel.trips[index].statusCode,
                    ),
                    onTap: () {
                      if (widget.viewModel.trips[index].statusCode == 1 ||
                          widget.viewModel.trips[index].statusCode == 2 ||
                          widget.viewModel.trips[index].statusCode == 4) {
                        widget.viewModel.openBottomSheet(
                            trip: widget.viewModel.trips[index]);
                      } else if (widget.viewModel.trips[index].statusCode ==
                          3) {
                        widget.viewModel
                            .reviewTrip(trip: widget.viewModel.trips[index]);
                      }
                    },
                  ),
                  itemCount: widget.viewModel.trips.length,
                ),
              ),
            ],
          );
  }
}

class TabbedBody extends StatefulWidget {
  final DetailedTripsViewModel viewModel;
  final TripStatus tripStatus;

  const TabbedBody(
      {Key key, @required this.viewModel, @required this.tripStatus})
      : super(key: key);
  @override
  _TabbedBodyState createState() => _TabbedBodyState();
}

class _TabbedBodyState extends State<TabbedBody> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelStyle: AppTextStyles.latoBold14Black,
            unselectedLabelStyle: AppTextStyles.latoMedium14Black,
            labelColor: AppColors.primaryColorShade5,
            unselectedLabelColor: AppColors.black,
            indicatorColor: AppColors.primaryColorShade5,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: 'Completed (${widget.viewModel.completedTrips.length})',
              ),
              Tab(
                text: 'Verified (${widget.viewModel.verifiedTrips.length})',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                widget.viewModel.completedTrips.length == 0
                    ? Container(
                        child: Center(
                          child: Text('No Trips as of yet.'),
                        ),
                      )
                    : makeList(widget.viewModel.completedTrips),
                widget.viewModel.verifiedTrips.length == 0
                    ? Container(
                        child: Center(
                          child: Text('No Trips as of yet.'),
                        ),
                      )
                    : makeList(widget.viewModel.verifiedTrips)
              ],
            ),
          )
        ],
      ),
    );
  }

  makeList(List<ConsignmentTrackingStatusResponse> trips) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => SingleTripItem(
          status: widget.tripStatus,
          onCheckBoxTapped: (
            bool value,
            ConsignmentTrackingStatusResponse tappedTrip,
          ) {},
          singleListItem: SingleTripModel(
            dstLocation: trips[index].dstLocation,
            consignmentDate: trips[index].consignmentDate,
            itemUnit: trips[index].itemUnit,
            consignmentId: trips[index].consignmentId,
            routeTitle: trips[index].routeTitle,
            srcLocation: trips[index].srcLocation,
            itemDrop: trips[index].itemDrop,
            dispatchDateTime: trips[index].dispatchDateTime,
            routeId: trips[index].routeId,
            itemCollect: trips[index].itemCollect,
            consignmentTitle: trips[index].consignmentTitle,
            payment: trips[index].payment,
            vehicleId: trips[index].vehicleId,
            itemWeight: trips[index].itemWeight,
            statusCode: trips[index].statusCode,
          ),
          onTap: () {
            if (trips[index].statusCode == 1 ||
                trips[index].statusCode == 2 ||
                trips[index].statusCode == 4) {
              widget.viewModel.openBottomSheet(trip: trips[index]);
            } else if (trips[index].statusCode == 3) {
              widget.viewModel.reviewTrip(trip: trips[index]);
            }
          },
        ),
        itemCount: trips.length,
      ),
    );
  }
}
