import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/enums/dialog_type.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/screens/dialogs/confirm_consignment_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();
  final builders = {
    DialogType.BASIC: (context, sheetRequest, completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.CREATE_CONSIGNMENT: (context, sheetRequest, completer) =>
        _CreateConsignmentDialog(
          request: sheetRequest,
          completer: completer,
          selectedRoute: sheetRequest.customData.selectedRoute,
          selectedClient: sheetRequest.customData.selectedClient,
          validatedRegistrationNumber:
              sheetRequest.customData.validatedRegistrationNumber,
          consignmentRequest: sheetRequest.customData.consignmentRequest,
        ),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class _BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _BasicDialog({Key key, this.request, this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container() /* Build your dialog UI here */
        );
  }
}

class _CreateConsignmentDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final CreateConsignmentRequest consignmentRequest;
  final SearchByRegNoResponse validatedRegistrationNumber;
  final GetClientsResponse selectedClient;
  final GetRoutesResponse selectedRoute;

  const _CreateConsignmentDialog({
    Key key,
    this.request,
    this.completer,
    @required this.consignmentRequest,
    @required this.validatedRegistrationNumber,
    @required this.selectedClient,
    @required this.selectedRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.primaryColorShade5,
      child: ConfirmConsignmentView(
        selectedClient: selectedClient,
        consignmentRequest: consignmentRequest,
        selectedRoute: selectedRoute,
        validatedRegistrationNumber: validatedRegistrationNumber,
        onSubmitClicked: (bool value) {
          completer(
            DialogResponse(confirmed: value),
          );
        },
      ),
    );
  }
}
