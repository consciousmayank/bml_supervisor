import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/clientselect/client_select_view.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectClientBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const SelectClientBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
        bottomSheetTitle: 'Select client',
        request: request,
        completer: completer,
        child: Expanded(
          child: ClientSelectView(
            preSelectedClient: request.customData,
            isCalledFromBottomSheet: true,
            onClientSelected: (GetClientsResponse selectedClient) {
              completer(
                SheetResponse(confirmed: true, responseData: selectedClient),
              );
            },
          ),
        ));
  }
}
