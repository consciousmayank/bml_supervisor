import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/view_entry_response.dart';
import 'package:bml_supervisor/screens/dailykms/view/view_daily_kms_viewmodel.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_tiles.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class ViewDailyKmsView extends StatefulWidget {
  @override
  _ViewDailyKmsViewState createState() => _ViewDailyKmsViewState();
}

class _ViewDailyKmsViewState extends State<ViewDailyKmsView> {
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();
  final myController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewDailyKmsViewModel>.reactive(
      onModelReady: (viewModel) {
        viewModel.getClients();
        getDailyEntry(
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
          appBar: AppBar(
            title: setAppBarTitle(title: 'Daily Kilometers'),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  viewModel.showMonthYearBottomSheet();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    filteredIcon,
                    color: AppColors.white,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 7,
                )
              : Column(
                  children: [
                    // buildSelectDurationTabWidget(viewModel),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: SearchWidget(
                        onClearTextClicked: () {
                          selectedRegNoController.clear();
                          getDailyEntry(
                            viewModel: viewModel,
                            registrationNumber:
                                selectedRegNoController.text.trim(),
                          );
                          hideKeyboard(context: context);
                        },
                        hintTitle: 'Search for vehicle',
                        onTextChange: (String value) {},
                        onEditingComplete: () {
                          getDailyEntry(
                            viewModel: viewModel,
                            registrationNumber:
                                selectedRegNoController.text.trim(),
                          );
                        },
                        formatter: <TextInputFormatter>[
                          TextFieldInputFormatter().alphaNumericFormatter,
                        ],
                        controller: selectedRegNoController,
                        focusNode: selectedRegNoFocusNode,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (String value) {
                          getDailyEntry(
                            viewModel: viewModel,
                            registrationNumber:
                                selectedRegNoController.text.trim(),
                          );
                        },
                      ),
                    ),
                    // registrationSelector(
                    //     context: context, viewModel: viewModel),
                    viewModel.vehicleEntrySearchResponseList.length > 0
                        ? Expanded(
                            child: searchResults(viewModel: viewModel),
                          )
                        : Container()
                  ],
                ),
          // floatingActionButton: AnimatedOpacity(
          //   duration: Duration(milliseconds: 200),
          //   opacity: viewModel.isFloatingActionButtonVisible ? 1.0 : 0.0,
          //   child: FloatingActionButton(
          //       child: Icon(Icons.add),
          //       onPressed: () {
          //         viewModel.navigationService
          //             .navigateTo(addEntryLogPageRoute)
          //             .then(
          //               (value) => getDailyEntry(
          //                   viewModel: viewModel,
          //                   registrationNumber: selectedRegNoController.text),
          //             );
          //       }),
          // ),
        );
      },
      viewModelBuilder: () => ViewDailyKmsViewModel(),
    );
  }

  registrationSelector(
      {BuildContext context, ViewDailyKmsViewModel viewModel}) {
    return registrationNumberTextField(viewModel);
  }

  registrationNumberTextField(ViewDailyKmsViewModel viewModel) {
    return appTextFormField(
      buttonType: ButtonType.SMALL,
      buttonIcon: Icon(Icons.search),
      onButtonPressed: () {
        getDailyEntry(
          viewModel: viewModel,
          registrationNumber: selectedRegNoController.text,
        );
      },
      inputDecoration: InputDecoration(
        hintText: 'Vehicle Number',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      // labelText: 'demo',
      enabled: true,
      controller: selectedRegNoController,
      onFieldSubmitted: (String value) {
        getDailyEntry(viewModel: viewModel, registrationNumber: value);
      },
      // hintText: '',
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
      {ViewDailyKmsViewModel viewModel, String registrationNumber}) {
    viewModel.vehicleEntrySearch(
      regNum: registrationNumber,
      clientId: viewModel.selectedClient?.clientId,
    );
  }

  searchResults({@required ViewDailyKmsViewModel viewModel}) {
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

  Widget _buildChip({@required ViewDailyKmsViewModel viewModel}) {
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
                  iconName: fuelIcon,
                ),
              ),
              Expanded(
                flex: 1,
                child: buildViewEntrySummary(
                  title: 'AVG./LTR',
                  value: viewModel.avgPerLitre.toStringAsFixed(2),
                  iconName: fuelIcon,
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
                    iconName: rupeesIcon,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: buildViewEntrySummary(
                    title: 'ENTRY COUNT',
                    value: viewModel.entryCount.toString(),
                    iconName: entryCountIcon,
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
  final ViewDailyKmsViewModel viewModel;
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
          color: AppColors.appScaffoldColor,
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
                    hSizedBox(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: 'Fuel Ltr',
                            value: viewModel
                                .vehicleEntrySearchResponseList[index].fuelLtr
                                .toString(),
                          ),
                        ),
                        wSizedBox(10),
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: 'Fuel Rate (INR)',
                            value: viewModel
                                .vehicleEntrySearchResponseList[index]
                                .ratePerLtr
                                .toString(),
                          ),
                        ),
                        wSizedBox(10),
                        Expanded(
                          flex: 1,
                          child: AppTextView(
                            textAlign: TextAlign.center,
                            hintText: 'Fuel Amount (INR)',
                            value: viewModel
                                .vehicleEntrySearchResponseList[index]
                                .amountPaid
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                    hSizedBox(5),
                    InkWell(
                      onTap: () {
                        viewModel.openDailyEntryDetailsBottomSheet(
                          clickedDailyEntry:
                              viewModel.vehicleEntrySearchResponseList[index],
                        );
                        // showViewEntryDetailPreview(context,
                        //     viewModel.vehicleEntrySearchResponseList[index]);
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
          return Container(
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
                            response.vehicleId,
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
                                child: AppTextView(
                                  textAlign: TextAlign.center,
                                  hintText: 'Start Reading (G)',
                                  value: viewModel
                                      .vehicleEntrySearchResponseList[index]
                                      .startReadingGround
                                      .toString(),
                                ),
                                flex: 1,
                              ),
                              wSizedBox(10),
                              Expanded(
                                flex: 1,
                                child: AppTextView(
                                  textAlign: TextAlign.center,
                                  hintText: 'DRIVEN KM (G)',
                                  value: viewModel
                                      .vehicleEntrySearchResponseList[index]
                                      .drivenKmGround
                                      .toString(),
                                ),
                              )
                            ],
                          ),
                          hSizedBox(10),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextView(
                                  textAlign: TextAlign.center,
                                  hintText: 'FUEL METER READING',
                                  value: viewModel
                                      .vehicleEntrySearchResponseList[index]
                                      .fuelMeterReading
                                      .toString(),
                                ),
                                flex: 1,
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
        });
  }
}
