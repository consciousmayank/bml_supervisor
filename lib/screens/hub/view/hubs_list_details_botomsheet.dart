import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

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
    return BaseHalfScreenBottomSheet(
      request: request,
      completer: completer,
      height: MediaQuery.of(context).size.height * 0.60,
      margin: const EdgeInsets.all(0),
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
          Card(
            shape: getCardShape(),
            color: AppColors.appScaffoldColor,
            margin: getSidePadding(context: context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  HubsListTextView(
                    label: 'Hub Title',
                    value: singleHubInfo.title,
                  ),
                  HubsListTextView(
                    label: 'Contact Person',
                    value: singleHubInfo.contactPerson,
                  ),
                  HubsListTextView(
                    label: 'Email Id',
                    value: singleHubInfo.email,
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: HubsListTextView(
                            label: 'Mobile',
                            value: singleHubInfo.mobile,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: HubsListTextView(
                            // labelFontSize: helper.labelFontSize,
                            // valueFontSize: helper.valueFontSize,
                            label: 'Mobile (Alternate)',
                            value: singleHubInfo.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClickableWidget(
                    childColor: AppColors.white,
                    onTap: () {
                      launchMaps(
                          latitude: singleHubInfo.geoLatitude,
                          longitude: singleHubInfo.geoLongitude);
                    },
                    borderRadius: getBorderRadius(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Address",
                            style: AppTextStyles.underLinedText,
                          ),
                          hSizedBox(20),
                          singleHubInfo.street != null &&
                                  singleHubInfo.street != 'NA'
                              ? Text(
                                  singleHubInfo.street,
                                  style: AppTextStyles.lato20PrimaryShade5
                                      .copyWith(
                                    fontSize: 14,
                                  ),
                                )
                              : Container(),
                          singleHubInfo.locality != null &&
                                  singleHubInfo.locality != 'NA'
                              ? Text(
                                  singleHubInfo.locality,
                                  style: AppTextStyles.lato20PrimaryShade5
                                      .copyWith(
                                    fontSize: 14,
                                  ),
                                )
                              : Container(),
                          singleHubInfo.landmark != null &&
                                  singleHubInfo.landmark != 'NA'
                              ? Text(
                                  'Landmark : ' + singleHubInfo.landmark,
                                  style: AppTextStyles.lato20PrimaryShade5
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              : Container(),
                          Text(
                            '${singleHubInfo.city}, ${singleHubInfo.pincode}, ${singleHubInfo.state}',
                            style: AppTextStyles.lato20PrimaryShade5.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${singleHubInfo.country}',
                            style: AppTextStyles.lato20PrimaryShade5.copyWith(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
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

class HubsListTextView extends StatelessWidget {
  final String label, value;

  const HubsListTextView({
    Key key,
    @required this.label,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextView(
      labelFontSize: 12,
      valueFontSize: 13,
      showBorder: false,
      textAlign: TextAlign.left,
      isUnderLined: false,
      hintText: label,
      value: value,
    );
  }
}
