import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

class DetailedTripsBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const DetailedTripsBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DetailedTripsBottomSheetInputArgs args = request.customData;

    return BaseHalfScreenBottomSheet(
      request: request,
      completer: completer,
      child: Column(
        children: [
          Card(
            elevation: defaultElevation,
            shape: getCardShape(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    right: 16,
                    left: 16,
                  ),
                  child: buildTitle(trip: args.clickedTrip),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: AppColors.routesCardColor,
                  child: Column(
                    children: [
                      buildContentRow(
                        helper: RowHelper(
                          label1: 'Dispatch Time',
                          value1: args.clickedTrip.dispatchDateTime.toString(),
                          label2: 'Route Id',
                          value2: args.clickedTrip.routeId.toString(),
                        ),
                      ),
                      buildContentRow(
                        helper: RowHelper(
                          label1: 'Collect',
                          value1: args.clickedTrip.itemCollect.toString(),
                          label2: 'Title',
                          value2: args.clickedTrip.consignmentTitle.toString(),
                        ),
                      ),
                      buildContentRow(
                        helper: RowHelper(
                          label1: 'Date',
                          value1: args.clickedTrip.consignmentDate.toString(),
                          label2: 'Item Unit',
                          value2: args.clickedTrip.itemUnit.toString(),
                        ),
                      ),
                      buildContentRow(
                        helper: RowHelper(
                          label1: 'Consignment Id',
                          value1: args.clickedTrip.consignmentId.toString(),
                          label2: 'Consignment Title',
                          value2: args.clickedTrip.consignmentTitle.toString(),
                        ),
                      ),
                      buildContentRow(
                        helper: RowHelper(
                          label1: 'Drop',
                          value1: args.clickedTrip.itemDrop.toString(),
                          label2: 'Payment',
                          value2: args.clickedTrip.payment.toString(),
                        ),
                      ),
                      buildContentRow(
                        helper: RowHelper(
                          label1: 'Vehicle Number',
                          value1: args.clickedTrip.vehicleId.toString(),
                          label2: 'Item Weight',
                          value2: args.clickedTrip.itemWeight.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // shouldShowStartTripButton(
          //   dispatchTime: args.clickedTrip.dispatchDateTime,
          // )
          //     ? Padding(
          //         padding: const EdgeInsets.all(4.0),
          //         child: SizedBox(
          //           height: buttonHeight,
          //           child: AppButton(
          //               borderWidth: 0,
          //               borderColor: AppColors.primaryColorShade5,
          //               onTap: () {
          //                 completer(
          //                   SheetResponse(
          //                     confirmed: true,
          //                     responseData: DetailedTripsBottomSheetOutputArgs(
          //                       clickedTrip: args.clickedTrip,
          //                     ),
          //                   ),
          //                 );
          //               },
          //               background: AppColors.primaryColorShade5,
          //               buttonText: 'Review'),
          //         ),
          //       )
          //     : Container()
        ],
      ),
    );
  }

  SizedBox buildContentRow({
    @required RowHelper helper,
  }) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: AppTextView(
              labelFontSize: helper.labelFontSize,
              valueFontSize: helper.valueFontSize,
              showBorder: false,
              textAlign: TextAlign.left,
              isUnderLined: false,
              hintText: helper.label1,
              value: helper.value1,
            ),
          ),
          wSizedBox(10),
          Expanded(
            flex: 1,
            child: AppTextView(
              labelFontSize: helper.labelFontSize,
              valueFontSize: helper.valueFontSize,
              showBorder: false,
              textAlign: TextAlign.left,
              isUnderLined: false,
              hintText: helper.label2,
              value: helper.value2,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildTitle({@required ConsignmentTrackingStatusResponse trip}) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                consignmentIcon,
                height: 20,
                width: 20,
              ),
              wSizedBox(8),
              Text(
                'C#${trip.consignmentId}',
                style: AppTextStyles.latoBold12Black
                    .copyWith(color: AppColors.primaryColorShade5),
              )
            ],
          ),
        ],
      ),
    );
  }

  shouldShowStartTripButton({String dispatchTime}) {
    var now = new DateTime.now();

    DateTime timeToDispatch = DateTime.parse(
      DateFormat("dd-MM-yyyy", "en_US")
          .add_jms()
          .parse(dispatchTime)
          .toString(),
    );
    //Todo remove before deploying
    return true;
    var different = timeToDispatch.difference(now);

    return different.inMinutes < 30;
  }
}

class DetailedTripsBottomSheetInputArgs {
  final ConsignmentTrackingStatusResponse clickedTrip;

  DetailedTripsBottomSheetInputArgs({
    @required this.clickedTrip,
  });
}

class DetailedTripsBottomSheetOutputArgs {
  final ConsignmentTrackingStatusResponse clickedTrip;

  DetailedTripsBottomSheetOutputArgs({@required this.clickedTrip});
}

class RowHelper {
  final String label1, label2;
  final String value1, value2;
  final double valueFontSize, labelFontSize;

  RowHelper({
    @required this.label1,
    @required this.label2,
    @required this.value1,
    @required this.value2,
    this.valueFontSize = appTextViewValueFontSize,
    this.labelFontSize = appTextViewLabelFontSize,
  });
}
