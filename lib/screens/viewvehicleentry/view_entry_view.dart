import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/viewvehicleentry/view_entry_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/select_duration_tab.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

class ViewVehicleEntryView extends StatefulWidget {
  @override
  _ViewVehicleEntryViewState createState() => _ViewVehicleEntryViewState();
}

class _ViewVehicleEntryViewState extends State<ViewVehicleEntryView> {
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();
  // ScrollController _scrollController = ScrollController();
  //
  // @override
  // void dispose() {
  //   _scrollController.removeListener(() {});
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewVehicleEntryViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.getClients();
        getDailyEntry(
            viewModel: viewModel,
            registrationNumber: selectedRegNoController.text);
      },
      builder: (context, viewModel, child) {
        // _scrollController.addListener(() {
        //   if (_scrollController.position.userScrollDirection ==
        //       ScrollDirection.reverse) {
        //     viewModel.hideFloatingActionButton();
        //   }
        //   if (_scrollController.position.userScrollDirection ==
        //       ScrollDirection.forward) {
        //     viewModel.showFloatingActionButton();
        //   }
        // });
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'View Entry - ${MyPreferences().getSelectedClient().clientId}',
                style: AppTextStyles.appBarTitleStyle),
            centerTitle: true,
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 7,
                )
              : Column(
                  children: [
                    buildSelectDurationTabWidget(viewModel),
                    registrationSelector(
                        context: context, viewModel: viewModel),
                    viewModel.vehicleEntrySearchResponseList.length > 0
                        ? Expanded(
                            child: searchResults(viewModel: viewModel),
                          )
                        : Container()
                  ],
                ),
          floatingActionButton: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: viewModel.isFloatingActionButtonVisible ? 1.0 : 0.0,
            child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  viewModel.navigationService
                      .navigateTo(addEntryLogPageRoute)
                      .then(
                        (value) => getDailyEntry(
                            viewModel: viewModel,
                            registrationNumber: selectedRegNoController.text),
                      );
                }),
          ),
        );
      },
      viewModelBuilder: () => ViewVehicleEntryViewModel(),
    );
  }

  SelectDurationTabWidget buildSelectDurationTabWidget(
      ViewVehicleEntryViewModel viewModel) {
    return SelectDurationTabWidget(
      initiallySelectedDuration: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
      onTabSelected: (String selectedValue) {
        viewModel.selectedDuration = selectedValue;
        getDailyEntry(
            viewModel: viewModel,
            registrationNumber: selectedRegNoController.text);
      },
      title: selectDurationTabWidgetTitle,
    );
  }

  registrationSelector(
      {BuildContext context, ViewVehicleEntryViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
        // selectRegButton(context, viewModel),
      ],
    );
  }

  registrationNumberTextField(ViewVehicleEntryViewModel viewModel) {
    return appTextFormField(
      enabled: true,
      controller: selectedRegNoController,
      onFieldSubmitted: (String value) {
        getDailyEntry(viewModel: viewModel, registrationNumber: value);
      },
      hintText: '$drRegNoHint (Optional)',
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

  void getDailyEntry(
      {ViewVehicleEntryViewModel viewModel, String registrationNumber}) {
    viewModel.vehicleEntrySearch(
      regNum: registrationNumber,
      selectedDuration: viewModel.selectedDuration,
      clientId: viewModel.selectedClient.clientId,
    );
  }

  searchResults({@required ViewVehicleEntryViewModel viewModel}) {
    return ListView.builder(
        // controller: _scrollController,
        itemBuilder: (context, index) {
          if (index == 0) {
            // return the header
            return _buildChip(viewModel: viewModel);
          }
          index -= 1;

          return _SingleEntryWidget(
            viewModel: viewModel,
            index: index,
          );
        },
        itemCount: viewModel.vehicleEntrySearchResponseList.length + 1);
  }

  Widget _buildChip({@required ViewVehicleEntryViewModel viewModel}) {
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
                  value: viewModel.totalKm.toString(),
                  iconName: totalKmIcon,
                ),
              ),
              wSizedBox(10),
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'KM. DIFF',
                  value: viewModel.kmDifference.toString(),
                  iconName: totalKmIcon,
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
                  value: viewModel.totalFuelInLtr.toStringAsFixed(2),
                  iconName: totalKmIcon,
                ),
              ),
              wSizedBox(10),
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'AVG./LTR',
                  value: viewModel.avgPerLitre.toStringAsFixed(2),
                  iconName: totalKmIcon,
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
                    value: viewModel.totalFuelAmt.toStringAsFixed(2),
                    iconName: totalKmIcon,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildViewEntrySummary(
      {@required String title,
      @required String value,
      @required String iconName}) {
    return AppTiles(
      title: title,
      value: value,
      iconName: iconName,
      onTap: null,
    );
  }
}

class _SingleEntryWidget extends StatelessWidget {
  final ViewVehicleEntryViewModel viewModel;
  final int index;

  const _SingleEntryWidget({
    Key key,
    @required this.viewModel,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      viewModel.vehicleEntrySearchResponseList[index].vehicleId
                          .toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      viewModel.vehicleEntrySearchResponseList[index].entryDate
                          .toString(),
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: "Start Reading",
                            value: viewModel
                                .vehicleEntrySearchResponseList[index]
                                .startReading
                                .toString(),
                          ),
                        ),
                        wSizedBox(10),
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: "End Reading",
                            value: viewModel
                                .vehicleEntrySearchResponseList[index]
                                .endReading
                                .toString(),
                          ),
                        ),
                        wSizedBox(10),
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: "Trips",
                            value: viewModel
                                .vehicleEntrySearchResponseList[index].trips
                                .toString(),
                          ),
                        )
                      ],
                    ),
                    hSizedBox(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: 'Login Time',
                            value: viewModel
                                .vehicleEntrySearchResponseList[index].loginTime
                                .toString(),
                          ),
                        ),
                        wSizedBox(10),
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: 'Logout Time',
                            value: viewModel
                                .vehicleEntrySearchResponseList[index]
                                .logoutTime
                                .toString(),
                          ),
                        ),
                        wSizedBox(10),
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: 'Driven Km',
                            value: viewModel
                                .vehicleEntrySearchResponseList[index].drivenKm
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                    hSizedBox(5),
                    InkWell(
                      onTap: () {
                        showViewEntryDetailPreview(context,
                            viewModel.vehicleEntrySearchResponseList[index]);
                      },
                      child: Text(
                        'More Info',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
