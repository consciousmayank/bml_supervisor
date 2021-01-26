import 'package:flutter/cupertino.dart';

class ConsignmentListArguments {
  final bool isFulPageView;
  final String duration;
  final int clientId;

  ConsignmentListArguments({
    @required this.isFulPageView,
    @required this.duration,
    @required this.clientId,
  });
}
