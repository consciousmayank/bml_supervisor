import 'package:bml_supervisor/enums/dialog_type.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/screens/dialogs/confirm_route_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bml/bml.dart';

import 'locator.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();
  final builders = {
    DialogType.BASIC: (context, sheetRequest, completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.CREATE_ROUTE: (context, sheetRequest, completer) =>
        _CreateRouteDialog(
          request: sheetRequest,
          completer: completer,
          routeRequest: sheetRequest.customData.routeRequest,
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

class _CreateRouteDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final CreateRouteRequest routeRequest;

  const _CreateRouteDialog({
    this.request,
    this.completer,
    @required this.routeRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.primaryColorShade5,
      child: ConfirmRouteView(
        routeRequest: routeRequest,
        onSubmitClicked: (bool value) {
          completer(
            DialogResponse(confirmed: value),
          );
        },
      ),
    );
  }
}
