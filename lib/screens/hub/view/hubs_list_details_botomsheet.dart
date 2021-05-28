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
      bottomSheetTitle: 'HUB DETAILS',
      request: request,
      completer: completer,
      child: HubInfoWidget(
        singleHubInfo: args.singleHubInfo,
      ),
    );
    //   BaseHalfScreenBottomSheet(
    //   request: request,
    //   completer: completer,
    //   height: MediaQuery.of(context).size.height * 0.85,
    //   margin: const EdgeInsets.all(0),
    //   child: HubInfoWidget(
    //     singleHubInfo: args.singleHubInfo,
    //   ),
    // );
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
          hSizedBox(10),
          Expanded(
            flex: 7,
            child: Container(
              // color: Colors.red,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                children: [
                  buildGridItem(
                    label: 'Hub Title',
                    value: singleHubInfo.title,
                  ),
                  buildGridItem(
                    label: 'Client ID',
                    value: singleHubInfo.clientId.toString(),
                  ),

                  buildGridItem(
                    label: 'Contact Person',
                    value: singleHubInfo.contactPerson,
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
                  buildGridItem(
                    label: 'Registration Date',
                    value: singleHubInfo.registrationDate,
                  ),
                  buildGridItem(
                    label: 'Remarks',
                    value: singleHubInfo.remarks,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ADDRESS',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.latoMedium16Primary5
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
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
                      // addressList[index].addressLine1 != null &&
                      //         addressList[index].addressLine1 != 'NA'
                      //     ? Text(
                      //         addressList[index].addressLine1 + ' :Line 1',
                      //         style:
                      //             AppTextStyles.lato20PrimaryShade5.copyWith(
                      //           fontSize: 14,
                      //         ),
                      //       )
                      //     : Container(),
                      // addressList[index].addressLine2 != null &&
                      //         addressList[index].addressLine2 != 'NA'
                      //     ? Text(
                      //         addressList[index].addressLine2 + ' :Line 2',
                      //         style:
                      //             AppTextStyles.lato20PrimaryShade5.copyWith(
                      //           fontSize: 14,
                      //         ),
                      //       )
                      //     : Container(),
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
          hSizedBox(110),
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
}

class AddressesWidget extends StatelessWidget {
  final HubResponse singleHubInfo;

  const AddressesWidget({Key key, @required this.singleHubInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        color: AppColors.bottomSheetGridTileColors,
        shape: Border(
          left: BorderSide(color: AppColors.primaryColorShade5, width: 4),
        ),
        // shape: getCardShape(),
        elevation: defaultElevation,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    singleHubInfo.street != null && singleHubInfo.street != 'NA'
                        ? TextSpan(
                            text: singleHubInfo.street + ', ',
                            style: AppTextStyles.lato20PrimaryShade5.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        : TextSpan(),
                    singleHubInfo.locality != null &&
                            singleHubInfo.locality != 'NA'
                        ? TextSpan(
                            text: singleHubInfo.locality,
                            style: AppTextStyles.lato20PrimaryShade5.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        : TextSpan(),
                  ],
                ),
              ),
              // addressList[index].addressLine1 != null &&
              //         addressList[index].addressLine1 != 'NA'
              //     ? Text(
              //         addressList[index].addressLine1 + ' :Line 1',
              //         style:
              //             AppTextStyles.lato20PrimaryShade5.copyWith(
              //           fontSize: 14,
              //         ),
              //       )
              //     : Container(),
              // addressList[index].addressLine2 != null &&
              //         addressList[index].addressLine2 != 'NA'
              //     ? Text(
              //         addressList[index].addressLine2 + ' :Line 2',
              //         style:
              //             AppTextStyles.lato20PrimaryShade5.copyWith(
              //           fontSize: 14,
              //         ),
              //       )
              //     : Container(),
              hSizedBox(6),
              singleHubInfo.landmark != null && singleHubInfo.landmark != 'NA'
                  ? Text(
                      'Landmark: ' + singleHubInfo.landmark,
                      style: AppTextStyles.lato20PrimaryShade5.copyWith(
                        fontSize: 14,
                      ),
                    )
                  : Container(),
              Text(
                '${singleHubInfo.city}, ${singleHubInfo.pincode}',
                style: AppTextStyles.lato20PrimaryShade5.copyWith(
                  fontSize: 14,
                ),
              ),
              hSizedBox(6),
              Text(
                '${singleHubInfo.state}, ${singleHubInfo.country}',
                style: AppTextStyles.lato20PrimaryShade5.copyWith(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final HubResponse singleHubInfo;

  const InfoWidget({Key key, @required this.singleHubInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              // color: Colors.red,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                children: [
                  buildGridItem(
                    label: 'Hub Title',
                    value: singleHubInfo.title,
                  ),
                  buildGridItem(
                    label: 'Client ID',
                    value: singleHubInfo.clientId.toString(),
                  ),

                  buildGridItem(
                    label: 'Contact Person',
                    value: singleHubInfo.contactPerson,
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
                  buildGridItem(
                    label: 'Registration Date',
                    value: singleHubInfo.registrationDate,
                  ),
                  buildGridItem(
                    label: 'Remarks',
                    value: singleHubInfo.remarks,
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
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'Address',
          //     style: AppTextStyles.latoBold18Black,
          //   ),
          // ),
          Expanded(
            flex: 6,
            child: Container(
              // color: Colors.deepPurple,
              height: 200,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
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
                      // addressList[index].addressLine1 != null &&
                      //         addressList[index].addressLine1 != 'NA'
                      //     ? Text(
                      //         addressList[index].addressLine1 + ' :Line 1',
                      //         style:
                      //             AppTextStyles.lato20PrimaryShade5.copyWith(
                      //           fontSize: 14,
                      //         ),
                      //       )
                      //     : Container(),
                      // addressList[index].addressLine2 != null &&
                      //         addressList[index].addressLine2 != 'NA'
                      //     ? Text(
                      //         addressList[index].addressLine2 + ' :Line 2',
                      //         style:
                      //             AppTextStyles.lato20PrimaryShade5.copyWith(
                      //           fontSize: 14,
                      //         ),
                      //       )
                      //     : Container(),
                      hSizedBox(6),
                      singleHubInfo.landmark != null &&
                              singleHubInfo.landmark != 'NA'
                          ? Text(
                              'Landmark: ' + singleHubInfo.landmark,
                              style: AppTextStyles.lato20PrimaryShade5.copyWith(
                                fontSize: 14,
                              ),
                            )
                          : Container(),
                      Text(
                        '${singleHubInfo.city}, ${singleHubInfo.pincode}',
                        style: AppTextStyles.lato20PrimaryShade5.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      hSizedBox(6),
                      Text(
                        '${singleHubInfo.state}, ${singleHubInfo.country}',
                        style: AppTextStyles.lato20PrimaryShade5.copyWith(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
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
