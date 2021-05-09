import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:flutter/material.dart';
import 'package:bml/bml.dart';

class ViewAllConsignmentsView extends StatefulWidget {
  final List<RecentConginmentResponse> recentConsignmentList;
  ViewAllConsignmentsView({this.recentConsignmentList});

  @override
  _ViewAllConsignmentsViewState createState() =>
      _ViewAllConsignmentsViewState();
}

class _ViewAllConsignmentsViewState extends State<ViewAllConsignmentsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Consignment', style: AppTextStyles.appBarTitleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      ('Date'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ('Km Driven'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ('Trips'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ('Track'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Utils().hSizedBox(5),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                Utils().hSizedBox(5),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Utils().hSizedBox(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.recentConsignmentList[index].entryDate,
                              ),
                              Text(
                                widget.recentConsignmentList[index].drivenKm
                                    .toString(),
                              ),
                              Text(
                                widget.recentConsignmentList[index].trips
                                    .toString(),
                              ),
                              widget.recentConsignmentList[index].routeId == 0
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Utils()
                                            .getDashboardDueKmTileBgColor(),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        'Consignment',
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        //! Go to view consignment page
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Utils()
                                              .getDashboardDistributerTileBgColor(),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                        child: Text(
                                          'Consignment',
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          Utils().hSizedBox(10),
                          index + 1 != widget.recentConsignmentList.length
                              ? Container(
                                  height: 1,
                                  color: Colors.black,
                                )
                              : Container(),
                        ],
                      );
                    },
                    itemCount: widget.recentConsignmentList.length,
                  ),
                ),
                // FlatButton(
                //   child: Text(
                //     'View More',
                //     style: TextStyle(
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                //   onPressed: () {
                //     //todo: got to show all consignments' page
                //     widget.takeToAllConsgnmentsPage();
                //     // showViewEntryDetailPreview(context,
                //     //     vehicleEntrySearchResponse[index]);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
