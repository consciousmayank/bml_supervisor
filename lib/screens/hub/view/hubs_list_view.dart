import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/hub/view/hubs_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
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
              "All Hubs",
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColorShade5,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultBorder),
                topRight: Radius.circular(defaultBorder),
              ),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    ('S No.'),
                    textAlign: TextAlign.left,
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    ('Hub Name'),
                    textAlign: TextAlign.left,
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LazyLoadScrollView(
                scrollOffset: 300,
                onEndOfPage: () {},
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ClickableWidget(
                          borderRadius: getBorderRadius(),
                          onTap: () {
                            widget.viewModel.openDriverDetailsBottomSheet(
                                selectedDriverIndex: index);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${index + 1}',
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 1,
                                ),
                                wSizedBox(10),
                                Expanded(
                                  child: Text(
                                    widget.viewModel.hubList[index].title,
                                    textAlign: TextAlign.left,
                                  ),
                                  flex: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                        DottedDivider()
                      ],
                    );
                  },
                  itemCount: widget.viewModel.hubList.length,
                )),
          ),
        ],
      ),
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
