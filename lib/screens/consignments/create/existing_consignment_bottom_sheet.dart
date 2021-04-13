import 'package:bml_supervisor/models/consignments_for_selected_date_and_client_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/widget/single_consignment_item_view.dart';
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
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
        ),
      ),
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
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SingleConsignmentItem(
                    args: SingleConsignmentItemArguments(
                        vehicleId: customData[index].vehicleId.toString(),
                        drop: customData[index].dropOff.toString(),
                        routeTitle: customData[index].routeTitle.toString(),
                        collect: customData[index].collect.toString(),
                        payment: customData[index].payment.toString(),
                        routeId: customData[index].routeId.toString(),
                        consignmentId:
                            customData[index].consigmentId.toString(),
                        onTap: () {
                          completer(SheetResponse(
                              confirmed: true,
                              responseData: customData[index]));
                        }));
              },
              itemCount: customData.length,
            ),
          ),
        ],
      ),
    );
  }
}
