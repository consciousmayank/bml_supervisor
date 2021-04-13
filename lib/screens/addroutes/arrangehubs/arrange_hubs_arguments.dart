import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:flutter/foundation.dart';

class ArrangeHubsArguments {
  final List<GetDistributorsResponse> newHubsList;
  final String routeTitle, remarks;
  final int srcLocation, dstLocation;

  ArrangeHubsArguments({
    this.newHubsList,
    this.remarks,
    @required this.routeTitle,
    @required this.dstLocation,
    @required this.srcLocation,
  });
}
