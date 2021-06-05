import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/screens/hub/view/hubs_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            title: setAppBarTitle(title: 'Hub List'),
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
          Padding(
            padding: const EdgeInsets.only(
              bottom: 4,
              top: 2,
            ),
            child: CreateNewButtonWidget(
                title: 'Add New Hub',
                onTap: () {
                  widget.viewModel.onAddHubClicked();
                }),
          ),
          // addHubView(
          //   iconName: addIcon,
          //   text: "Add New Hub",
          //   onTap: () {
          //     widget.viewModel.onAddHubClicked();
          //   },
          // ),
          hSizedBox(5),
          widget.viewModel.hubsList.length ==0?NoDataWidget(label: 'No hubs yet'):
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Hubs List',
              style: AppTextStyles.latoBold14primaryColorShade6,
            ),
          ),
          widget.viewModel.hubsList.length ==0?Container():
          SearchWidget(
            onClearTextClicked: () {

              hideKeyboard(context: context);
            },
            hintTitle: 'Search for hub',
            onTextChange: (String value) {
              // viewModel.selectedVehicleId = value;
              // viewModel.notifyListeners();
            },
            onEditingComplete: () {

            },
            formatter: <TextInputFormatter>[
              TextFieldInputFormatter().alphaNumericFormatter,
            ],
            controller: TextEditingController(),
            // focusNode: selectedRegNoFocusNode,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (String value) {

            },
          ),
          // buildSearchDriverTextFormField(viewModel: widget.viewModel),
          hSizedBox(8),
          widget.viewModel.hubsList.length ==0?Container():
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColorShade5,
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(defaultBorder),
              //   topRight: Radius.circular(defaultBorder),
              // ),
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
          widget.viewModel.hubsList.length ==0?Container():
          Expanded(
            child: LazyLoadScrollView(
                scrollOffset: 300,
                onEndOfPage: () {
                  widget.viewModel.gethubList(showLoading: false);
                },
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
                                    widget.viewModel.hubsList[index].title,
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
                  itemCount: widget.viewModel.hubsList.length,
                )),
          ),
        ],
      ),
    );
  }

  buildSearchDriverTextFormField({HubsListViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel
            .getVehicleNumberForAutoComplete(viewModel.hubsList)
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
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.drawerIconsBackgroundColor,
                  borderRadius: getBorderRadius(),
                ),
                child: Center(
                  child: Image.asset(
                    searchBlueIcon,
                    height: 20,
                    width: 20,
                    // color: AppColors.primaryColorShade5,
                  ),
                ),
              ),
            ),
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
                .getVehicleNumberForAutoComplete(viewModel.hubsList)
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

  Widget addHubView({String text, String iconName, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: SizedBox(
        height: 55,
        child: ClickableWidget(
          childColor: AppColors.white,
          borderRadius: getBorderRadius(),
          onTap: () {
            onTap.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      iconName == null
                          ? Container()
                          : Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: IconBlueBackground(
                          iconName: iconName,
                        ),
                      ),
                      iconName == null ? Container() : wSizedBox(20),
                      Expanded(
                        child: Text(
                          text,
                          style: AppTextStyles.latoMedium12Black.copyWith(
                              color: AppColors.primaryColorShade5,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    forwardArrowIcon,
                    height: 10,
                    width: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
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
