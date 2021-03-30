import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:flutter/cupertino.dart';

class PickHubsArguments{
  final  List<GetDistributorsResponse> hubsList;
  PickHubsArguments({@required this.hubsList});
}