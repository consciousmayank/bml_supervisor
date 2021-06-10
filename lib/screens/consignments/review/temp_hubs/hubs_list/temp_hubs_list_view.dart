import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/hubs_list/temp_hubs_list_args.dart';
import 'package:bml_supervisor/screens/consignments/review/temp_hubs/hubs_list/temp_hubs_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TempHubsListView extends StatefulWidget {
  final TempHubsListArguments arguments;
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
                  Flexible(
                    flex: 1,
                    child: model.hubsList.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                model.hubsList[index].title,
                              ),
                              subtitle: Text(model.hubsList[index].city),
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
                      onTap: model.hubsList.length > 0 ? () {} : null,
                      borderRadius: getBorderRadius(),
                      childColor: model.hubsList.length > 0
                          ? AppColors.primaryColorShade5
                          : AppColors.primaryColorShade5.withAlpha(185),
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
