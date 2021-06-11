import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:flutter/material.dart';

class TempHubsListInputArguments {
  final int reviewedConsigId;

  TempHubsListInputArguments({
    @required this.reviewedConsigId,
  });
}

class TempHubsListOutputArguments {
  final SingleTempHub enteredHub;

  TempHubsListOutputArguments({
    @required this.enteredHub,
  });
}
