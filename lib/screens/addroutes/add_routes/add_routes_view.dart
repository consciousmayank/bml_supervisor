import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/screens/addroutes/add_routes/add_routes_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class AddRoutesView extends StatefulWidget {
  AddRoutesView();

  @override
  _AddRoutesViewState createState() => _AddRoutesViewState();
}

class _AddRoutesViewState extends State<AddRoutesView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController routeTitleController = TextEditingController();
  FocusNode routeTitleFocusNode = FocusNode();

  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocusNode = FocusNode();
  bool checkBoxCheck = false;
  double contentHeight;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddRoutesViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClients();
          viewModel.getHubsForSelectedClient(
              selectedClient: MyPreferences().getSelectedClient());
        },
        builder: (context, viewModel, child) {
          contentHeight = MediaQuery.of(context).size.height * 0.40;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Routes - ${MyPreferences().getSelectedClient().clientId}',
                style: AppTextStyles.appBarTitleStyle,
              ),
              centerTitle: true,
            ),
            body: viewModel.isBusy
                ? ShimmerContainer(
                    itemCount: 10,
                  )
                : buildStepperBody(viewModel: viewModel),
          );
        },
        viewModelBuilder: () => AddRoutesViewModel());
  }

  Widget buildStepperBody({@required AddRoutesViewModel viewModel}) {
    return Container(
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
                          buttonText: 'Previous')
                      : Container(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: buttonHeight,
                  child: onStepContinue != null
                      ? AppButton(
                          borderRadius: defaultBorder,
                          borderColor: AppColors.primaryColorShade1,
                          onTap: () {
                            hideKeyboard(context);
                            if (viewModel.currentStep == 0) {
                              if (_formKey.currentState.validate()) {
                                onStepContinue.call();
                              }
                            } else if (viewModel.currentStep == 1) {
                              if (viewModel.selectedHubsList.length == 0) {
                                viewModel.snackBarService.showSnackbar(
                                    message: 'Please select some hubs');
                              } else {
                                onStepContinue.call();
                              }
                            } else {
                              onStepContinue.call();
                            }
                          },
                          background: AppColors.primaryColorShade5,
                          buttonText: 'Next')
                      : AppButton(
                          borderRadius: defaultBorder,
                          borderColor: AppColors.primaryColorShade1,
                          onTap: () {
                            viewModel.submitRoute(
                                title: routeTitleController.text,
                                remarks: remarkController.text);
                            ;
                          },
                          background: AppColors.primaryColorShade5,
                          buttonText: 'Submit'),
                ),
              ],
            ),
          );
        },
        type: StepperType.vertical,
        physics: ScrollPhysics(),
        currentStep: viewModel.currentStep,
        // onStepTapped: (step) {
        //   viewModel.currentStep = step;
        // },
        onStepContinue:
            viewModel.currentStep < getSteps(viewModel: viewModel).length - 1
                ? () {
                    viewModel.currentStep += 1;
                  }
                : null,
        onStepCancel: viewModel.currentStep > 0
            ? () {
                viewModel.currentStep -= 1;
              }
            : null,
        steps: getSteps(viewModel: viewModel),
      ),
    );
  }

  buildCityTextFormField({AddRoutesViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel
            .getHubNameForAutoComplete(viewModel.hubsList)
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
                .getHubNameForAutoComplete(viewModel.hubsList)
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

  Widget buildRemarksTextFormField() {
    return appTextFormField(
      maxLines: 3,
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
      ],
      controller: remarkController,
      focusNode: remarkFocusNode,
      hintText: addDriverRemarksHint,
      keyboardType: TextInputType.name,
      onFieldSubmitted: (_) {
        remarkFocusNode.unfocus();
      },
    );
  }

  Widget buildRouteTitleTextFormField() {
    return appTextFormField(
      enabled: true,
      controller: routeTitleController,
      focusNode: routeTitleFocusNode,
      hintText: addRouteRouteNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, routeTitleFocusNode, remarkFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildSelectHubsButton(
      {BuildContext context, AddRoutesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            if (_formKey.currentState.validate()) {
              viewModel.takeToPickHubsPage();
            }
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Select Hub'),
    );
  }

  Widget buildCreateRouteButton(
      {@required BuildContext context,
      @required AddRoutesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            viewModel.newHubsList.forEach((element) {
              print(element.toString());
            });
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'Create Route'),
    );
  }

  Widget buildSelectedHubsList(
      {@required List<GetDistributorsResponse> selectedHubsList,
      @required AddRoutesViewModel viewModel}) {
    return Expanded(
      child: ReorderableListView(
          children: [
            for (final singleHub in selectedHubsList)
              ListTile(
                key: UniqueKey(),
                // leading: Text(selectedHubsList.indexOf(singleHub).toString()),
                leading: Text(singleHub.id.toString()),
                title: Text(singleHub.title),
                subtitle: Text("${singleHub.city}"),
                trailing: SizedBox(
                  height: double.infinity,
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Kilometers',
                        hintStyle: AppTextStyles.latoMedium12Black),
                    enabled: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              )
          ],
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final items = viewModel.newHubsList.removeAt(oldIndex);
            viewModel.newHubsList.insert(newIndex, items);
            viewModel.notifyListeners();
          }),
    );
  }

  Widget buildHubsList({AddRoutesViewModel viewModel, int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        isThreeLine: false,
        contentPadding: EdgeInsets.all(1),
        secondary: Text(
          'Id- ${viewModel.hubsList[index].id.toString()}',
        ),
        title: Text(viewModel.hubsList[index].title),
        subtitle: Text('City- ${viewModel.hubsList[index].city}'),
        value: viewModel.hubsList[index].isCheck,
        onChanged: (value) {
          if (value) {
            viewModel.selectedHubsList.add(viewModel.hubsList[index]);
          } else {
            if (viewModel.selectedHubsList
                .contains(viewModel.hubsList[index])) {
              viewModel.selectedHubsList.remove(viewModel.hubsList[index]);
            }
          }
          viewModel.hubsList[index].isCheck = value;
          // viewModel.kilometerController = List.filled(
          //     viewModel.selectedHubsList.length, TextEditingController(),
          //     growable: true);
          viewModel.notifyListeners();
        },
      ),
    );
  }

  List<Step> getSteps({@required AddRoutesViewModel viewModel}) {
    return [
      Step(
        title: Text('Enter Routes Details'),
        content: Padding(
          padding: getSidePadding(context: context),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildRouteTitleTextFormField(),
                buildRemarksTextFormField(),
              ],
            ),
          ),
        ),
        isActive: true,
        state:
            viewModel.currentStep == 0 ? StepState.editing : StepState.indexed,
      ),
      Step(
        title: new Text('Select Hubs'),
        content: Column(
          children: [
            buildCityTextFormField(viewModel: viewModel),
            SizedBox(
              height: contentHeight,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return buildHubsList(
                    viewModel: viewModel,
                    index: index,
                    // state: state,
                  );
                },
                itemCount: viewModel.hubsList.length,
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
        isActive: true,
        state:
            viewModel.currentStep == 1 ? StepState.editing : StepState.indexed,
      ),
      Step(
        title: new Text('Arrange Hubs'),
        content: SizedBox(
          height: contentHeight,
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
                final items = viewModel.selectedHubsList.removeAt(oldIndex);
                viewModel.selectedHubsList.insert(newIndex, items);
                viewModel.notifyListeners();
              }),
        ),
        isActive: true,
        state:
            viewModel.currentStep == 2 ? StepState.editing : StepState.indexed,
      ),
      Step(
        title: new Text('Enter Kilometers'),
        content: SizedBox(
            height: contentHeight,
            child: ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  // return the header
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      children: [
                        AppTextView(
                          hintText: 'Source',
                          value: viewModel.selectedHubsList.length > 0
                              ? viewModel?.selectedHubsList?.first?.title
                              : '',
                        ),
                        hSizedBox(5),
                        AppTextView(
                          hintText: 'Destination',
                          value: viewModel.selectedHubsList.length > 0
                              ? viewModel?.selectedHubsList?.last?.title
                              : '',
                        ),
                      ],
                    ),
                  );
                }
                index -= 1;

                return Row(
                  children: [
                    Text('${index + 1}'),
                    wSizedBox(10),
                    Expanded(
                        flex: 2,
                        child:
                            Text('${viewModel.selectedHubsList[index].title}')),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Kms',
                            hintStyle: AppTextStyles.latoMedium12Black
                                .copyWith(color: Colors.black45)),
                        enabled: index != 0,
                        keyboardType: TextInputType.number,
                        initialValue: viewModel
                            .selectedHubsList[index].kiloMeters
                            .toString(),
                        onChanged: (value) {
                          if (value.length > 0) {
                            viewModel.selectedHubsList[index].kiloMeters =
                                int.parse(value);
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
              itemCount: viewModel.selectedHubsList.length + 1,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 1,
                  color: AppColors.primaryColorShade5,
                );
              },
            )),
        isActive: true,
        state:
            viewModel.currentStep == 3 ? StepState.editing : StepState.indexed,
      ),
      Step(
        title: new Text('Create Return List'),
        content: Column(
          children: [
            SizedBox(
                height: viewModel.selectedReturningHubsList.length > 0
                    ? contentHeight
                    : 100,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // return the header
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Column(
                          children: [
                            SwitchListTile(
                                title: Text(viewModel.isReturnList
                                    ? 'As Above'
                                    : 'No Return List'),
                                value: viewModel.isReturnList,
                                onChanged: (value) {
                                  viewModel.isReturnList = value;
                                  if (value) {
                                    viewModel.createReturningList();
                                  } else {
                                    viewModel.selectedReturningHubsList = [];
                                  }
                                }),
                          ],
                        ),
                      );
                    }
                    index -= 1;

                    return viewModel.isReturnList
                        ? Row(
                            children: [
                              Text('${index + 1}'),
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
                                  initialValue: viewModel
                                      .selectedReturningHubsList[index]
                                      .kiloMeters
                                      .toString(),
                                  onChanged: (value) {
                                    if (value.length > 0) {
                                      viewModel.selectedReturningHubsList[index]
                                          .kiloMeters = int.parse(value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container();
                  },
                  itemCount: viewModel.selectedReturningHubsList.length + 1,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                      color: AppColors.primaryColorShade5,
                    );
                  },
                )),
          ],
        ),
        isActive: true,
        state:
            viewModel.currentStep == 4 ? StepState.editing : StepState.indexed,
      ),
    ];
  }
}
