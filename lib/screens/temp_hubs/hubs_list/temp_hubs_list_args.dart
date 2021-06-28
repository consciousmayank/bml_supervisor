import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:flutter/material.dart';

class TempHubsListInputArguments {
  final int reviewedConsigId;
  final CallingScreen callingScreen;
  TempHubsListInputArguments(
      {@required this.reviewedConsigId, this.callingScreen});
}

class TempHubsListOutputArguments {
  final SingleTempHub enteredHub;

  TempHubsListOutputArguments({
    @required this.enteredHub,
  });
}

class TempHubsListToCreateConsignmentArguments {
  final List<SingleTempHub> hubList;

  TempHubsListToCreateConsignmentArguments({
    @required this.hubList,
  });
}
