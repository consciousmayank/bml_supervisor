import 'package:flutter/material.dart';
import 'package:bml_supervisor/models/view_expenses_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/app_level/themes.dart';

class ViewExpensesDetailedView extends StatefulWidget {
  final List<ViewExpensesResponse> viewExpensesDetailedList;
  ViewExpensesDetailedView({this.viewExpensesDetailedList});
  @override
  _ViewExpensesDetailedViewState createState() =>
      _ViewExpensesDetailedViewState();
}

class _ViewExpensesDetailedViewState extends State<ViewExpensesDetailedView> {
  @override
  Widget build(BuildContext context) {
    // print('expense type: $test');
    return Scaffold(
      appBar: AppBar(
        title: Text('View Expenses - Detailed List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: searchResults(context, widget.viewExpensesDetailedList),
            ),
          ],
        ),
      ),
    );
  }

  searchResults(
      BuildContext context, List<ViewExpensesResponse> viewExpenseResponse) {
    return ListView.builder(
        itemBuilder: (context, index) {
          // ! Below code is imp, helps to show custom header in a ListView
          // if (index == 0) {
          //    return the header
          //   return _buildChip();
          // }
          // index -= 1;

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
                                viewExpenseResponse[index].vehicleId,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                viewExpenseResponse[index].entryDate.toString(),
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
                                        viewExpenseResponse[index].expenseType),
                                  )
                                ],
                              ),
                              hSizedBox(5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text("Expense Amount : "),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(viewExpenseResponse[index]
                                        .expenseAmount
                                        .toStringAsFixed(2)),
                                  )
                                ],
                              ),
                              hSizedBox(5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text("Expense Description: "),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                        viewExpenseResponse[index].expenseDesc),
                                  )
                                ],
                              ),
                              hSizedBox(5),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        },
        itemCount: viewExpenseResponse.length);
  }
}
