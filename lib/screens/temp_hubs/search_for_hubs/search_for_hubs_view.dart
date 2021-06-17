import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/screens/temp_hubs/search_for_hubs/search_for_hubs_viewmodel.dart';
import 'package:bml_supervisor/screens/temp_hubs/temp_hubs_details_widget.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

class SearchForHubsView extends StatefulWidget {
  final SearchForHubsViewArguments arguments;
  const SearchForHubsView({
    Key key,
    @required this.arguments,
  }) : super(key: key);
  @override
  _SearchForHubsViewState createState() => _SearchForHubsViewState();
}

class _SearchForHubsViewState extends State<SearchForHubsView> {
  TextEditingController hubSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchForHubsViewModel>.reactive(
      onModelReady: (model) => model.gethubList(showLoading: true),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Search For Hubs',
              style: AppTextStyles().appBarTitleStyleNew,
            ),
          ),
          body: model.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : Padding(
                  padding: getSidePadding(
                    context: context,
                  ),
                  child: Column(
                    children: [
                      SearchWidget(
                        showSuffixIcon: false,
                        autoFocus: false,
                        focusNode: FocusNode(),
                        enabled: true,
                        onClearTextClicked: () {
                          model.hubsList.clear();
                          model.notifyListeners();
                          hubSearchController.clear();
                          hideKeyboard(context: context);
                        },
                        hintTitle: 'Search for Hub',
                        onTextChange: (String value) {
                          model.checkForExistingHubTitleContainsApi(value);
                        },
                        onEditingComplete: () {
                          hideKeyboard(context: context);
                          // model.checkForExistingHubTitleContainsApi(
                          //     hubSearchController.text);
                        },
                        formatter: <TextInputFormatter>[
                          TextFieldInputFormatter().alphaNumericFormatter,
                        ],
                        controller: hubSearchController,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (String value) {
                          hideKeyboard(context: context);
                          // model.checkForExistingHubTitleContainsApi(value);
                        },
                      ),
                      hSizedBox(5),
                      model.hubsList.length == 0
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryColorShade5,
                              ),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      ('SNO'),
                                      textAlign: TextAlign.left,
                                      style: AppTextStyles.whiteRegular,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      ('HUB NAME'),
                                      textAlign: TextAlign.left,
                                      style: AppTextStyles.whiteRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      model.hubsList.length == 0
                          ? Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  NoDataWidget(
                                      label: hubSearchController.text
                                                  .trim()
                                                  .length ==
                                              0
                                          ? "No Hubs"
                                          : "No Hub found with title '${hubSearchController.text}'"),
                                ],
                              ),
                            )
                          : Flexible(
                              child: LazyLoadScrollView(
                                scrollOffset: 100,
                                onEndOfPage: () {
                                  model.gethubList(showLoading: false);
                                },
                                child: ListView.builder(
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      ClickableWidget(
                                        borderRadius: getBorderRadius(),
                                        onTap: () {
                                          hideKeyboard(context: context);
                                          model.openBottomSheet(
                                              selectedHub:
                                                  model.hubsList[index]);
                                        },
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
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
                                                  model.hubsList[index].title,
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
                                  ),
                                  itemCount: model.hubsList.length,
                                ),
                              ),
                              flex: 1,
                            ),
                    ],
                  ),
                ),
        ),
        top: true,
        bottom: true,
      ),
      viewModelBuilder: () => SearchForHubsViewModel(),
    );
  }
}

class SearchForHubsViewArguments {
  final int consignmentId;

  SearchForHubsViewArguments({@required this.consignmentId});
}

class SearchForHubsViewOutpuArguments {
  final SingleTempHub selectedHub;

  SearchForHubsViewOutpuArguments({@required this.selectedHub});
}
