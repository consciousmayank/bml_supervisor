import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ArrangeHubsView extends StatefulWidget {
  final ArrangeHubsArguments args;

  ArrangeHubsView({this.args});

  @override
  _ArrangeHubsViewState createState() => _ArrangeHubsViewState();
}

class _ArrangeHubsViewState extends State<ArrangeHubsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArrangeHubsViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.selectedHubList = widget.args.newHubsList;
          viewModel.selectedSourceHubList = widget.args.newHubsList;
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Route Hub List',
                style: AppTextStyles.appBarTitleStyle,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: getSidePadding(context: context),
              child: Column(children: [

                buildSelectedHubList(viewModel: viewModel),
                // buildReturningHubList(viewModel),
                // Text('asdf'),
                buildReturnListCheckButton(viewModel),
                buildPickHubsButton(viewModel: viewModel, context: context),
              ]),
            ),
          );
        },
        viewModelBuilder: () => ArrangeHubsViewModel());
  }

  Widget buildPickHubsButton(
      {BuildContext context, ArrangeHubsViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          fontSize: 14,
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            // if (viewModel.selectedClient != null) {
            //   if (routeTitleController.text.length > 0) {
            //     viewModel
            //         .getHubsForSelectedClient(
            //         selectedClient: viewModel.selectedClient)
            //         .then((value) => viewModel.takeToPickHubsPage());
            //     // if(viewModel.hubsList.length>0) {
            //     //   viewModel.takeToPickHubsPage();
            //     // }
            //
            //     // showHubsList(context, viewModel);
            //   }
            // } else {
            //   viewModel.snackBarService
            //       .showSnackbar(message: 'Please Select Client');
            // }
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'CREATE ROUTE'),
    );
  }

  Expanded buildReturningHubList(ArrangeHubsViewModel viewModel) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return viewModel.isReturnList
                ? Row(
                    children: [
                      // Text('${index + 1}'),
                      Text(viewModel.selectedReturningHubsList[index].id
                          .toString()),
                      wSizedBox(10),
                      Expanded(
                          flex: 2,
                          child: Text(
                              '${viewModel.selectedReturningHubsList[index].title}')),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Kms',
                              hintStyle: AppTextStyles.latoMedium12Black
                                  .copyWith(color: Colors.black45)),
                          enabled: true,
                          keyboardType: TextInputType.number,
                          initialValue: '0',
                          // viewModel
                          //     .selectedReturningHubsList[index].kiloMeters
                          //     .toString(),
                          onChanged: (value) {
                            // if (value.length > 0) {
                            //   viewModel.selectedReturningHubsList[index]
                            //       .kiloMeters = int.parse(value);
                            // }
                          },
                        ),
                      ),
                    ],
                  )
                : Container();
          },
          itemCount: viewModel.selectedReturningHubsList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 0.9,
              color: AppColors.white,
            );
          },
        ),
      ),
    );
  }

  Widget buildReturnListCheckButton(ArrangeHubsViewModel viewModel) {
    return Padding(
      padding: getSidePadding(context: context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          viewModel.isReturnList ? Text('As Above') : Text('No Return List'),
          Checkbox(
            value: viewModel.isReturnList,
            onChanged: (value) {

                /// add the item to list
                // print(value);
                viewModel.isReturnList = value;
                if (value) {
                  viewModel.createReturningList(
                      list: viewModel.selectedHubList);
                } else {
                  viewModel.removeReturningList();
                  // viewModel.selectedReturningHubsList = [];
                }
                // widget.args.hubsList[index].isCheck = value;

            },
          ),
        ],
      ),
    );
    //   SwitchListTile(
    //   title: Text(viewModel.isReturnList ? 'As Above' : 'No Return List'),
    //   value: viewModel.isReturnList,
    //   onChanged: (value) {
    //     print(value);
    //     viewModel.isReturnList = value;
    //     if (value) {
    //       viewModel.createReturningList(list: widget.args.newHubsList);
    //     } else {
    //       viewModel.selectedReturningHubsList = [];
    //     }
    //   },
    // );
  }

  Widget buildSelectedHubList({ArrangeHubsViewModel viewModel}) {
    // var list = viewModel.isReturnList
    //     ? viewModel.selectedHubList
    //     : viewModel.selectedSourceHubList;

    // if(viewModel.isReturnList == true){
    //   print('check');
    // }
    // if(viewModel.isReturnList ==false){
    //   print('uncheck');
    // }
    // print(viewModel.selectedHubList.length);
    // print(widget.args.newHubsList.length);
    // print(viewModel.isReturnList);
    return Expanded(
      // height: MediaQuery.of(context).size.height/2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(viewModel.selectedHubList[index].id.toString()),
                wSizedBox(10),
                Expanded(flex: 2, child: Text('${viewModel.selectedHubList[index].title}')),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Kms',
                        hintStyle: AppTextStyles.latoMedium12Black
                            .copyWith(color: Colors.black45)),
                    enabled: index != 0,
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    // widget.args.newHubsList[index].kiloMeters.toString(),
                    onChanged: (value) {
                      // if (value.length > 0) {
                      //   viewModel.selectedHubsList[index].kiloMeters =
                      //       int.parse(value);
                      // }
                    },
                  ),
                ),
              ],
            );
          },
          itemCount: viewModel.selectedHubList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 0.9,
              color: AppColors.white,
            );
          },
        ),
      ),
    );
  }
}
