import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:flutter/material.dart';
import 'package:bml/bml.dart';

class ViewExpensesDetailedView extends StatefulWidget {
  // final List<ViewExpensesResponse> viewExpensesDetailedList;
  final Map<String, dynamic> arguments;
  ViewExpensesDetailedView({this.arguments});
  @override
  _ViewExpensesDetailedViewState createState() =>
      _ViewExpensesDetailedViewState();
}

class _ViewExpensesDetailedViewState extends State<ViewExpensesDetailedView> {
  @override
  Widget build(BuildContext context) {
    // print('expense type: $test');
    final viewExpensesDetailedList =
        widget.arguments['viewExpensesDetailedList'];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments['selectedClient'],
            style: AppTextStyles.appBarTitleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: searchResults(context, viewExpensesDetailedList),
            ),
          ],
        ),
      ),
    );
  }

  searchResults(
      BuildContext context, List<ViewExpensesResponse> viewExpenseResponse) {
    return Scrollbar(
      // isAlwaysShown: true,
      child: ListView.builder(
          itemBuilder: (context, index) {
            // ! Below code is imp, helps to show custom header in a ListView
            if (index == 0) {
              // return the header chip
              return _buildHeader();
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
                    borderRadius: Utils().getBorderRadius(),
                    child: Card(
                      elevation: 4,
                      shape: Utils().getCardShape(),
                      child: Column(
                        children: [
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  viewExpenseResponse[index].vehicleId,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  viewExpenseResponse[index].eDate.toString(),
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
                                      child: Text("Expense Type : "),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          viewExpenseResponse[index].eType),
                                    )
                                  ],
                                ),
                                Utils().hSizedBox(5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Expense Amount : "),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(viewExpenseResponse[index]
                                          .eAmount
                                          .toStringAsFixed(2)),
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
          itemCount: viewExpenseResponse.length + 1),
    );
  }

  Widget _buildHeader() {
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
                    value: widget.arguments['totalExpenses'].toStringAsFixed(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderChip({String title, String value}) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              // style: TextStyle(fontSize: 20),
            ),
            Utils().wSizedBox(20),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 52, 58, 64),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }
}
