import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/screens/vehicle/view/vehicles_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/create_new_button_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

class VehiclesListView extends StatefulWidget {
  @override
  _VehiclesListViewState createState() => _VehiclesListViewState();
}

class _VehiclesListViewState extends State<VehiclesListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VehiclesListViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getVehiclesList(showLoading: true),
      builder: (context, viewModel, child) => SafeArea(
        left: false,
        right: false,
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: setAppBarTitle(title: 'Vehicle List'),
          ),
          body: viewModel.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : AddDriverBodyWidget(
                  viewModel: viewModel,
                ),
        ),
      ),
      viewModelBuilder: () => VehiclesListViewModel(),
    );
  }
}

class AddDriverBodyWidget extends StatefulWidget {
  final VehiclesListViewModel viewModel;

  const AddDriverBodyWidget({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _AddDriverBodyWidgetState createState() => _AddDriverBodyWidgetState();
}

class _AddDriverBodyWidgetState extends State<AddDriverBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getSidePadding(context: context),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 4,
              top: 2,
            ),
            child: CreateNewButtonWidget(
                title: 'Add New Vehicle',
                onTap: () {
                  widget.viewModel.onAddVehicleClicked();
                }),
          ),
          hSizedBox(5),
          widget.viewModel.vehiclesList.length == 0
              ? NoDataWidget(
                  label: 'No vehicles yet',
                )
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Vehicle List',
                    style: AppTextStyles.latoBold14primaryColorShade6,
                  ),
                ),
          widget.viewModel.vehiclesList.length == 0
              ? Container()
              : SearchWidget(
                  onClearTextClicked: () {
                    // selectedRegNoController.clear();
                    // viewModel.selectedVehicleId = '';
                    // viewModel.getExpenses(
                    //   showLoader: false,
                    // );
                    hideKeyboard(context: context);
                  },
                  hintTitle: 'Search for vehicle',
                  onTextChange: (String value) {
                    // viewModel.selectedVehicleId = value;
                    // viewModel.notifyListeners();
                  },
                  onEditingComplete: () {
                    // viewModel.getExpenses(
                    //   showLoader: true,
                    // );
                  },
                  formatter: <TextInputFormatter>[
                    TextFieldInputFormatter().alphaNumericFormatter,
                  ],
                  controller: TextEditingController(),
                  // focusNode: selectedRegNoFocusNode,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (String value) {
                    // viewModel.getExpenses(
                    //   showLoader: true,
                    // );
                  },
                ),
          hSizedBox(8),
          widget.viewModel.vehiclesList.length == 0
              ? Container()
              : Container(
                  color: AppColors.primaryColorShade5,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: Text(
                      //     ('S.No'),
                      //     textAlign: TextAlign.start,
                      //     style: AppTextStyles.whiteRegular,
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          ('VEHICLE NO.'),
                          textAlign: TextAlign.left,
                          style: AppTextStyles.whiteRegular,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            ('OWNER NAME'),
                            textAlign: TextAlign.left,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: Text(
                      //     'MODEL',
                      //     textAlign: TextAlign.left,
                      //     style: AppTextStyles.whiteRegular,
                      //   ),
                      // ),
                    ],
                  ),
                ),
          widget.viewModel.vehiclesList.length == 0
              ? Container()
              : Expanded(
                  child: LazyLoadScrollView(
                      scrollOffset: 300,
                      onEndOfPage: () =>
                          widget.viewModel.getVehiclesList(showLoading: false),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return buildSingleVehicleItem(context, index);
                        },
                        itemCount: widget.viewModel.vehiclesList.length,
                      )),
                ),
        ],
      ),
    );
  }

  Widget buildSingleVehicleItem(BuildContext context, int index) {
    String ownerName =
        widget.viewModel.vehiclesList[index].ownerName.toUpperCase();
    String model = widget.viewModel.vehiclesList[index].model.toUpperCase();

    if (ownerName.length > 15) {
      ownerName = ownerName.characters.take(15).toString() + '...';
    }
    if (model.length > 12) {
      model = model.characters.take(12).toString() + '...';
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.viewModel.openDriverDetailsBottomSheet(
              selectedDriverIndex: index,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(flex: 0.5, child: Text('${index}')),
                Expanded(
                  flex: 1,
                  child: Container(
                    // color:Colors.yellow,
                    child: Text(
                      '${widget.viewModel.vehiclesList[index].registrationNumber.toString().toUpperCase()}',
                      textAlign: TextAlign.left,
                      // style: AppTextStyles.latoMedium14Black.copyWith(color: AppColors.primaryColorShade5),

                      // style: AppTextStyles.underLinedText.copyWith(
                      //     color: AppColors.primaryColorShade5, fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        ownerName,
                        // maxLines: 3,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   flex: 5,
                //   child: Container(
                //     // color: Colors.red,
                //     child: Text(
                //       model,
                //       // overflow: TextOverflow.ellipsis,
                //       // softWrap: true,
                //       // maxLines: 3,
                //       textAlign: TextAlign.center,
                //       // style: AppTextStyles.latoMedium12Black.copyWith(
                //       //   fontSize: 14,
                //       // ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        DottedDivider()
      ],
    );
    // Card(
    //         shape: getCardShape(),
    //         margin: getSidePadding(context: context),
    //         child: InkWell(
    //           onTap: () {
    //             widget.viewModel.openDriverDetailsBottomSheet(
    //               selectedDriverIndex: index,
    //             );
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               children: [
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       flex: 1,
    //                       child: VehicleListTextView(
    //                         label: 'Owner Name',
    //                         value: widget
    //                             .viewModel.vehiclesList[index].ownerName,
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: 1,
    //                       child: VehicleListTextView(
    //                         label: 'Registration Number',
    //                         value: widget.viewModel.vehiclesList[index]
    //                             .registrationNumber,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 40,
    //                   child: Row(
    //                     children: [
    //                       Expanded(
    //                         flex: 1,
    //                         child: VehicleListTextView(
    //                           label: 'Chassis Number',
    //                           value: widget.viewModel.vehiclesList[index]
    //                               .chassisNumber,
    //                         ),
    //                       ),
    //                       Expanded(
    //                         flex: 1,
    //                         child: VehicleListTextView(
    //                           // labelFontSize: helper.labelFontSize,
    //                           // valueFontSize: helper.valueFontSize,
    //                           label: 'Engine Number',
    //                           value: widget.viewModel.vehiclesList[index]
    //                               .engineNumber,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 VehicleListTextView(
    //                   // labelFontSize: helper.labelFontSize,
    //                   // valueFontSize: helper.valueFontSize,
    //                   label: 'Vehicle Type',
    //                   value:
    //                       '${widget.viewModel.vehiclesList[index].model} ${widget.viewModel.vehiclesList[index].make}',
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
  }

  Container rightAlignedText({@required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        textAlign: TextAlign.end,
      ),
    );
  }

  String getExperience(int workExperienceYr) {
    if (workExperienceYr > 1) {
      return '$workExperienceYr Years Experience';
    } else {
      return '$workExperienceYr Year Experience';
    }
  }
}

class VehicleListTextView extends StatelessWidget {
  final String label, value;

  const VehicleListTextView({
    Key key,
    @required this.label,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextView(
      labelFontSize: 12,
      valueFontSize: 13,
      showBorder: false,
      textAlign: TextAlign.left,
      isUnderLined: false,
      hintText: label,
      value: value,
    );
  }
}
