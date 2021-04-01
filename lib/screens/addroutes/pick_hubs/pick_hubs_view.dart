import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PickHubsView extends StatefulWidget {
  final PickHubsArguments args;

  PickHubsView({@required this.args});

  @override
  _PickHubsViewState createState() => _PickHubsViewState();
}

class _PickHubsViewState extends State<PickHubsView> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController routeTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickHubsViewModel>.reactive(
        onModelReady: (viewModel) =>
            viewModel.setCompleteHubList(widget.args.hubsList),
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Hubs',
                  style: AppTextStyles.appBarTitleStyle,
                ),
                centerTitle: true,
              ),
              // body: buildBody(viewModel, context),
              body: buildStepperBody(viewModel: viewModel),
            ),
        viewModelBuilder: () => PickHubsViewModel());
  }

  Widget buildStepperBody({@required PickHubsViewModel viewModel}) {
    return Column(
      children: [
        Expanded(
          child: Stepper(
            controlsBuilder: (context, {onStepCancel, onStepContinue}) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: buttonHeight,
                      width: MediaQuery.of(context).size.width / 3,
                      child: onStepCancel != null
                          ? AppButton(
                              borderRadius: defaultBorder,
                              borderColor: AppColors.primaryColorShade1,
                              onTap: () {
                                onStepCancel.call();
                              },
                              background: AppColors.primaryColorShade5,
                              buttonText: 'Cancel')
                          : AppButton(
                              borderRadius: defaultBorder,
                              borderColor: AppColors.primaryColorShade1,
                              onTap: () {
                                viewModel.navigationService.back();
                              },
                              background: AppColors.primaryColorShade5,
                              buttonText: 'Back'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: buttonHeight,
                      child: onStepContinue != null
                          ? AppButton(
                              borderRadius: defaultBorder,
                              borderColor: AppColors.primaryColorShade1,
                              onTap: () {
                                onStepContinue.call();
                              },
                              background: AppColors.primaryColorShade5,
                              buttonText: 'Next')
                          : Container(),
                    ),
                  ],
                ),
              );
            },
            type: StepperType.vertical,
            physics: ScrollPhysics(),
            currentStep: viewModel.currentStep,
            onStepTapped: (step) {
              viewModel.currentStep = step;
            },
            onStepContinue: viewModel.currentStep < 2
                ? () {
                    viewModel.currentStep += 1;
                  }
                : null,
            onStepCancel: viewModel.currentStep > 0
                ? () {
                    viewModel.currentStep -= 1;
                  }
                : null,
            steps: <Step>[
              Step(title: Text('Details'), content: Container()),
              Step(
                title: new Text('Select'),
                content: Column(
                  children:

                      // List.generate(
                      //   viewModel.completeHubsList.length + 1,
                      //   (index) => buildHubsList(
                      //           viewModel: viewModel,
                      //           index: index,
                      //           // state: state,
                      //         ),
                      // ).toList(),

                      [
                    buildCityTextFormField(viewModel: viewModel),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return buildHubsList(
                            viewModel: viewModel,
                            index: index,
                            // state: state,
                          );
                        },
                        itemCount: viewModel.completeHubsList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            thickness: 1,
                            color: AppColors.primaryColorShade5,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                isActive: viewModel.currentStep >= 0,
                state: viewModel.currentStep >= 0
                    ? StepState.complete
                    : StepState.disabled,
              ),
              Step(
                title: new Text('Arrange'),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ReorderableListView(
                      children: [
                        for (final singleHub in viewModel.selectedHubsList)
                          ListTile(
                            key: UniqueKey(),
                            // leading: Text(selectedHubsList.indexOf(singleHub).toString()),
                            leading: Text(singleHub.id.toString()),
                            title: Text(singleHub.title),
                            subtitle: Text("${singleHub.city}"),
                          )
                      ],
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final items =
                            viewModel.selectedHubsList.removeAt(oldIndex);
                        viewModel.selectedHubsList.insert(newIndex, items);
                        viewModel.notifyListeners();
                      }),
                ),
                isActive: viewModel.currentStep >= 0,
                state: viewModel.currentStep >= 1
                    ? StepState.complete
                    : StepState.disabled,
              ),
              Step(
                title: new Text('Kilometers'),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        AppTiles(
                            title: 'Source',
                            value: viewModel.selectedHubsList.length > 0
                                ? viewModel?.selectedHubsList?.first?.title
                                : '',
                            iconName: bmlIcon),
                        AppTiles(
                            title: 'Destination',
                            value: viewModel.selectedHubsList.length > 0
                                ? viewModel?.selectedHubsList?.last?.title
                                : '',
                            iconName: bmlIcon),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text('${index + 1}'),
                                  wSizedBox(10),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          '${viewModel.selectedHubsList[index].title}')),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: 'Kms',
                                          hintStyle: AppTextStyles
                                              .latoMedium12Black
                                              .copyWith(color: Colors.black45)),
                                      enabled: true,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: viewModel.selectedHubsList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                thickness: 1,
                                color: AppColors.primaryColorShade5,
                              );
                            },
                          ),
                        ),
                      ],
                    )),
                isActive: viewModel.currentStep >= 0,
                state: viewModel.currentStep >= 2
                    ? StepState.complete
                    : StepState.disabled,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildBody(PickHubsViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        buildCityTextFormField(viewModel: viewModel),
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              return buildHubsList(
                viewModel: viewModel,
                index: index,
                // state: state,
              );
            },
            itemCount: viewModel.completeHubsList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
                color: AppColors.primaryColorShade5,
              );
            },
          ),
        ),
        buildDoneButton(viewModel: viewModel, context: context),
      ],
    );
  }

  Widget buildDoneButton({BuildContext context, PickHubsViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: buttonHeight,
        child: AppButton(
            borderRadius: defaultBorder,
            borderColor: AppColors.primaryColorShade1,
            onTap: () {
              /// go back with the newly populated list
              viewModel.takeToAddRoutesPage(viewModel.selectedHubsList);
            },
            background: AppColors.primaryColorShade5,
            buttonText: 'ADD HUBS'),
      ),
    );
  }

  Widget buildHubsList({PickHubsViewModel viewModel, int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        isThreeLine: false,
        contentPadding: EdgeInsets.all(1),
        secondary: Text(
          'Id- ${viewModel.completeHubsList[index].id.toString()}',
        ),
        title: Text(viewModel.completeHubsList[index].title),
        subtitle: Text('City- ${viewModel.completeHubsList[index].city}'),
        value: viewModel.completeHubsList[index].isCheck,
        onChanged: (value) {
          if (value) {
            viewModel.selectedHubsList.add(viewModel.completeHubsList[index]);
          } else {
            if (viewModel.selectedHubsList
                .contains(viewModel.completeHubsList[index])) {
              viewModel.selectedHubsList
                  .remove(viewModel.completeHubsList[index]);
            }
          }
          viewModel.completeHubsList[index].isCheck = value;
          viewModel.kilometerController = List.filled(
              viewModel.selectedHubsList.length, TextEditingController(),
              growable: true);
          viewModel.notifyListeners();
        },
      ),
    );
  }

  buildCityTextFormField({PickHubsViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel
            .getHubNameForAutoComplete(viewModel.completeHubsList)
            .where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        }).toList();
      },
      onSelected: (String selection) {
        /// Add the selected Item into the list

        // CitiesResponse temp;
        // viewModel.cityList.forEach((element) {
        //   if (element.city == selection) {
        //     temp = element;
        //   }
        // });
        // viewModel.selectedCity = temp;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return appTextFormField(
          hintText: "City",
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (String value) {
            if (!viewModel
                .getHubNameForAutoComplete(viewModel.completeHubsList)
                .contains(value)) {
              return 'Nothing selected.';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: options
                    .map((String option) => GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
