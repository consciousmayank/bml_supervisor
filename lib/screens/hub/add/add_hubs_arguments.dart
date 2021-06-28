import 'package:bml_supervisor/enums/calling_screen.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:flutter/material.dart';

class AddHubsIncomingArguments {
  final List<HubResponse> hubsList;
  final CallingScreen callingScreen;

  AddHubsIncomingArguments({
    @required this.hubsList,
    @required this.callingScreen,
  }) : assert(
          callingScreen != null,
          "The screen from where addHubs is called, cannot be null.",
        );
}

class AddHubsReturnArguments {
  final SingleTempHub singleTempHub;

  AddHubsReturnArguments({@required this.singleTempHub});
}
