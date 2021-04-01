

import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:flutter/material.dart';

class ConsignmentDetailsArgument {
  final String consignmentId, routeId, routeName, entryDate, vehicleId;
  final CallingScreen callingScreen;

  ConsignmentDetailsArgument({
    @required this.entryDate,
    @required this.vehicleId,
    @required this.consignmentId,
    @required this.routeId,
    @required this.routeName,
    this.callingScreen = CallingScreen.CONSIGNMENT_LIST,
  });
}
