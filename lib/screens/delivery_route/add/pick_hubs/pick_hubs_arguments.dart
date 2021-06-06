import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:flutter/cupertino.dart';

class PickHubsArguments {
  final List<GetDistributorsResponse> hubsList;
  final String routeTitle;
  final String remarks;

  PickHubsArguments({
    @required this.hubsList,
    @required this.routeTitle,
    this.remarks,
  });
}
