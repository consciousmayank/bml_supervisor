// Added by Vikas
// Subject to change

import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/screens/expenses/view/view_expenses_viewmodel.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bml/bml.dart';

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
          // floatingActionButton: AnimatedOpacity(
          //   duration: Duration(milliseconds: 200),
          //   opacity: viewModel.isFloatingActionButtonVisible ? 1.0 : 0.0,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       viewModel.navigationService
          //           .navigateTo(addExpensesPageRoute)
          //           .then(
          //             (value) => getExpenses(
          //                 viewModel: viewModel,
          //                 registrationNumber: selectedRegNoController.text),
          //           );
          //     },
          //     child: Icon(Icons.add),
          //   ),
          // ),
          appBar: AppBar(
            title: Text(
              'View Expenses - ${viewModel.preferences.getSelectedClient().clientId}',
              style: AppTextStyles.appBarTitleStyle,
            ),
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
                  padding: Utils().getSidePadding(context: context),
                  child: Column(
                    children: [
                      // buildSelectDurationTabWidget(viewModel),
                      // Text('asdf'),
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

  // Widget selectDuration({ViewExpensesViewModel viewModel}) {
  //   return AppDropDown(
  //     optionList: selectDurationList,
  //     hint: "Select Duration",
  //     onOptionSelect: (selectedValue) {
  //       viewModel.selectedDuration = selectedValue;
  //       print(viewModel.selectedDuration);
  //     },
  //     selectedValue: viewModel.selectedDuration.isEmpty
  //         ? null
  //         : viewModel.selectedDuration,
  //   );
  // }

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
      inputDecoration: InputDecoration(
        hintText: 'Vehicle Number',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      enabled: true,
      controller: selectedRegNoController,
      onFieldSubmitted: (String value) {
        getExpenses(viewModel: viewModel, registrationNumber: value);
      },
      // hintText: drRegNoHint,
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

  // Widget getExpenseListButton({ViewExpensesViewModel viewModel}) {
  //   return SizedBox(
  //     height: buttonHeight,
  //     width: double.infinity,
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 4.0),
  //       child: ElevatedButton(
  //         child: Text("Get Expenses List"),
  //         onPressed: () {
  //           if (viewModel.selectedDuration.length != 0) {
  //             viewModel.getExpensesList(
  //               regNum: selectedRegNoController.text.trim().toUpperCase(),
  //               selectedDuration: viewModel.selectedDuration,
  //               clientId: viewModel.selectedClient != null
  //                   ? viewModel.selectedClient.clientId
  //                   : '',
  //             );
  //           } else {
  //             viewModel.snackBarService
  //                 .showSnackbar(message: 'Please select Duration');
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  // SelectDurationTabWidget buildSelectDurationTabWidget(
  //     ViewExpensesViewModel viewModel) {
  //   return SelectDurationTabWidget(
  //     initiallySelectedDuration: viewModel.selectedDuration.isEmpty
  //         ? null
  //         : viewModel.selectedDuration,
  //     onTabSelected: (String selectedValue) {
  //       viewModel.selectedDuration = selectedValue;
  //       getExpenses(
  //           viewModel: viewModel,
  //           registrationNumber: selectedRegNoController.text);
  //     },
  //     title: selectDurationTabWidgetTitle,
  //   );
  // }

  void getExpenses(
      {ViewExpensesViewModel viewModel, String registrationNumber}) {
    viewModel.getExpensesList(
      regNum: registrationNumber,
      // selectedDuration: viewModel.selectedDuration,
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

            return viewModel.getConsolidatedData(index).length > 0
                ? InkWell(
                    onTap: () {
                      // showViewEntryDetailPreview(
                      //     context, vehicleEntrySearchResponse[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: Utils().getBorderRadius(),
                        child: Card(
                          color: AppColors.appScaffoldColor,
                          elevation: defaultElevation,
                          shape: Utils().getCardShape(),
                          child: Column(
                            children: [
                              // if date is same don't build new date header
                              // if(viewModel.vehicleEntrySearchResponseList.length > 0){}
                              Container(
                                decoration: BoxDecoration(
                                  color: ThemeConfiguration().primaryBackground,
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
                                      viewModel.uniqueDates[index].toString(),
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
                        .eType
                        .toString(),
                  ),
                ),
                Utils().wSizedBox(8),
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
                Utils().wSizedBox(8),
                Expanded(
                  flex: 1,
                  child: AppTextView(
                    textAlign: TextAlign.left,
                    fontSize: 14,
                    hintText: "Amount (INR)",
                    value: viewModel
                        .getConsolidatedData(outerIndex)[index]
                        .eAmount
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
      padding: Utils().getSidePadding(context: context),
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
                      iconName: rupeesIcon),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: buildHeaderChip(
                      title: 'EXPENSES COUNT',
                      value: viewModel.expenseCount.toString(),
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
