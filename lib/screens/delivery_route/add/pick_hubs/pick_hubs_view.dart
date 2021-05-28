import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/delivery_route/add/pick_hubs/pick_hubs_arguments.dart';
import 'package:bml_supervisor/screens/delivery_route/add/pick_hubs/pick_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickHubsViewModel>.reactive(
        onModelReady: (viewModel) {},
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: setAppBarTitle(title: 'Pick Hubs'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    buildCityTextFormField(viewModel: viewModel),
                    hSizedBox(10),
                    Container(
                      color: AppColors.primaryColorShade5,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // hSizedBox(5),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                ('Hub ID'),
                                textAlign: TextAlign.left,
                                style: AppTextStyles.whiteRegular,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              ('Hub Name'),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.whiteRegular,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              ('City'),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.whiteRegular,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Pick',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.whiteRegular,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return buildHubsList(
                              viewModel: viewModel,
                              index: index,
                              // state: state,
                            );
                          },
                          itemCount: widget.args.hubsList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return DottedDivider();
                          },
                        ),
                      ),
                    ),
                    buildNextButton(viewModel: viewModel, context: context),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => PickHubsViewModel());
  }

  Widget buildNextButton({BuildContext context, PickHubsViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: buttonHeight,
        child: AppButton(
            fontSize: 14,
            borderRadius: defaultBorder,
            borderColor: AppColors.primaryColorShade1,
            onTap: () {
              if (viewModel.selectedHubsList.length >= 2) {
                viewModel.takeToArrangeHubs(
                  newHubsList: viewModel.selectedHubsList,
                  srcLocation: viewModel.selectedHubsList.first.id,
                  dstLocation: viewModel.selectedHubsList.last.id,
                  title: widget.args.routeTitle,
                  remark: widget.args.remarks,
                );
              } else {
                viewModel.snackBarService
                    .showSnackbar(message: 'Please select at least 2 hubs');
              }
            },
            background: AppColors.primaryColorShade5,
            buttonText: 'NEXT'),
      ),
    );
  }

  Widget buildHubsList({PickHubsViewModel viewModel, int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.args.hubsList[index].id.toString(),
                  textAlign: TextAlign.left,
                ),
              )),
          Expanded(
              flex: 2,
              child: Text(
                widget.args.hubsList[index].title,
                textAlign: TextAlign.center,
              )),
          Expanded(
              flex: 2,
              child: Text(
                widget.args.hubsList[index].city,
                textAlign: TextAlign.center,
              )),
          Expanded(
            flex: 1,
            child: Checkbox(
              value: widget.args.hubsList[index].isCheck,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    viewModel.selectedHubsList.add(widget.args.hubsList[index]);
                    // print('selected hubs : ${viewModel.selectedHubsList.length}');
                  }
                  if (value == false) {
                    if (viewModel.selectedHubsList
                        .contains(widget.args.hubsList[index])) {
                      viewModel.selectedHubsList
                          .remove(widget.args.hubsList[index]);
                      // print('selected hubs : ${viewModel.selectedHubsList.length}');
                    }
                  }
                  widget.args.hubsList[index].isCheck = value;
                });
              },
            ),
          ),

          // CheckboxListTile(
          //   // dense: true,
          //   // isThreeLine: false,
          //   secondary:  Text(viewModel.hubsList[index].id.toString()),
          //   contentPadding: EdgeInsets.all(0),
          //   subtitle: Text(viewModel.hubsList[index].title),
          //   title: Text(viewModel.hubsList[index].city),
          //   value: viewModel.hubsList[index].isCheck,
          //   onChanged: (value) {
          //     state(() {
          //       viewModel.hubsList[index].isCheck = value;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  buildCityTextFormField({PickHubsViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel
            .getHubNameForAutoComplete(widget.args.hubsList)
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
          // hintText: "Hubs",
          inputDecoration: InputDecoration(
            hintText: 'Search for hub',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (String value) {
            if (!viewModel
                .getHubNameForAutoComplete(widget.args.hubsList)
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
