import 'dart:typed_data';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/models/entry_log.dart';
import 'package:bml_supervisor/screens/trips/reviewcompleted/review_completed_trips_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/datetime_converter.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bml_supervisor/widget/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class ReviewCompletedTripsView extends StatefulWidget {
  final ConsignmentTrackingStatusResponse selectedTrip;

  const ReviewCompletedTripsView({Key key, @required this.selectedTrip})
      : super(key: key);

  @override
  _ReviewCompletedTripsViewState createState() =>
      _ReviewCompletedTripsViewState();
}

class _ReviewCompletedTripsViewState extends State<ReviewCompletedTripsView> {
  TextEditingController startReadingController = TextEditingController();
  TextEditingController endReadingController = TextEditingController();

  FocusNode startReadingFocusNode = FocusNode();
  FocusNode endReadingFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReviewCompletedTripsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getCompletedTripsWithId(
        consignmentId: widget.selectedTrip.consignmentId,
      ),
      builder: (context, viewModel, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'C#${widget.selectedTrip.consignmentId}',
              style: AppTextStyles.appBarTitleStyle,
            ),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 12,
                )
              : bodyWidget(viewModel: viewModel),
        ),
        top: true,
        bottom: true,
      ),
      viewModelBuilder: () => ReviewCompletedTripsViewModel(),
    );
  }

  Widget bodyWidget({@required ReviewCompletedTripsViewModel viewModel}) {
    startReadingController.text = viewModel.startReading.toString();
    endReadingController.text = viewModel.endReading.toString();

    startReadingController.selection = TextSelection.fromPosition(
      TextPosition(offset: startReadingController.text.length),
    );

    endReadingController.selection = TextSelection.fromPosition(
      TextPosition(offset: endReadingController.text.length),
    );

    double widgetWidth = MediaQuery.of(context).size.width * 0.4;

    return viewModel.completedTripsDetails != null
        ? SingleChildScrollView(
            child: Padding(
              padding: getSidePadding(
                context: context,
              ),
              child: Column(
                children: [
                  buildMeterReadingWidget(
                      image: getImageFromBase64String(
                        base64String:
                            viewModel.completedTripsDetails.startReadingImage,
                      ),
                      readingType: ReadingType.START,
                      title: DateTimeToStringConverter.ddmmyy(
                              date: StringToDateTimeConverter.ddmmyy(
                                      date: viewModel
                                          .completedTripsDetails.creationdate)
                                  .convert())
                          .convert(),
                      viewModel: viewModel,
                      widgetWidth: widgetWidth,
                      controller: startReadingController,
                      latitude: viewModel.completedTripsDetails.srcGeoLatitude,
                      longitude:
                          viewModel.completedTripsDetails.srcGeoLongitude,
                      currentFocusNode: startReadingFocusNode,
                      nextFocusNode: endReadingFocusNode,
                      staticReading: viewModel
                          .completedTripsDetails.startReading
                          .toString()),
                  Chip(
                    label: Text(
                      'Driven: ${viewModel.getKmDiff()} kms',
                      style: AppTextStyles.lato20PrimaryShade5
                          .copyWith(fontSize: 14, color: AppColors.white),
                    ),
                    backgroundColor: AppColors.primaryColorShade5,
                  ),
                  buildMeterReadingWidget(
                    image: getImageFromBase64String(
                      base64String:
                          viewModel.completedTripsDetails.endReadingImage,
                    ),
                    readingType: ReadingType.END,
                    title: DateTimeToStringConverter.ddmmyy(
                            date: StringToDateTimeConverter.ddmmyy(
                                    date: viewModel
                                        .completedTripsDetails.creationdate)
                                .convert())
                        .convert(),
                    viewModel: viewModel,
                    widgetWidth: widgetWidth,
                    controller: endReadingController,
                    latitude: viewModel.completedTripsDetails.dstGeoLatitude,
                    longitude: viewModel.completedTripsDetails.dstGeoLongitude,
                    currentFocusNode: endReadingFocusNode,
                    staticReading:
                        viewModel.completedTripsDetails.endReading.toString(),
                  ),
                  hSizedBox(10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: buttonHeight,
                          child: AppButton(
                            borderWidth: 0,
                            borderColor: Colors.transparent,
                            onTap: () {
                              viewModel.showRejectConfirmationBottomSheet(
                                consignmentId:
                                    widget.selectedTrip.consignmentId,
                              );
                            },
                            background: AppColors.primaryColorShade5,
                            buttonText: 'Reject',
                          ),
                        ),
                      ),
                      wSizedBox(10),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: buttonHeight,
                            child: AppButton(
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              onTap: () {
                                viewModel.showConfirmationBottomSheet(
                                  entryLogRequest: EntryLog(
                                    consignmentId:
                                        widget.selectedTrip.consignmentId,
                                    routeId: widget.selectedTrip.routeId,
                                    clientId: MyPreferences()
                                        .getSelectedClient()
                                        .clientId,
                                    vehicleId: widget.selectedTrip.vehicleId,
                                    entryDate: viewModel
                                        .completedTripsDetails.entryDate,
                                    startReading: 0,
                                    endReading: viewModel.endReading,
                                    drivenKm: viewModel.getKmDiff(),
                                    fuelLtr: 0.00,
                                    fuelMeterReading: 0,
                                    ratePerLtr: 0.00,
                                    amountPaid: 0.00,
                                    trips: 1,
                                    loginTime: viewModel
                                        .completedTripsDetails.startTime,
                                    logoutTime:
                                        viewModel.completedTripsDetails.endTime,
                                    remarks: null,
                                    drivenKmGround: 0,
                                    startReadingGround: viewModel.startReading,
                                  ),
                                );
                              },
                              background: AppColors.primaryColorShade5,
                              buttonText: 'Verify',
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Card buildMeterReadingWidget({
    @required ReadingType readingType,
    @required ReviewCompletedTripsViewModel viewModel,
    @required double widgetWidth,
    @required TextEditingController controller,
    @required FocusNode currentFocusNode,
    FocusNode nextFocusNode,
    @required double latitude,
    @required double longitude,
    @required String title,
    @required String staticReading,
    @required Uint8List image,
  }) {
    return Card(
      elevation: defaultElevation,
      shape: getCardShape(),
      color: AppColors.appScaffoldColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.latoBold16Black.copyWith(
                    color: AppColors.primaryColorShade5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    launchMaps(
                      latitude: latitude,
                      longitude: longitude,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'View Location',
                      style:
                          AppTextStyles.hyperLinkStyle.copyWith(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            hSizedBox(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 3,
                  child: ProfileImageWidget(
                    size: widgetWidth,
                    imageFit: BoxFit.fill,
                    circularBorderRadius: 10,
                    image: image,
                  ),
                ),
                wSizedBox(4),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appTextFormField(
                        hintText: 'Given Reading',
                        enabled: false,
                        controller: TextEditingController(text: staticReading),
                        formatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        keyboardType: TextInputType.phone,
                      ),
                      appTextFormField(
                        hintText: 'Actual Reading',
                        enabled: true,
                        formatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: controller,
                        focusNode: currentFocusNode,
                        keyboardType: TextInputType.phone,
                        onTextChange: (String value) {
                          switch (readingType) {
                            case ReadingType.START:
                              viewModel.startReading = int.parse(value);
                              break;
                            case ReadingType.END:
                              viewModel.endReading = int.parse(value);
                              break;
                          }
                        },
                        onFieldSubmitted: (_) {
                          if (nextFocusNode != null) {
                            fieldFocusChange(
                              context,
                              currentFocusNode,
                              nextFocusNode,
                            );
                          } else {
                            currentFocusNode.unfocus();
                          }
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return textRequired;
                          } else {
                            return null;
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum ReadingType {
  START,
  END,
}
