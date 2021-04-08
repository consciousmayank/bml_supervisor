import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:flutter/cupertino.dart';

class ConsignmentDialogParams {
  final CreateConsignmentRequest consignmentRequest;
  final SearchByRegNoResponse validatedRegistrationNumber;
  final GetClientsResponse selectedClient;
  final FetchRoutesResponse selectedRoute;
  final String  itemUnit;

  ConsignmentDialogParams({
    @required this.consignmentRequest,
    @required this.validatedRegistrationNumber,
    @required this.selectedClient,
    @required this.selectedRoute,
    @required this.itemUnit,
  });
}
