import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/screens/consignments/allot/consignment_dialog_params.dart';
import 'package:bml_supervisor/screens/consignments/allot/existing_consignment_bottom_sheet.dart';
import 'package:bml_supervisor/screens/dialogs/confirm_consignment_view.dart';
import 'package:bml_supervisor/screens/viewvehicleentry/view_entry_bottom_sheet.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'colors.dart';
import 'locator.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.floating: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.viewEntry: (context, sheetRequest, completer) =>
        ViewEntryBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.consignmentList: (context, sheetRequest, completer) =>
        ExistingConsignmentBottomSheet(
            request: sheetRequest, completer: completer),
    BottomSheetType.createConsignmentSummary: (context, sheetRequest,
            completer) =>
        _CreateConsignmentDialog(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const _FloatingBoxBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Calling method should pass custom data, and should be received here
    var customData = request.customData as Map;

    return Container(
      // margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            request.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 10),
          Text(
            customData['data1'],
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            request.description,
            style: TextStyle(color: Colors.grey),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                child: Text(
                  request.secondaryButtonTitle,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              FlatButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                child: Text(
                  request.mainButtonTitle,
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              )
            ],
          )
        ],
      ),
    );
  }
}

class _CreateConsignmentDialog extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  ConsignmentDialogParams args;

  _CreateConsignmentDialog({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    args = request.customData;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appScaffoldColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.84,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              completer(
                SheetResponse(confirmed: false, responseData: null),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Close',
                    style: AppTextStyles.hyperLinkStyle,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ConfirmConsignmentView(
              selectedClient: args.selectedClient,
              consignmentRequest: args.consignmentRequest,
              selectedRoute: args.selectedRoute,
              validatedRegistrationNumber: args.validatedRegistrationNumber,
              onSubmitClicked: (bool value) {
                completer(SheetResponse(confirmed: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}
