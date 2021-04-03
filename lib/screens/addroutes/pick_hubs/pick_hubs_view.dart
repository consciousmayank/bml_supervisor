import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/pick_hubs/pick_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
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
      onModelReady: (viewModel){
        print('pick hubs onModelReady');
        print(widget.args.routeTitle);
        print(widget.args.remarks);
      },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Pick Hubs',
                  style: AppTextStyles.appBarTitleStyle,
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  // buildCityTextFormField(viewModel: viewModel),
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
                      itemCount: widget.args.hubsList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,
                          color: AppColors.primaryColorShade3,
                        );
                      },
                    ),
                  ),
                  buildNextButton(viewModel: viewModel, context: context),
                ],
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
              /// go back with the newly populated list
              viewModel.newHubsList.forEach((element) {
                print(element.title);
              });
              // viewModel.takeToAddRoutesPage(viewModel.newHubsList);
              viewModel.takeToArrangeHubs(
                newHubsList: viewModel.newHubsList,
                srcLocation: viewModel.newHubsList.first.id,
                dstLocation: viewModel.newHubsList.last.id,
                title: widget.args.routeTitle,
                remark: widget.args.remarks,
              );
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
          Text(widget.args.hubsList[index].id.toString()),
          Text(widget.args.hubsList[index].title),
          Text(widget.args.hubsList[index].city),
          Checkbox(
            value: widget.args.hubsList[index].isCheck,
            onChanged: (value) {
              setState(() {
                /// add the item to list
                print(value);
                if (value == true) {
                  viewModel.newHubsList.add(widget.args.hubsList[index]);
                }
                if (value == false) {
                  if (viewModel.newHubsList
                      .contains(widget.args.hubsList[index])) {
                    viewModel.newHubsList.remove(widget.args.hubsList[index]);
                  }
                }
                widget.args.hubsList[index].isCheck = value;
              });
            },
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
            hintText: 'Select Hubs',
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
