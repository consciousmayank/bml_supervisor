import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/models/vehicle_info.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class VehicleDetailsBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const VehicleDetailsBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VehicleDetailsBottomSheetInputArgs args = request.customData;
    return BaseBottomSheet(
      bottomSheetTitle: 'VEHICLE DETAILS',
      request: request,
      completer: completer,
      child: InfoWidget(
        vehicleInfo: args.vehicleInfo,
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final VehicleInfo vehicleInfo;

  const InfoWidget({Key key, @required this.vehicleInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          children: [
            buildGridItem(
              label: 'Owner Name',
              value: vehicleInfo.ownerName,
            ),
            buildGridItem(
              label: 'Vehicle Number',
              value: vehicleInfo.registrationNumber,
            ),
            buildGridItem(
              label: 'Vehicle Class',
              value: vehicleInfo.vehicleClass,
            ),
            buildGridItem(
              label: 'Owner Level',
              value: vehicleInfo.ownerLevel.toString(),
            ),
            buildGridItem(
              label: 'Chassis Number',
              value: vehicleInfo.chassisNumber,
            ),
            buildGridItem(
              label: 'Engine Number',
              value: vehicleInfo.engineNumber,
            ),
            buildGridItem(
              label: 'Vehicle Model',
              value: vehicleInfo.model,
            ),
            buildGridItem(
              label: 'Vehicle Company',
              value: vehicleInfo.make,
            ),
            buildGridItem(
              label: 'Registration Date',
              value: vehicleInfo.registrationDate,
            ),
            buildGridItem(
              label: 'Registration Expiry Date',
              value: vehicleInfo.registrationUpto,
            ),
            buildGridItem(
              label: 'Emission Norm',
              value: vehicleInfo.emission,
            ),
            buildGridItem(
              label: 'Vehicle Color',
              value: vehicleInfo.color,
            ),
            buildGridItem(
              label: 'Fuel Type',
              value: vehicleInfo.fuelType,
            ),
            buildGridItem(
              label: 'RTO City',
              value: vehicleInfo.rto,
            ),

            buildGridItem(
              label: 'Initial Reading',
              value: vehicleInfo.initReading.toString(),
            ),
            buildGridItem(
              label: 'Load Capacity (kg)',
              value: vehicleInfo.loadCapacity,
            ),
            buildGridItem(
              label: 'Seating Capacity',
              value: vehicleInfo.seatingCapacity.toString(),
            ),
            buildGridItem(
              label: 'Vehicle Length (mm)',
              value: vehicleInfo.length.toString(),
            ),

            buildGridItem(
              label: 'Vehicle Width (mm)',
              value: vehicleInfo.width.toString(),
            ),
            buildGridItem(
              label: 'Vehicle Height (mm)',
              value: vehicleInfo.height.toString(),
            ),
            buildGridItem(
              label: 'Fast Tag ID',
              value: vehicleInfo.fastTagId,
            ),
            buildGridItem(
              label: 'Fast Tag UPI ID',
              value: vehicleInfo.fastTagUpiId,
            ),

            // Card(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Name',
            //         textAlign: TextAlign.right,
            //       ),
            //       Text(
            //         'Name',
            //         textAlign: TextAlign.right,
            //       ),
            //     ],
            //   ),
            // ),
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: AppTextView(
            //       // lines: linesForValue1,
            //       labelFontSize: 13,
            //       valueFontSize: 14,
            //       showBorder: false,
            //       textAlign: TextAlign.left,
            //       isUnderLined: false,
            //       hintText: 'Owner Name',
            //       value: args.vehicleInfo.ownerName,
            //     ),
            //   ),
            // ),
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: AppTextView(
            //       // lines: linesForValue1,
            //       labelFontSize: 13,
            //       valueFontSize: 14,
            //       showBorder: false,
            //       textAlign: TextAlign.left,
            //       isUnderLined: false,
            //       hintText: 'Registration Number',
            //       value: args.vehicleInfo.registrationNumber,
            //     ),
            //   ),
            // ),
            // buildContentRow(
            //   helper: RowHelper(
            //     label1: 'Owner Name',
            //     value1: '${args.vehicleInfo.ownerName}',
            //     label2: 'Registration Number',
            //     value2: args.vehicleInfo.registrationNumber,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Container buildGridItem({
    @required String label,
    @required String value,
    Function onValueClicked,
  }) {
    return Container(
      color: AppColors.bottomSheetGridTileColors,
      // decoration: BoxDecoration(
      // borderRadius: BorderRadius.all(Radius.circular(6)),
      // color: Colors.white,
      // border: Border.all(
      //   color: AppColors.appScaffoldColor,
      // ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: AppTextStyles.latoMedium14Black
                  .copyWith(color: AppColors.primaryColorShade4, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: onValueClicked == null
                  ? null
                  : () {
                      onValueClicked.call();
                    },
              child: Text(
                value == null ? 'NA' : value,
                textAlign: TextAlign.left,
                style: AppTextStyles.latoMedium16Primary5
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                // TextStyle(
                //     fontSize: 16,
                //     color: AppColors.primaryColorShade5
                // )
              ),
            ),
          ),
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

SizedBox buildContentRow({@required RowHelper helper}) {
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

class VehicleDetailsBottomSheetInputArgs {
  final VehicleInfo vehicleInfo;

  VehicleDetailsBottomSheetInputArgs({@required this.vehicleInfo});
}
