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
                    : makeList(
                        trips: widget.viewModel.completedTrips,
                        typeOfTrip: TripStatus.COMPLETED),
                widget.viewModel.verifiedTrips.length == 0
                    ? Container(
                        child: Center(
                          child: Text('No Trips as of yet.'),
                        ),
                      )
                    : makeList(
                        trips: widget.viewModel.verifiedTrips,
                        typeOfTrip: TripStatus.APPROVED),
              ],
            ),
          )
        ],
      ),
    );
  }

  makeList(
      {List<ConsignmentTrackingStatusResponse> trips, TripStatus typeOfTrip}) {
    Set<String> dateList = typeOfTrip == TripStatus.COMPLETED
        ? widget.viewModel.completeTripsDate
        : widget.viewModel.verifiedTripsDate;

    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          child:

              // Container(
              // child: Container(
              //   height: 100,
              //   color: Colors.red,
              // ),

              Card(
            elevation: defaultElevation,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeConfiguration.primaryBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  height: 50.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: AppTextStyles.latoBold16White,
                      ),
                      Text(
                        dateList.elementAt(index),
                        style: AppTextStyles.latoBold16White,
                      ),
                    ],
                  ),
                ),
                makeSingleTripView(
                    date: dateList.elementAt(index),
                    trips: trips,
                    outerIndex: index),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
        ),
        itemCount: dateList.length,
      ),
    );
  }

  Widget makeSingleTripView(
      {@required String date,
      @required List<ConsignmentTrackingStatusResponse> trips,
      @required int outerIndex}) {
    List<ConsignmentTrackingStatusResponse> tripWithSelectedDate = [];

    trips.forEach((element) {
      if (element.consignmentDate == date) {
        tripWithSelectedDate.add(element);
      }
    });

    // List<ConsignmentTrackingStatusResponse> tripWithSelectedDate =
    //     trips.where((element) => element.consignmentDate == date);

    return Column(
      children: List.generate(
        tripWithSelectedDate.length,
        (index) => Column(
          children: [
            index == 0
                ? Container()
                : Container(
                    color: AppColors.appScaffoldColor,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: DottedDivider(
                      strokeWidth: 3,
                      dottedLength: 3,
                      space: 3,
                    ),
                  ),
            SingleTripItem(
              status: widget.tripStatus,
              onCheckBoxTapped: (
                bool value,
                ConsignmentTrackingStatusResponse tappedTrip,
              ) {},
              singleListItem: trips[index],
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
          ],
        ),
      ).toList(),
    );
  }
}
