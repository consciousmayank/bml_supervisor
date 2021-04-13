import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/create_consignment_request.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/search_by_reg_no_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';

class ConfirmConsignmentView extends StatelessWidget {
  final CreateConsignmentRequest consignmentRequest;
  final SearchByRegNoResponse validatedRegistrationNumber;
  final GetClientsResponse selectedClient;
  final FetchRoutesResponse selectedRoute;
  final String itemUnit;
  final Function onSubmitClicked;
  final bool isShowSubmitButton;

  const ConfirmConsignmentView({
    Key key,
    @required this.consignmentRequest,
    @required this.validatedRegistrationNumber,
    @required this.selectedClient,
    @required this.selectedRoute,
    @required this.onSubmitClicked,
    @required this.itemUnit,
    this.isShowSubmitButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "SUMMARY",
                style: AppTextStyles.latoBold16White
                    .copyWith(color: AppColors.primaryColorShade5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Client'),
                      Text(selectedClient.clientId),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Date'),
                      Text(consignmentRequest.entryDate),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Route'),
                      Text(consignmentRequest.routeTitle),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Vehicle'),
                      Text(consignmentRequest.vehicleId),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Items ($itemUnit)'),
                ),
              ],
            ),
            // RichText(
            //   textAlign: TextAlign.center,
            //   text: TextSpan(
            //     style: AppTextStyles.latoMedium14Black,
            //     children: <TextSpan>[
            //       TextSpan(text: "Consignment for "),
            //       TextSpan(
            //         text: '${selectedClient.clientId} ',
            //         style: AppTextStyles.latoBold12Black.copyWith(
            //           color: AppColors.black,
            //         ),
            //       ),
            //       TextSpan(text: 'for'),
            //       TextSpan(
            //           text: ' ${selectedRoute.routeTitle} ',
            //           style: AppTextStyles.latoBold12Black.copyWith(
            //             color: AppColors.black,
            //           )),
            //       TextSpan(text: ' route dated,  '),
            //       TextSpan(
            //         text: '${consignmentRequest.entryDate}.',
            //         style: AppTextStyles.latoBold12Black.copyWith(
            //           color: AppColors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // hSizedBox(20),
            // RichText(
            //   textAlign: TextAlign.center,
            //   text: TextSpan(
            //     style: AppTextStyles.latoMedium14Black,
            //     children: <TextSpan>[
            //       TextSpan(text: "The Vehicle selected is "),
            //       TextSpan(
            //         text: '${validatedRegistrationNumber.registrationNumber} ',
            //         style: AppTextStyles.latoBold12Black.copyWith(
            //           color: AppColors.black,
            //         ),
            //       ),
            //       TextSpan(text: ', driven by '),
            //       TextSpan(
            //         text: ' ${validatedRegistrationNumber.ownerName} ',
            //         style: AppTextStyles.latoBold12Black.copyWith(
            //           color: AppColors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            hSizedBox(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Consignment Items Details",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.latoBold16White
                      .copyWith(color: AppColors.primaryColorShade5),
                ),
              ],
            ),
            hSizedBox(10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      color: AppColors.routesCardColor,
                      elevation: 4,
                      shape: getCardShape(),
                      child: Stack(
                        children: [
                          // Image.asset(semiCircles),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                rowMaker(
                                    label: "Title",
                                    value:
                                        consignmentRequest.items[index].title),
                                hSizedBox(10),
                                rowMaker(
                                    label: "Hub",
                                    value: consignmentRequest.items[index].hubId
                                        .toString()),
                                hSizedBox(10),
                                rowMaker(
                                    label: "Item Collect",
                                    value: consignmentRequest
                                        .items[index].collect
                                        .toString()),
                                hSizedBox(10),
                                rowMaker(
                                    label: "Item Drop",
                                    value: consignmentRequest
                                        .items[index].dropOff
                                        .toString()),
                                hSizedBox(10),
                                rowMaker(
                                    label: "Payment",
                                    value: consignmentRequest
                                        .items[index].payment
                                        .toString()),
                                hSizedBox(10),
                                rowMaker(
                                    label: "Remark",
                                    value: consignmentRequest
                                        .items[index].remarks),
                                hSizedBox(10),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: consignmentRequest.items.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: rowMaker(
                label: null,
                value: SizedBox(
                  height: buttonHeight,
                  child: AppButton(
                    onTap: () {
                      onSubmitClicked(true);
                    },
                    background: AppColors.primaryColorShade5,
                    buttonText: "Submit",
                    borderColor: AppColors.primaryColorShade1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowMaker({@required String label, @required Object value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: label == null ? Container() : Text(label),
          flex: 1,
        ),
        Expanded(
          child: value is String
              ? Text(
                  value,
                  textAlign: TextAlign.end,
                )
              : value,
          flex: 1,
        ),
      ],
    );
  }
}
