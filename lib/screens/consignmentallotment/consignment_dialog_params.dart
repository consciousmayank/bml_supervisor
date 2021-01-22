import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:flutter/cupertino.dart';

class ConsignmentDialogParams {
  final CreateConsignmentRequest consignmentRequest;
  final SearchByRegNoResponse validatedRegistrationNumber;
  final GetClientsResponse selectedClient;
  final GetRoutesResponse selectedRoute;

  ConsignmentDialogParams({
    @required this.consignmentRequest,
    @required this.validatedRegistrationNumber,
    @required this.selectedClient,
    @required this.selectedRoute,
  });
}
