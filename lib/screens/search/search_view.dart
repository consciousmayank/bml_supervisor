import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/screens/search/search_viewmodel.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatefulWidget {
  final bool showVehicleDetails;

  SearchView({@required this.showVehicleDetails});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        body: SafeArea(
          left: false,
          right: false,
          child: Stack(
            children: [
              Padding(
                padding: getSidePadding(context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getValueForScreenType(
                        context: context,
                        mobile: Padding(
                          padding: const EdgeInsets.only(
                            top: 50,
                            left: 8,
                          ),
                          child: headerText("Search Vehicle"),
                        ),
                        tablet: headerText("Search Vehicle"),
                        desktop: headerText("Search Vehicle")),
                    ScreenTypeLayout.builder(
                      mobile: (BuildContext context) =>
                          mobileViewHeader(viewModel: viewModel),
                      tablet: (BuildContext context) => tabletViewHeader(
                          viewModel: viewModel, context: context),
                      desktop: (BuildContext context) => tabletViewHeader(
                          viewModel: viewModel, context: context),
                    ),
                    Expanded(
                      child: viewModel.isBusy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : viewModel.searchResponse.length == 0
                              ? emptySearchView()
                              : searchResults(context, viewModel),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 36,
                  ),
                  onPressed: () => viewModel.navigationService.back(),
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SearchViewModel(),
    );
  }

  void search(BuildContext context, SearchViewModel viewModel, String text) {
    if (text != null && text.length > 0) {
      viewModel.search(text);
    }
  }

  searchResults(BuildContext context, SearchViewModel viewModel) {
    return ListView.builder(
        // gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: getValueForScreenType(
        //       context: context, mobile: 1, tablet: 2, desktop: 3),
        // ),
        itemBuilder: (context, index) => InkWell(
            onTap: () {
              if (widget.showVehicleDetails) {
                viewModel.selectedVehicle = viewModel.searchResponse[index];
                searchFocusNode.unfocus();
              } else {
                viewModel.returnResult(viewModel.searchResponse[index]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: getBorderRadius(),
                child: Card(
                  elevation: 4,
                  shape: getCardShape(),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeConfiguration.primaryBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                        ),
                        height: 50.0,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Registration Number",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              viewModel
                                  .searchResponse[index].registrationNumber,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text("Owner Name : "),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(viewModel
                                      .searchResponse[index].ownerName),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text("Model : "),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      viewModel.searchResponse[index].make),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text("Fuel Type : "),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      viewModel.searchResponse[index].fuelType),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )

            // Card(
            //   child: Container(
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           Row(
            //             children: [
            //               Expanded(
            //                 flex: 1,
            //                 child: Text(viewModel
            //                     .searchResponse[index].registrationNumber),
            //               ),
            //               Expanded(
            //                 flex: 1,
            //                 child: Text(
            //                     viewModel.searchResponse[index].ownerName),
            //               ),
            //               Expanded(
            //                 flex: 2,
            //                 child:
            //                     Text(viewModel.searchResponse[index].model),
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            ),
        itemCount: viewModel.searchResponse.length);
  }

  emptySearchView() {
    return Container();
  }

  showUi({
    String label,
    String value,
  }) {
    return value == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: singleColumnColored(
                  label: label, value: value, showColor: false),
            ),
          );
  }

  Widget mobileViewHeader({SearchViewModel viewModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        searchParams(viewModel: viewModel),
        hSizedBox(20),
        searchInput(viewModel: viewModel),
        hSizedBox(20),
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            searchButton(viewModel: viewModel),
          ],
        )),
      ],
    );
  }

  Widget tabletViewHeader({SearchViewModel viewModel, BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex: 1, child: searchParams(viewModel: viewModel)),
          wSizedBox(20),
          Expanded(flex: 1, child: searchInput(viewModel: viewModel)),
          wSizedBox(20),
          Expanded(flex: 1, child: searchButton(viewModel: viewModel)),
        ],
      ),
    );
  }

  Widget searchParams({SearchViewModel viewModel}) {
    return AppDropDown(
      optionList: searchApiParams,
      hint: "By",
      onOptionSelect: (selectedValue) => viewModel.searchParam = selectedValue,
      selectedValue:
          viewModel.searchParam.length == 0 ? null : viewModel.searchParam,
    );
  }

  Widget searchButton({SearchViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ElevatedButton(
          child: Text("Find"),
          onPressed: () {
            searchFocusNode.unfocus();
            if (viewModel.searchParam.length == 0) {
              viewModel.showSnackBarError("Please select a search params");
            } else if (!_formKey.currentState.validate()) {
              viewModel.snackBarService.showSnackbar(
                message: "Cannot Left ",
                title: "Error!",
              );
            } else {
              search(context, viewModel, searchController.text);
            }
          },
        ),
      ),
    );
  }

  Widget searchInput({SearchViewModel viewModel}) {
    return Form(
      key: _formKey,
      child: appTextFormField(
        focusNode: searchFocusNode,
        hintText: "Enter Value",
        // onChanged: (String value) {
        //   if (value.isEmpty) {
        //     viewModel.searchResponse.clear();
        //     viewModel.notifyListeners();
        //   } else {
        //     search(context, viewModel, value);
        //   }
        // },
        validator: (value) {
          if (value.isEmpty) {
            return textRequired;
          } else {
            return null;
          }
        },
        onFieldSubmitted: (_) {
          searchFocusNode.unfocus();
          search(context, viewModel, searchController.text);
        },
        controller: searchController,
      ),
    );
  }
}
