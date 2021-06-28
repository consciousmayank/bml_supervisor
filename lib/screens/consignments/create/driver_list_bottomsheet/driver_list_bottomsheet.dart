import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/screens/consignments/create/driver_list_bottomsheet/driver_list_bottomsheet_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class DriverListBottomSheetBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const DriverListBottomSheetBottomSheet({
    Key key,
    @required this.request,
    @required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DriverListBottomSheetBottomSheetInputArgument args = request.customData;
    return BaseBottomSheet(
      bottomSheetTitle: args.bottomSheetTitle,
      request: request,
      completer: completer,
      child: DriverListBottomSheetView(
        arguments: null,
        onDriverSelected: (DriverInfo selectedDriver) {
          completer(
            SheetResponse(
              confirmed: true,
              responseData: DriverListBottomSheetBottomSheetOutputArguments(
                  selectedDriver: selectedDriver),
            ),
          );
        },
      ),
    );
  }
}

class DriverListBottomSheetBottomSheetInputArgument {
  final String bottomSheetTitle;

  DriverListBottomSheetBottomSheetInputArgument({
    @required this.bottomSheetTitle,
  });
}

class DriverListBottomSheetBottomSheetOutputArguments {
  final DriverInfo selectedDriver;

  DriverListBottomSheetBottomSheetOutputArguments(
      {@required this.selectedDriver});
}
