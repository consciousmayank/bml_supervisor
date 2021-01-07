import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ViewEntryDetailedView2Point0 extends StatefulWidget {
  final Map<String, dynamic> arguments;
  ViewEntryDetailedView2Point0({this.arguments});

  @override
  _ViewEntryDetailedView2Point0State createState() =>
      _ViewEntryDetailedView2Point0State();
}

class _ViewEntryDetailedView2Point0State
    extends State<ViewEntryDetailedView2Point0> {
  @override
  Widget build(BuildContext context) {
    // final totalKm = widget.arguments['totalKm'].toString();
    // final kmDifference = widget.arguments['kmDifference'].toString();
    // final totalFuelInLtr = widget.arguments['totalFuelInLtr'].toString();
    // final avgPerLitre = widget.arguments['avgPerLitre'].toString();
    // final totalFuelAmt = widget.arguments['totalFuelAmt'].toString();

    final vehicleEntrySearchResponseList =
        widget.arguments['vehicleEntrySearchResponseList'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed View Entry 2.0'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // _buildChip(),
            // hSizedBox(20),
            Expanded(
              child: searchResults(context, vehicleEntrySearchResponseList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip() {
    print(
      'After receiveing-total Km: ' + widget.arguments['totalKm'].toString(),
    );
    return Padding(
      padding: getSidePadding(context: context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'KMS',
                  value: widget.arguments['totalKm'].toString(),
                ),
              ),
              wSizedBox(10),
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'KM. DIFF',
                  value: widget.arguments['kmDifference'].toString(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'FUEL (LTR)',
                  value: widget.arguments['totalFuelInLtr'].toStringAsFixed(2),
                ),
              ),
              wSizedBox(10),
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'AVG./LTR',
                  value: widget.arguments['avgPerLitre'].toStringAsFixed(2),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: buildViewEntrySummary(
                    title: 'AMOUNT (INR)',
                    value: widget.arguments['totalFuelAmt'].toStringAsFixed(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildViewEntrySummary({String title, String value}) {
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
            wSizedBox(20),
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

  searchResults(BuildContext context,
      List<ViewEntryResponse> vehicleEntrySearchResponse) {
    return ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            // return the header
            return _buildChip();
          }
          index -= 1;

          return Padding(
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
                            'Date',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            vehicleEntrySearchResponse[index]
                                .entryDate
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
                                flex: 1,
                                child: Text("Start Reading : "),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(vehicleEntrySearchResponse[index]
                                    .startReading
                                    .toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("End Reading : "),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(vehicleEntrySearchResponse[index]
                                    .endReading
                                    .toString()),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Login Time : "),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(vehicleEntrySearchResponse[index]
                                    .loginTime
                                    .toString()),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                child: Text(
                                  'More Info',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  showViewEntryDetailPreview(context,
                                      vehicleEntrySearchResponse[index]);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: vehicleEntrySearchResponse.length + 1);
  }

  void showViewEntryDetailPreview(
      BuildContext context, ViewEntryResponse response) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
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
                            "Entry Date",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            response.entryDate,
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
                                child: Text("START READING : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.startReading.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("START READING (G) : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    response.startReadingGround.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("END READING : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.endReading.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("DRIVEN KM : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.drivenKm.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("DRIVEN KM (G) : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.drivenKmGround.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("TRIPS : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.trips.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("FUEL LTR. : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.fuelLtr.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("FUEL RATE (INR) : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.ratePerLtr.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("FUEL METER READING "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child:
                                    Text(response.fuelMeterReading.toString()),
                              )
                            ],
                          ),
                          hSizedBox(5),
                          Row(
                            children: [
                              Expanded(
                                child: Text("FUEL AMOUNT (INR) : "),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(response.amountPaid.toString()),
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
          );
        });
  }
}
