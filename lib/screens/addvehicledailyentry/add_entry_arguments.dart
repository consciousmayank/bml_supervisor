import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/models/routes_for_selected_client_and_date_response.dart';
import 'package:flutter/cupertino.dart';

class AddEntryArguments {
  final DateTime entryDate;
  final EntryLog vehicleLog;
  final int flagForSearch;
  final int selectedClientId;
  final RoutesForSelectedClientAndDateResponse selectedRoute;
  final String registrationNumber;

  AddEntryArguments({
    @required this.entryDate,
    @required this.vehicleLog,
    @required this.flagForSearch,
    @required this.selectedClientId,
    @required this.selectedRoute,
    @required this.registrationNumber,
  });
}
