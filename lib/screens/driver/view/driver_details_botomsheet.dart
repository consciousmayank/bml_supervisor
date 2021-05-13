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
      request: request,
      completer: completer,
      child: Expanded(
        child: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelStyle: AppTextStyles.latoBold14Black,
                unselectedLabelStyle: AppTextStyles.latoMedium14Black,
                labelColor: AppColors.primaryColorShade5,
                unselectedLabelColor: AppColors.black,
                indicatorColor: AppColors.primaryColorShade5,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    text: 'Info',
                  ),
                  Tab(
                    text: 'Addresses',
                  ),
                  Tab(
                    text: 'BankDetails',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Card(
                      shape: getCardShape(),
                      elevation: defaultElevation,
                      child: InfoWidget(
                        driverInfo: args.driverInfo,
                      ),
                    ),
                    AddressesWidget(
                      addressList: args.driverInfo.address,
                    ),
                    Card(
                      shape: getCardShape(),
                      elevation: defaultElevation,
                      child: BankDetailsWidget(
                        bankDetailsList: args.driverInfo.bank,
                      ),
                    ),
                  ],
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
  final DriverInfo driverInfo;

  const InfoWidget({Key key, @required this.driverInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildContentRow(
              helper: RowHelper(
                label1: 'Name',
                value1:
                    '${driverInfo.salutation} ${driverInfo.firstName} ${driverInfo.lastName}',
                label2: 'Father\'s Name',
                value2: driverInfo.fatherName,
              ),
            ),
            hSizedBox(10),
            buildContentRow(
              helper: RowHelper(
                label1: 'Vehicle Id',
                value1: driverInfo.vehicleId,
                label2: 'Driving License Number',
                value2: driverInfo.drivingLicense,
              ),
            ),
            hSizedBox(10),
            buildContentRow(
              helper: RowHelper(
                label1: 'Work Experience (in Years)',
                value1: driverInfo.workExperienceYr.toString(),
                label2: 'Aadhar Card Number',
                value2: driverInfo.aadhaar,
              ),
            ),
            hSizedBox(10),
            buildContentRow(
              helper: RowHelper(
                label1: 'Mobile No.',
                onValue1Clicked: () {
                  launch("tel://+91-${driverInfo.mobile.trim()}");
                },
                value1: driverInfo.mobile,
                onValue2Clicked: () {
                  launch("tel://+91-${driverInfo.mobileAlternate.trim()}");
                },
                label2: 'Mobile No. Alternate',
                value2: driverInfo.mobileAlternate,
              ),
            ),
            hSizedBox(10),
            buildContentRow(
              helper: RowHelper(
                label1: 'WhatsApp No.',
                value1: driverInfo.mobileWhatsApp,
                label2: 'Email Id',
                value2: driverInfo.email ?? 'NA',
              ),
            ),
            hSizedBox(10),
            buildContentRow(
              helper: RowHelper(
                label1: 'Date Of Birth',
                value1: driverInfo.dob,
                label2: 'Date of Joining',
                value2: driverInfo.dateOfJoin,
              ),
            ),
            hSizedBox(10),
            buildContentRow(
              helper: RowHelper(
                label1: 'Blood Group',
                value1: driverInfo.bloodGroup,
                label2: 'Nationality',
                value2: driverInfo.nationality ?? 'NA',
              ),
            ),
          ],
        ),
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
                  shape: getCardShape(),
                  elevation: defaultElevation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addressList[index].addressLine1 != null &&
                                addressList[index].addressLine1 != 'NA'
                            ? Text(
                                addressList[index].addressLine1,
                                style:
                                    AppTextStyles.lato20PrimaryShade5.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            : Container(),
                        addressList[index].addressLine2 != null &&
                                addressList[index].addressLine2 != 'NA'
                            ? Text(
                                addressList[index].addressLine2,
                                style:
                                    AppTextStyles.lato20PrimaryShade5.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            : Container(),
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
                                'Landmark : ' + addressList[index].nearby,
                                style:
                                    AppTextStyles.lato20PrimaryShade5.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            : Container(),
                        Text(
                          '${addressList[index].city}, ${addressList[index].pincode}, ${addressList[index].state}',
                          style: AppTextStyles.lato20PrimaryShade5.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${addressList[index].country}',
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
  final List bankDetailsList;

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
            child: Container(
              color: Colors.red,
            ),
          );
  }
}

class DriverDetailsBottomSheetInputArgs {
  final DriverInfo driverInfo;

  DriverDetailsBottomSheetInputArgs({@required this.driverInfo});
}
