import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/enums/trip_statuses.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';

import 'app_text_view.dart';

class SingleTripItem extends StatelessWidget {
  final ConsignmentTrackingStatusResponse singleListItem;
  final Function onTap;
  final Function onCheckBoxTapped;
  final TripStatus status;

  const SingleTripItem({
    Key key,
    @required this.singleListItem,
    this.onTap,
    this.status = TripStatus.UPCOMING,
    @required this.onCheckBoxTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return status == TripStatus.APPROVED || status == TripStatus.COMPLETED
        ? buildInkBody(context)
        : Card(
            elevation: defaultElevation,
            shape: getCardShape(),
            child: buildInkBody(context),
          );
  }

  InkWell buildInkBody(BuildContext context) {
    return InkWell(
      onTap: status == TripStatus.ONGOING
          ? () {
              onCheckBoxTapped(!singleListItem.isSelected, singleListItem);
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              right: 4,
              left: 4,
            ),
            child: buildTitle(context),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            color: AppColors.routesCardColor,
            child: Column(
              children: [
                buildContentRow(
                  helper: RowHelper(
                    label1: 'Item Value',
                    value1:
                        '${singleListItem.itemWeight.toString()} ${singleListItem.itemUnit.toString()}',
                    label2: 'Remarks',
                    value2: singleListItem.routeDesc,
                  ),
                ),
                hSizedBox(5),
                buildContentRow(
                  helper: RowHelper(
                    label1: 'Description',
                    value1: singleListItem.routeDesc,
                    label2: null,
                    value2: null,
                    label3: null,
                    value3: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContentRow({
    @required RowHelper helper,
  }) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (helper.label1 != null)
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
          if (helper.label2 != null) wSizedBox(10),
          if (helper.label2 != null)
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
          if (helper.label3 != null) wSizedBox(10),
          if (helper.label3 != null)
            Expanded(
              flex: 2,
              child: helper.label3 == null
                  ? Container()
                  : AppTextView(
                      labelFontSize: helper.labelFontSize,
                      valueFontSize: helper.valueFontSize,
                      showBorder: false,
                      textAlign: TextAlign.left,
                      isUnderLined: false,
                      hintText: helper.label3,
                      value: helper.value3,
                    ),
            ),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            'C#${singleListItem.consignmentId}',
                            style: AppTextStyles.latoBold12Black
                                .copyWith(color: AppColors.primaryColorShade5),
                          )
                        ],
                      ),
                      status == TripStatus.ONGOING ||
                              status == TripStatus.UPCOMING
                          ? Container()
                          : SizedBox(
                              height: 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    'Status : ',
                                    style:
                                        AppTextStyles.latoBold12Black.copyWith(
                                      color: AppColors.primaryColorShade5,
                                      fontSize: 8,
                                    ),
                                  ),
                                  Text(
                                    getStatusTitle(
                                        statusCode: singleListItem.statusCode,
                                        context: context),
                                    style: getStatusTitleStyle(
                                        statusCode: singleListItem.statusCode),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppButton(
                        buttonTextFontWeight: FontWeight.normal,
                        borderWidth: 0,
                        borderColor: AppColors.primaryColorShade5,
                        onTap: () {
                          if (onTap != null) onTap.call();
                        },
                        background: AppColors.primaryColorShade5,
                        buttonText: 'View'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getStatusTitle({int statusCode, BuildContext context}) {
    switch (statusCode) {
      case 3:
        return 'Completed';
        break;
      case 4:
        return 'Completed & Verified';
        break;
      default:
        return 'Rejected';
    }
  }

  getStatusTitleStyle({int statusCode}) {
    switch (statusCode) {
      case 3:
        return AppTextStyles.latoBold12Black.copyWith(
          color: AppColors.primaryColorShade5,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        );
        break;
      case 4:
        return AppTextStyles.latoBold12Black.copyWith(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        );
        break;
      default:
        return AppTextStyles.latoBold12Black.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );
    }
  }
}

class RowHelper {
  final String label1, label2, label3;
  final String value1, value2, value3;
  final double valueFontSize, labelFontSize;

  RowHelper({
    @required this.label1,
    @required this.label2,
    this.label3,
    this.value1,
    this.value2,
    this.value3,
    this.valueFontSize = appTextViewValueFontSize,
    this.labelFontSize = appTextViewLabelFontSize,
  });
}
