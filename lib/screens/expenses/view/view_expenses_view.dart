// Added by Vikas
// Subject to change

import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/select_duration_tab.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

class ViewExpensesView extends StatefulWidget {
  @override
  _ViewExpensesViewState createState() => _ViewExpensesViewState();
}

class _ViewExpensesViewState extends State<ViewExpensesView> {
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();
  TextEditingController selectedDateController = TextEditingController();
  final FocusNode selectedDateFocusNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewExpensesViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.getClients();
        getExpenses(
            viewModel: viewModel,
            registrationNumber: selectedRegNoController.text);
      },
      builder: (context, viewModel, child) {
        _scrollController.addListener(() {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            viewModel.hideFloatingActionButton();
          }
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            viewModel.showFloatingActionButton();
          }
        });
        return Scaffold(
          floatingActionButton: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: viewModel.isFloatingActionButtonVisible ? 1.0 : 0.0,
            child: FloatingActionButton(
              onPressed: () {
                viewModel.navigationService
                    .navigateTo(addExpensesPageRoute)
                    .then(
                      (value) => getExpenses(
                          viewModel: viewModel,
                          registrationNumber: selectedRegNoController.text),
                    );
              },
              child: Icon(Icons.add),
            ),
          ),
          appBar: AppBar(
            title: Text(
                'View Expenses - ${MyPreferences().getSelectedClient().clientId}',
                style: AppTextStyles.appBarTitleStyle),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 7,
                )
              : Padding(
                  padding: getSidePadding(context: context),
                  child: Column(
                    children: [
                      buildSelectDurationTabWidget(viewModel),
                      registrationSelector(
                          context: context, viewModel: viewModel),
                      viewModel.viewExpensesResponse.length > 0
                          ? Expanded(
                              child: searchResults(viewModel: viewModel),
                            )
                          : Container()
                    ],
                  ),
                ),
        );
      },
      viewModelBuilder: () => ViewExpensesViewModel(),
    );
  }

  Widget selectDuration({ViewExpensesViewModel viewModel}) {
    return AppDropDown(
      optionList: selectDurationList,
      hint: "Select Duration",
      onOptionSelect: (selectedValue) {
        viewModel.selectedDuration = selectedValue;
        print(viewModel.selectedDuration);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
    );
  }

  Widget registrationSelector(
      {BuildContext context, ViewExpensesViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
      ],
    );
  }

  Widget registrationNumberTextField(ViewExpensesViewModel viewModel) {
    return appTextFormField(
      enabled: true,
      controller: selectedRegNoController,
      onFieldSubmitted: (String value) {
        getExpenses(viewModel: viewModel, registrationNumber: value);
      },
      hintText: drRegNoHint,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget getExpenseListButton({ViewExpensesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ElevatedButton(
          child: Text("Get Expenses List"),
          onPressed: () {
            if (viewModel.selectedDuration.length != 0) {
              viewModel.getExpensesList(
                regNum: selectedRegNoController.text.trim().toUpperCase(),
                selectedDuration: viewModel.selectedDuration,
                clientId: viewModel.selectedClient != null
                    ? viewModel.selectedClient.clientId
                    : '',
              );
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please select Duration');
            }
          },
        ),
      ),
    );
  }

  SelectDurationTabWidget buildSelectDurationTabWidget(
      ViewExpensesViewModel viewModel) {
    return SelectDurationTabWidget(
      initiallySelectedDuration: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
      onTabSelected: (String selectedValue) {
        viewModel.selectedDuration = selectedValue;
        getExpenses(
            viewModel: viewModel,
            registrationNumber: selectedRegNoController.text);
      },
      title: selectDurationTabWidgetTitle,
    );
  }

  void getExpenses(
      {ViewExpensesViewModel viewModel, String registrationNumber}) {
    viewModel.getExpensesList(
      regNum: registrationNumber,
      selectedDuration: viewModel.selectedDuration,
      clientId: viewModel.selectedClient.clientId,
    );
  }

  searchResults({@required ViewExpensesViewModel viewModel}) {
    return Scrollbar(
      // isAlwaysShown: true,
      child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            // ! Below code is imp, helps to show custom header in a ListView
            if (index == 0) {
              // return the header chip
              return _buildHeader(viewModel: viewModel);
            }
            index -= 1;

            return InkWell(
                onTap: () {
                  // showViewEntryDetailPreview(
                  //     context, vehicleEntrySearchResponse[index]);
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
                                  viewModel
                                      .viewExpensesResponse[index].vehicleId,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  viewModel.viewExpensesResponse[index].eDate
                                      .toString(),
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
                                      child: AppTextView(
                                        textAlign: TextAlign.center,
                                        hintText: 'Expense Type',
                                        value: viewModel
                                            .viewExpensesResponse[index].eType,
                                      ),
                                      flex: 1,
                                    ),
                                    wSizedBox(10),
                                    Expanded(
                                      flex: 1,
                                      child: AppTextView(
                                        textAlign: TextAlign.center,
                                        hintText: 'Expense Amount',
                                        value: viewModel
                                            .viewExpensesResponse[index].eAmount
                                            .toString(),
                                      ),
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
                ));
          },
          // ! length + 1 is the compensation of including buildHeader()
          itemCount: viewModel.viewExpensesResponse.length + 1),
    );
  }

  Widget _buildHeader({@required ViewExpensesViewModel viewModel}) {
    return Padding(
      padding: getSidePadding(context: context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: buildHeaderChip(
                      title: 'TOTAL EXPENSES (INR)',
                      value: viewModel.totalExpenses.toStringAsFixed(2),
                      iconName: expensesIcon),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderChip(
      {@required String title,
      @required String value,
      @required String iconName}) {
    return AppTiles(
      title: title,
      value: value,
      iconName: iconName,
    );
  }
}
