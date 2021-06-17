import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/screens/temp_hubs/hubs_list/temp_hubs_list_args.dart';
import 'package:bml_supervisor/screens/temp_hubs/hubs_list/temp_hubs_list_viewmodel.dart';
import 'package:bml_supervisor/screens/temp_hubs/temp_hubs_details_widget.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';

class TempHubsListView extends StatefulWidget {
  final TempHubsListInputArguments arguments;
  const TempHubsListView({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  _TempHubsListViewState createState() => _TempHubsListViewState();
}

class _TempHubsListViewState extends State<TempHubsListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TempHubsListViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: WillPopScope(
          onWillPop: () {
            model.navigationService.back(result: false);
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Hubs for C#${widget.arguments.reviewedConsigId}',
                style: AppTextStyles().appBarTitleStyleNew,
              ),
            ),
            body: Padding(
              padding: getSidePadding(context: context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4,
                      top: 2,
                    ),
                    child: CreateNewButtonWidget(
                        title: 'Add New Hub',
                        onTap: () {
                          model.onAddHubClicked(
                            reviewedConsigId: widget.arguments.reviewedConsigId,
                          );
                        }),
                  ),
                  hSizedBox(5),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Hubs List',
                      style: AppTextStyles.latoBold14primaryColorShade6,
                    ),
                  ),
                  SearchWidget.buttonLike(
                    searchIcon: addIcon,
                    hintTitle: 'Select Hub',
                    controller: TextEditingController(),
                    onTap: () {
                      model.onSearchForHubClicked(
                        reviewedConsigId: widget.arguments.reviewedConsigId,
                      );
                    },
                  ),
                  hSizedBox(5),
                  if (model.hubsList.length > 0)
                    Container(
                      decoration:
                          BoxDecoration(color: AppColors.primaryColorShade5),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                'Hub Title',
                                style: AppTextStyles().appBarTitleStyleNew,
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(
                              'Collect',
                              style: AppTextStyles().appBarTitleStyleNew,
                              textAlign: TextAlign.center,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                              'Drop',
                              style: AppTextStyles().appBarTitleStyleNew,
                              textAlign: TextAlign.center,
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  Flexible(
                    flex: 1,
                    child: model.hubsList.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) => Column(
                              children: [
                                Slidable(
                                  key: Key(index.toString()),
                                  direction: Axis.horizontal,
                                  actionPane: SlidableBehindActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: Container(
                                    color: AppColors.appScaffoldColor,
                                    child: TempHubsDetailsView(
                                      singleHub: model.hubsList[index],
                                    ),
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        model.hubsList.removeAt(index);
                                        model.notifyListeners();
                                      },
                                    ),
                                  ],
                                ),
                                DottedDivider()
                              ],
                            ),
                            itemCount: model.hubsList.length,
                          )
                        : Center(
                            child: Text('No Hubs'),
                          ),
                  ),
                  SizedBox(
                    height: buttonHeight,
                    width: double.infinity,
                    child: ClickableWidget(
                      child: Center(
                          child: Text(
                        'Submit',
                        style: AppTextStyles().appBarTitleStyleNew,
                      )),
                      onTap: () {
                        if (model.hubsList.length == 0) {
                          model.showConfirmationBottomSheet();
                        } else {
                          model.addTrasientHubs();
                        }
                      },
                      borderRadius: getBorderRadius(),
                      childColor: AppColors.primaryColorShade5,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        top: true,
        bottom: true,
      ),
      viewModelBuilder: () => TempHubsListViewModel(),
    );
  }
}
