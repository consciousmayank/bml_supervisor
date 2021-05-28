// Added by Vikas
// Subject to change

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewExpensesViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.getClients();
        viewModel.getExpensesTypes();
        viewModel.getExpensePeriod();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: setAppBarTitle(title: 'View Expenses'),
            actions: [
              IconButton(
                  icon: Image.asset(
                    viewExpenseFilterIcon,
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () {
                    viewModel.showFiltersBottomSheet();
                  })
            ],
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 7,
                )
              : Padding(
                  padding: getSidePadding(context: context),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: SearchWidget(
                          onClearTextClicked: () {
                            selectedRegNoController.clear();
                            viewModel.selectedVehicleId = '';
                            viewModel.getExpenses(
                              showLoader: false,
                            );
                            hideKeyboard(context: context);
                          },
                          hintTitle: 'Search for Vehicle',
                          onTextChange: (String value) {
                            viewModel.selectedVehicleId = value;
                            viewModel.notifyListeners();
                          },
                          onEditingComplete: () {
                            viewModel.getExpenses(
                              showLoader: true,
                            );
                          },
                          formatter: <TextInputFormatter>[
                            TextFieldInputFormatter().alphaNumericFormatter,
                          ],
                          controller: selectedRegNoController,
                          focusNode: selectedRegNoFocusNode,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (String value) {
                            viewModel.getExpenses(
                              showLoader: true,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CreateNewButtonWidget(
                            title: 'Add Expense',
                            onTap: () {
                              viewModel.navigationService
                                  .navigateTo(addExpensesPageRoute)
                                  .then(
                                    (value) =>
                                        viewModel.getExpenses(showLoader: true),
                                  );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                        ),
                        child: DottedDivider(),
                      ),
                      if (viewModel.expensePeriodList.length > 0)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Container(
                            height: 25,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    'Expenses for ${getMonth(viewModel?.expensePeriodList?.first?.month ?? 0)}, ${viewModel?.expensePeriodList?.first?.year ?? 2024}'),
                                // Text('Dummy data for May, 2021'),
                                InkWell(
                                  onTap: () => viewModel.changeExpenePeriod(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      'Change',
                                      style: AppTextStyles.hyperLinkStyle,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      viewModel.expenseList.length > 0
                          ? Expanded(
                              child: searchResults(viewModel: viewModel),
                            )
                          : viewModel.expensePeriodList.length > 0 &&
                                  viewModel.expenseList.length == 0
                              ? Expanded(child: NoDataWidget())
                              : Container()
                    ],
                  ),
                ),
        );
      },
      viewModelBuilder: () => ViewExpensesViewModel(),
    );
  }

  searchResults({@required ViewExpensesViewModel viewModel}) {
    return LazyLoadScrollView(
      scrollOffset: (MediaQuery.of(context).size.height ~/ 6),
      onEndOfPage: () => viewModel.getExpenses(
        showLoader: false,
        shouldGetExpenseAggregate: false,
      ),
      child: ListView.builder(
          itemBuilder: (context, index) {
            // ! Below code is imp, helps to show custom header in a ListView
            if (index == 0) {
              // return the header chip
              return _buildHeader(viewModel: viewModel);
            }
            index -= 1;

            return viewModel.getConsolidatedData(index).length > 0
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: getBorderRadius(),
                      child: Card(
                        color: AppColors.appScaffoldColor,
                        elevation: defaultElevation,
                        shape: getCardShape(),
                        child: Column(
                          children: [
                            // if date is same don't build new date header
                            // if(viewModel.vehicleEntrySearchResponseList.length > 0){}
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date',
                                    style: AppTextStyles.latoBold16White,
                                  ),
                                  Text(
                                    viewModel.uniqueDates
                                        .elementAt(index)
                                        .toString(),
                                    style: AppTextStyles.latoBold16White,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: buildNewEntryRow(viewModel, index),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container();
          },
          // ! length + 1 is the compensation of including buildHeader()
          itemCount: viewModel.uniqueDates.length + 1),
    );
  }

  List<Widget> buildNewEntryRow(
      ViewExpensesViewModel viewModel, int outerIndex) {
    return List.generate(
      viewModel.getConsolidatedData(outerIndex).length,
      (index) => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text("Driven Km"),
                Expanded(
                  flex: 1,
                  child: AppTextView(
                    hintText: "Type",
                    textAlign: TextAlign.left,
                    fontSize: 12,
                    value: viewModel
                        .getConsolidatedData(outerIndex)[index]
                        .expenseType
                        .toString(),
                  ),
                ),
                wSizedBox(8),
                Expanded(
                  flex: 1,
                  child: AppTextView(
                    textAlign: TextAlign.left,
                    fontSize: 12,
                    hintText: "Vehicle",
                    value: viewModel
                        .getConsolidatedData(outerIndex)[index]
                        .vehicleId
                        .toString(),
                  ),
                ),
                wSizedBox(8),
                Expanded(
                  flex: 1,
                  child: AppTextView(
                    textAlign: TextAlign.left,
                    fontSize: 14,
                    hintText: "Amount (INR)",
                    value: viewModel
                        .getConsolidatedData(outerIndex)[index]
                        .expenseAmount
                        .toString(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ).toList();
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
                      value: viewModel.expenseAggregate.totalAmount
                          .toStringAsFixed(2),
                      iconName: rupeesIcon),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: buildHeaderChip(
                      title: 'EXPENSES COUNT',
                      value: viewModel.expenseAggregate.recordCount.toString(),
                      iconName: expensesCountIcon),
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
