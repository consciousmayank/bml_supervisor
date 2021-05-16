import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/models/vehicle_info.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class HubsListDetailsBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const HubsListDetailsBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HubsListDetailsBottomSheetInputArgs args = request.customData;
    return BaseBottomSheet(
      request: request,
      completer: completer,
      child: InfoWidget(
        singleHubInfo: args.singleHubInfo,
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final HubResponse singleHubInfo;

  const InfoWidget({Key key, @required this.singleHubInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Owner Name',
          //     value1: '${vehicleInfo.ownerName}',
          //     label2: 'Registration Number',
          //     value2: vehicleInfo.registrationNumber,
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Vehicle Class',
          //     value1: '${vehicleInfo.vehicleClass}',
          //     label2: 'Owner Level',
          //     value2: vehicleInfo.ownerLevel.toString(),
          //     label3: 'Last Owner',
          //     value3: vehicleInfo?.lastOwner ?? 'NA',
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Chassis Number',
          //     value1: vehicleInfo.chassisNumber,
          //     label2: 'Engine Number',
          //     value2: vehicleInfo.engineNumber,
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Vehicle Type',
          //     value1: '${vehicleInfo.make}, ${vehicleInfo.model}',
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Rto',
          //     value1: '${vehicleInfo.rto}',
          //     label2: 'Seating Capacity',
          //     value2: vehicleInfo.seatingCapacity.toString(),
          //     label3: 'Load Capacity',
          //     value3: vehicleInfo.loadCapacity,
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Registration Date',
          //     value1: '${vehicleInfo.registrationDate}',
          //     label2: 'Registration Upto',
          //     value2: vehicleInfo.registrationUpto,
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label2: 'Height',
          //     value2: '${vehicleInfo.height}',
          //     label3: 'Width',
          //     value3: vehicleInfo.width.toString(),
          //     label1: 'Length',
          //     value1: vehicleInfo.length.toString(),
          //   ),
          // ),
          // hSizedBox(10),
          // buildContentRow(
          //   helper: RowHelper(
          //     label1: 'Fast TagId',
          //     value1: '${vehicleInfo?.fastTagId ?? 'NA'}',
          //     label2: 'Fast Tag UPI Id',
          //     value2: vehicleInfo?.fastTagUpiId ?? "NA",
          //   ),
          // ),
        ],
      ),
    );
  }
}

class RowHelper {
  final String label1, label2, label3;
  final String value1, value2, value3;
  final double valueFontSize, labelFontSize;
  final Function onValue1Clicked, onValue2Clicked, onValue3Clicked;

  RowHelper({
    @required this.label1,
    this.label2,
    this.label3,
    @required this.value1,
    this.value2,
    this.value3,
    this.valueFontSize = 14,
    this.labelFontSize = 13,
    this.onValue1Clicked,
    this.onValue2Clicked,
    this.onValue3Clicked,
  });
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
          child: InkWell(
            onTap: helper.onValue1Clicked == null
                ? null
                : () {
                    helper.onValue1Clicked.call();
                  },
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
        ),
        wSizedBox(10),
        if (helper.label2 != null)
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: helper.onValue2Clicked == null
                  ? null
                  : () {
                      helper.onValue2Clicked.call();
                    },
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
          ),
        if (helper.label3 != null)
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: helper.onValue3Clicked == null
                  ? null
                  : () {
                      helper.onValue3Clicked.call();
                    },
              child: AppTextView(
                labelFontSize: helper.labelFontSize,
                valueFontSize: helper.valueFontSize,
                showBorder: false,
                textAlign: TextAlign.left,
                isUnderLined: false,
                hintText: helper.label3,
                value: helper.value3,
              ),
            ),
          ),
      ],
    ),
  );
}

class HubsListDetailsBottomSheetInputArgs {
  final HubResponse singleHubInfo;

  HubsListDetailsBottomSheetInputArgs({@required this.singleHubInfo});
}
