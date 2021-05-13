import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_driver.dart';
import 'package:bml_supervisor/models/cities_response.dart';
import 'package:bml_supervisor/screens/driver/add/add_driver_viewmodel.dart';
import 'package:bml_supervisor/screens/driver/view/drivers_list_viewmodel.dart';
import 'package:bml_supervisor/screens/pickimage/pick_image_view.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:bml_supervisor/widget/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DriversListView extends StatefulWidget {
  @override
  _DriversListViewState createState() => _DriversListViewState();
}

class _DriversListViewState extends State<DriversListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DriversListViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getDriversList(showLoading: true),
      builder: (context, viewModel, child) => SafeArea(
        left: false,
        right: false,
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "All Drivers",
              style: AppTextStyles.appBarTitleStyle,
            ),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : AddDriverBodyWidget(
                  viewModel: viewModel,
                ),
        ),
      ),
      viewModelBuilder: () => DriversListViewModel(),
    );
  }
}

class AddDriverBodyWidget extends StatefulWidget {
  final DriversListViewModel viewModel;

  const AddDriverBodyWidget({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _AddDriverBodyWidgetState createState() => _AddDriverBodyWidgetState();
}

class _AddDriverBodyWidgetState extends State<AddDriverBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: LazyLoadScrollView(
          scrollOffset: 300,
          onEndOfPage: () =>
              widget.viewModel.getDriversList(showLoading: false),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                shape: getCardShape(),
                margin: getSidePadding(context: context),
                child: InkWell(
                  onTap: () {
                    widget.viewModel.openDriverDetailsBottomSheet(
                      selectedDriverIndex: index,
                    );
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfileImageWidget(
                          image: widget.viewModel.driversList[index].photo !=
                                      null &&
                                  widget.viewModel.driversList[index].photo
                                          .length ==
                                      0
                              ? null
                              : getImageFromBase64String(
                                  base64String:
                                      widget.viewModel.driversList[index].photo,
                                ),
                          circularBorderRadius: defaultBorder,
                        ),
                      ),
                      wSizedBox(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '${widget.viewModel.driversList[index].salutation} ${widget.viewModel.driversList[index].firstName} ${widget.viewModel.driversList[index].lastName}',
                              style: AppTextStyles.lato20PrimaryShade5.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            hSizedBox(5),
                            InkWell(
                              onTap: () {
                                launch(
                                    "tel://+91-${widget.viewModel.driversList[index].mobile.trim()}");
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    phoneNumber,
                                    height: 10,
                                    width: 10,
                                    // color: AppColors.primaryColorShade5,
                                  ),
                                  wSizedBox(10),
                                  Text(
                                      '+91-${widget.viewModel.driversList[index].mobile.trim()}'),
                                ],
                              ),
                            ),
                            hSizedBox(10),
                            rightAlignedText(
                              text: getExperience(widget.viewModel
                                  .driversList[index].workExperienceYr),
                            ),
                            hSizedBox(5),
                            rightAlignedText(
                              text: widget
                                  .viewModel.driversList[index].vehicleId
                                  .toUpperCase(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.viewModel.driversList.length,
          )),
    );
  }

  Container rightAlignedText({@required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        textAlign: TextAlign.end,
      ),
    );
  }

  String getExperience(int workExperienceYr) {
    if (workExperienceYr > 1) {
      return '$workExperienceYr Years Experience';
    } else {
      return '$workExperienceYr Year Experience';
    }
  }
}
