import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
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
      bottomSheetTitle: 'Hub Details',
      request: request,
      completer: completer,
      child: HubInfoWidget(
        singleHubInfo: args.singleHubInfo,
      ),
    );
  }
}

class HubInfoWidget extends StatelessWidget {
  final HubResponse singleHubInfo;

  const HubInfoWidget({Key key, @required this.singleHubInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // hSizedBox(5),
          buildHubTitleItem(
            context: context,
            label: 'Hub Title',
            value: singleHubInfo.title,
            // value: 'We are a really big company name private limited. '.toUpperCase(),
          ),
          buildHubTitleItem(
            context: context,
            label: 'Contact Person',
            value: singleHubInfo.contactPerson,
            // value: 'Space for people with really reallly big name',
          ),

          Expanded(
            flex: 4,
            child: Container(
              // color: Colors.red,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                children: [
                  buildGridItem(
                    label: 'Registration Date',
                    value: singleHubInfo.registrationDate,
                  ),
                  buildGridItem(
                      label: 'Mobile',
                      value: singleHubInfo.mobile,
                      onValueClicked: () {
                        launch("tel://+91-${singleHubInfo.mobile.trim()}");
                      }),
                  buildGridItem(
                    label: 'Emil ID',
                    value: singleHubInfo.email.toLowerCase(),
                  ),
                  buildGridItem(
                      label: 'Alternate Number',
                      value: singleHubInfo.phone,
                      onValueClicked: () {
                        launch("tel://+91-${singleHubInfo.phone.trim()}");
                      }),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: buildRemarkItem(
              context: context,
              label: 'Remarks',
              value: singleHubInfo.remarks,
              // value: 'This is really long remark. ' * 9,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.latoMedium16Primary5
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              // color: Colors.deepPurple,
              // height: 200,
              width: MediaQuery.of(context).size.width,
              child: Card(
                // color: Colors.lightBlue,
                color: AppColors.bottomSheetGridTileColors,
                shape: Border(
                  left:
                      BorderSide(color: AppColors.primaryColorShade5, width: 4),
                ),
                // shape: getCardShape(),
                elevation: defaultElevation,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          launchMaps(
                              latitude: singleHubInfo.geoLatitude,
                              longitude: singleHubInfo.geoLongitude);
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              locationIcon,
                              height: 50,
                              width: 50,
                              color: AppColors.primaryColorShade5,
                            ),
                            Text(
                              "Get Direction",
                              style: AppTextStyles.latoBold12Black.copyWith(
                                  color: AppColors.primaryColorShade5),
                            )
                          ],
                        ),
                      ),
                      hSizedBox(8),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            singleHubInfo.street != null &&
                                    singleHubInfo.street != 'NA'
                                ? TextSpan(
                                    text: singleHubInfo.street + ', ',
                                    style: AppTextStyles.lato20PrimaryShade5
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                  )
                                : TextSpan(),
                            singleHubInfo.locality != null &&
                                    singleHubInfo.locality != 'NA'
                                ? TextSpan(
                                    text: singleHubInfo.locality,
                                    style: AppTextStyles.lato20PrimaryShade5
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                  )
                                : TextSpan(),
                          ],
                        ),
                      ),
                      hSizedBox(6),
                      singleHubInfo.landmark != null &&
                              singleHubInfo.landmark != 'NA'
                          ? Text(
                              'Landmark: ' + singleHubInfo.landmark,
                              style: AppTextStyles.lato20PrimaryShade5.copyWith(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      Text(
                        '${singleHubInfo.city}, ${singleHubInfo.pincode}',
                        style: AppTextStyles.lato20PrimaryShade5.copyWith(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      hSizedBox(6),
                      Text(
                        '${singleHubInfo.state}, ${singleHubInfo.country}',
                        style: AppTextStyles.lato20PrimaryShade5.copyWith(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          hSizedBox(10),
        ],
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

  Container buildRemarkItem({
    @required String label,
    @required String value,
    Function onValueClicked,
    BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bottomSheetGridTileColors,
        border: Border(
          top: BorderSide(color: AppColors.appScaffoldColor, width: 0.1),
        ),
      ),
      // height: 80,
      width: MediaQuery.of(context).size.width,
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
                style: AppTextStyles.latoMedium16Primary5.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
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

  Container buildHubTitleItem({
    @required String label,
    @required String value,
    Function onValueClicked,
    BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bottomSheetGridTileColors,
        border: Border(
          bottom: BorderSide(color: AppColors.appScaffoldColor, width: 1),
        ),
      ),
      height: 70,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      // borderRadius: BorderRadius.all(Radius.circular(6)),
      // color: Colors.white,
      // border: Border.all(
      //   color: AppColors.appScaffoldColor,
      // ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.latoMedium14Black
                  .copyWith(color: AppColors.primaryColorShade4, fontSize: 12),
            ),
            InkWell(
              onTap: onValueClicked == null
                  ? null
                  : () {
                      onValueClicked.call();
                    },
              child: Text(
                value == null ? 'NA' : value,
                textAlign: TextAlign.left,
                style: AppTextStyles.latoMedium16Primary5.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                // TextStyle(
                //     fontSize: 16,
                //     color: AppColors.primaryColorShade5
                // )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HubsListDetailsBottomSheetInputArgs {
  final HubResponse singleHubInfo;

  HubsListDetailsBottomSheetInputArgs({@required this.singleHubInfo});
}
