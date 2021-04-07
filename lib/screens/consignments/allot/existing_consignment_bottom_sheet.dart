import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/widget/existing_consignments_item_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class ExistingConsignmentBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const ExistingConsignmentBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ConsignmentsForSelectedDateAndClientResponse> customData =
        request.customData as List;

    return Container(
      // margin: EdgeInsets.all(defaultBorder),
      // padding: EdgeInsets.all(defaultBorder),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ExistingConsignmentItem(
            args: ExistingConsignmentItemArguments(
              consignmentId: customData[index].consigmentId,
              routeTitle: '${customData[index].routeTitle}',
              vehicleId: '${customData[index].vehicleId}',
              routeId: customData[index].routeId,
            ),
          );
        },
        itemCount: customData.length,
      ),
    );
  }
}
