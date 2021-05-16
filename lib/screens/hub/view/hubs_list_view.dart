import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/hub/view/hubs_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

class HubsListView extends StatefulWidget {
  @override
  _HubsListViewState createState() => _HubsListViewState();
}

class _HubsListViewState extends State<HubsListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HubsListViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.gethubList(showLoading: true),
      builder: (context, viewModel, child) => SafeArea(
        left: false,
        right: false,
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "All Vehicles",
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
      viewModelBuilder: () => HubsListViewModel(),
    );
  }
}

class AddDriverBodyWidget extends StatefulWidget {
  final HubsListViewModel viewModel;

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
          onEndOfPage: () {},
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                shape: getCardShape(),
                margin: getSidePadding(context: context),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      HubsListTextView(
                        label: 'Hub Title',
                        value: widget.viewModel.hubList[index].title,
                      ),
                      HubsListTextView(
                        label: 'Contact Person',
                        value: widget.viewModel.hubList[index].contactPerson,
                      ),
                      HubsListTextView(
                        label: 'Email Id',
                        value: widget.viewModel.hubList[index].email,
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: HubsListTextView(
                                label: 'Mobile',
                                value: widget.viewModel.hubList[index].mobile,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: HubsListTextView(
                                // labelFontSize: helper.labelFontSize,
                                // valueFontSize: helper.valueFontSize,
                                label: 'Mobile (Alternate)',
                                value: widget.viewModel.hubList[index].phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchMaps(
                              latitude:
                                  widget.viewModel.hubList[index].geoLatitude,
                              longitude:
                                  widget.viewModel.hubList[index].geoLongitude);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.appScaffoldColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultBorder)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Address",
                                style: AppTextStyles.underLinedText,
                              ),
                              hSizedBox(20),
                              widget.viewModel.hubList[index].street != null &&
                                      widget.viewModel.hubList[index].street !=
                                          'NA'
                                  ? Text(
                                      widget.viewModel.hubList[index].street,
                                      style: AppTextStyles.lato20PrimaryShade5
                                          .copyWith(
                                        fontSize: 14,
                                      ),
                                    )
                                  : Container(),
                              widget.viewModel.hubList[index].locality !=
                                          null &&
                                      widget.viewModel.hubList[index]
                                              .locality !=
                                          'NA'
                                  ? Text(
                                      widget.viewModel.hubList[index].locality,
                                      style: AppTextStyles.lato20PrimaryShade5
                                          .copyWith(
                                        fontSize: 14,
                                      ),
                                    )
                                  : Container(),
                              widget.viewModel.hubList[index].landmark !=
                                          null &&
                                      widget.viewModel.hubList[index]
                                              .landmark !=
                                          'NA'
                                  ? Text(
                                      'Landmark : ' +
                                          widget.viewModel.hubList[index]
                                              .landmark,
                                      style: AppTextStyles.lato20PrimaryShade5
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                '${widget.viewModel.hubList[index].city}, ${widget.viewModel.hubList[index].pincode}, ${widget.viewModel.hubList[index].state}',
                                style:
                                    AppTextStyles.lato20PrimaryShade5.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${widget.viewModel.hubList[index].country}',
                                style:
                                    AppTextStyles.lato20PrimaryShade5.copyWith(
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
              );
            },
            itemCount: widget.viewModel.hubList.length,
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
