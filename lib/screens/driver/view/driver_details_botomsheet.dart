import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/driver-info.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDetailsBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const DriverDetailsBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DriverDetailsBottomSheetInputArgs args = request.customData;
    return BaseBottomSheet(
      bottomSheetTitle: 'Driver Details',
      request: request,
      completer: completer,
      child: DriverInfoWidget(args: args),
    );
  }
}

class DriverInfoWidget extends StatelessWidget {
  const DriverInfoWidget({
    Key key,
    @required this.args,
  }) : super(key: key);

  final DriverDetailsBottomSheetInputArgs args;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          hSizedBox(16),
          ClickableWidget(
            onTap: () {
              // widget.userProfileViewModel.showImageBottomSheet();
            },
            borderRadius: getBorderRadius(borderRadius: 20),
            child: ProfileImageWidget(
              image: args.driverInfo.photo != null &&
                  args.driverInfo.photo.length == 0
                  ? null
                  : getImageFromBase64String(
                base64String: args.driverInfo.photo,
              ),
              // image: null,
              circularBorderRadius: 100,
              size: 120,
            ),
          ),
          hSizedBox(8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${args.driverInfo?.salutation ?? ''} ',
                  style: AppTextStyles.latoBold18PrimaryShade5.copyWith(
                    color: AppColors.primaryColorShade5,
                    fontSize: 10,
                  ),
                ),
                TextSpan(
                  text:
                  '${args.driverInfo?.firstName ?? ''} ${args.driverInfo?.lastName ?? ''}',
                  style: AppTextStyles.latoBold18PrimaryShade5
                      .copyWith(color: AppColors.primaryColorShade5),
                ),
              ],
            ),
          ),
          // Text(
          //   '${args.driverInfo?.salutation ?? ''}. ${args.driverInfo?.firstName ?? ''} ${args.driverInfo?.lastName ?? ''}',
          //   // args.driverInfo.na,
          //   style: AppTextStyles.latoBold18PrimaryShade5
          //       .copyWith(color: AppColors.primaryColorShade5),
          // ),
          hSizedBox(8),
          Text(
            '( Exp: ${args.driverInfo.workExperienceYr} Yrs)',
            style: AppTextStyles.latoBold18PrimaryShade5.copyWith(fontSize: 10),
          ),
          hSizedBox(16),
          // DottedDivider(),
          // Divider(
          //   height: 1,
          //   thickness: 1,
          //   color: AppColors.primaryColorShade5,
          // ),
          // hSizedBox(12),
          Expanded(
            child: DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    // indicatorWeight: 5,
                    labelStyle: AppTextStyles.latoBold14Black,
                    unselectedLabelStyle: AppTextStyles.latoMedium14Black,
                    // unselectedLabelStyle: AppTextStyles.underLinedText.copyWith(
                    //     color: AppColors.primaryColorShade5, fontSize: 15),

                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.black,
                    // indicatorColor: Colors.green,
                    // unselectedLabelColor: Colors.red,
                    // automaticIndicatorColorAdjustment: true,
                    // indicatorColor: AppColors.white,
                    // indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.primaryColorShade5,
                    ),
                    tabs: [
                      Tab(
                        text: 'Personal Info',
                      ),
                      Tab(
                        text: 'Address',
                      ),
                      Tab(
                        text: 'Bank Info',
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: AppColors.primaryColorShade5,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Center(
                        //   child: Text('fun'),
                        // ),
                        // Center(
                        //   child: Text('fun'),
                        // ),
                        InfoWidget(
                          driverInfo: args.driverInfo,
                        ),
                        AddressesWidget(
                          addressList: args.driverInfo.address,
                        ),
                        BankDetailsWidget(
                          bankDetailsList: args.driverInfo.bank,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final DriverInfo driverInfo;

  const InfoWidget({Key key, @required this.driverInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3 / 1,
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      children: [
        buildGridItem(
          label: 'Vehicle Number',
          value: driverInfo.vehicleId,
        ),
        buildGridItem(
          label: 'Father\'s Name',
          value: driverInfo.fatherName,
        ),
        buildGridItem(
            label: 'Mobile',
            value: driverInfo.mobile,
            onValueClicked: () {
              launch("tel://+91-${driverInfo.mobile.trim()}");
            }),
        buildGridItem(
          label: 'Driving License Number',
          value: driverInfo.drivingLicense,
        ),
        buildGridItem(
            label: 'Alternate Number',
            value: driverInfo.mobileAlternate,
            onValueClicked: () {
              launch("tel://+91-${driverInfo.mobileAlternate.trim()}");
            }),
        buildGridItem(
          label: 'Aadhar Card Number',
          value: driverInfo.aadhaar,
        ),
        buildGridItem(
          label: 'WhatsApp No.',
          value: driverInfo.mobileWhatsApp,
        ),
        buildGridItem(
          label: 'Email ID',
          value: driverInfo.email,
        ),
        buildGridItem(
          label: 'Date of Birth',
          value: driverInfo.dob,
        ),
        buildGridItem(
          label: 'Date of Joining',
          value: driverInfo.dateOfJoin,
        ),
        buildGridItem(
          label: 'Blood Group',
          value: driverInfo.bloodGroup,
        ),
        buildGridItem(
          label: 'Nationality',
          value: driverInfo.nationality,
        ),
        buildGridItem(
          label: 'Designation (Change val to Str)',
          value: driverInfo.designation.toString(),
        ),
        buildGridItem(
          label: 'Gender',
          value: driverInfo.gender,
        ),
        buildGridItem(
          label: 'Last Company',
          value: driverInfo.lastCompany,
        ),
        buildGridItem(
          label: 'Last Company Leaving Date',
          value: driverInfo.lastCompanyDol,
        ),

        buildGridItem(
          label: 'Username',
          value: driverInfo.username,
        ),

        buildGridItem(
          label: 'Remarks',
          value: driverInfo.remarks,
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
                style: AppTextStyles.latoMedium16Primary5.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
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
}

class RowHelper {
  final String label1, label2;
  final String value1, value2;
  final double valueFontSize, labelFontSize;
  final Function onValue1Clicked, onValue2Clicked;

  RowHelper({
    @required this.label1,
    @required this.label2,
    @required this.value1,
    @required this.value2,
    this.valueFontSize = 14,
    this.labelFontSize = 12,
    this.onValue1Clicked,
    this.onValue2Clicked,
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
        Expanded(
          flex: 2,
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
      ],
    ),
  );
}

class AddressesWidget extends StatelessWidget {
  final List<Address> addressList;

  const AddressesWidget({Key key, @required this.addressList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return addressList.length == 0
        ? Expanded(
      child: Container(
        child: Center(
          child: NoDataWidget(),
        ),
      ),
    )
        : Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.bottomSheetGridTileColors,
            shape: Border(
              left: BorderSide(
                  color: AppColors.primaryColorShade5, width: 4),
            ),
            // shape: getCardShape(),
            elevation: defaultElevation,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        addressList[index].addressLine1 != null &&
                            addressList[index].addressLine1 != 'NA'
                            ? TextSpan(
                          text: addressList[index].addressLine1,
                          style: AppTextStyles.lato20PrimaryShade5
                              .copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                            : TextSpan(),
                        addressList[index].addressLine2 != null &&
                            addressList[index].addressLine2 != 'NA'
                            ? TextSpan(
                          text: ', ' +
                              addressList[index].addressLine2,
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
                  addressList[index].locality != null &&
                      addressList[index].locality != 'NA'
                      ? Text(
                    addressList[index].locality,
                    style:
                    AppTextStyles.lato20PrimaryShade5.copyWith(
                      fontSize: 14,
                    ),
                  )
                      : Container(),
                  addressList[index].nearby != null &&
                      addressList[index].nearby != 'NA'
                      ? Text(
                    'Landmark: ' + addressList[index].nearby,
                    style:
                    AppTextStyles.lato20PrimaryShade5.copyWith(
                      fontSize: 14,
                    ),
                  )
                      : Container(),
                  Text(
                    '${addressList[index].city}, ${addressList[index].pincode}',
                    style: AppTextStyles.lato20PrimaryShade5.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  hSizedBox(6),
                  Text(
                    '${addressList[index].state}, ${addressList[index].country}',
                    style: AppTextStyles.lato20PrimaryShade5.copyWith(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: addressList.length,
      ),
    );
  }
}

class BankDetailsWidget extends StatelessWidget {
  final List<Bank> bankDetailsList;

  const BankDetailsWidget({Key key, @required this.bankDetailsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bankDetailsList.length == 0
        ? Expanded(
      child: Container(
        child: Center(
          child: NoDataWidget(),
        ),
      ),
    )
        : Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            shape: Border(
              left: BorderSide(
                  color: AppColors.primaryColorShade5, width: 4),
            ),
            // shape: getCardShape(),
            elevation: defaultElevation,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildContentRow(
                    helper: RowHelper(
                      label1: 'Account Type',
                      value1: bankDetailsList[index].accountType,
                      label2: 'Account Number',
                      value2: bankDetailsList[index].accountNumber,
                    ),
                  ),
                  buildContentRow(
                    helper: RowHelper(
                      label1: 'Bank Type',
                      value1: bankDetailsList[index].type,
                      label2: 'Account Name',
                      value2: bankDetailsList[index].accountName,
                    ),
                  ),
                  buildContentRow(
                    helper: RowHelper(
                      label1: 'IFSC Number',
                      value1: bankDetailsList[index].ifsc,
                      label2: 'Bank Name',
                      value2: bankDetailsList[index].bankName,
                    ),
                  ),
                  buildContentRow(
                    helper: RowHelper(
                      label1: 'PAN',
                      value1: bankDetailsList[index].pan,
                      label2: 'Address',
                      value2: bankDetailsList[index].address,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: bankDetailsList.length,
      ),
    );
  }
}

class DriverDetailsBottomSheetInputArgs {
  final DriverInfo driverInfo;

  DriverDetailsBottomSheetInputArgs({@required this.driverInfo});
}
