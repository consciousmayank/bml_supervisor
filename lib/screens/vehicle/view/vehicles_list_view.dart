import 'package:bml_supervisor/screens/vehicle/view/vehicles_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
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
      child: LazyLoadScrollView(
          scrollOffset: 300,
          onEndOfPage: () =>
              widget.viewModel.getVehiclesList(showLoading: false),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                shape: getCardShape(),
                margin: getSidePadding(context: context),
                child: InkWell(
                  onTap: () {
                    widget.viewModel.openDriverDetailsBottomSheet(
                      selectedDriverIndex: index,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: VehicleListTextView(
                                label: 'Owner Name',
                                value: widget
                                    .viewModel.vehiclesList[index].ownerName,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: VehicleListTextView(
                                label: 'Registration Number',
                                value: widget.viewModel.vehiclesList[index]
                                    .registrationNumber,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: VehicleListTextView(
                                  label: 'Chassis Number',
                                  value: widget.viewModel.vehiclesList[index]
                                      .chassisNumber,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: VehicleListTextView(
                                  // labelFontSize: helper.labelFontSize,
                                  // valueFontSize: helper.valueFontSize,
                                  label: 'Engine Number',
                                  value: widget.viewModel.vehiclesList[index]
                                      .engineNumber,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VehicleListTextView(
                          // labelFontSize: helper.labelFontSize,
                          // valueFontSize: helper.valueFontSize,
                          label: 'Vehicle Type',
                          value:
                              '${widget.viewModel.vehiclesList[index].model} ${widget.viewModel.vehiclesList[index].make}',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.viewModel.vehiclesList.length,
          )),
    );
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
