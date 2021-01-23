import 'package:bml_supervisor/models/recent_consignment_response.dart';
import 'package:flutter/material.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';

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
        title: Text('All Consignment'),
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
                hSizedBox(5),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                hSizedBox(5),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          hSizedBox(10),
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
                                        color: getDashboardDueKmTileBgColor(),
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
                                          color:
                                              getDashboardDistributerTileBgColor(),
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
                          hSizedBox(10),
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
