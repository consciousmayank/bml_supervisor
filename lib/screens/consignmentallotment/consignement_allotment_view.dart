import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/screens/consignmentallotment/consignement_allotment_viewmodel.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/hub/hub_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class ConsignmentAllotmentView extends StatefulWidget {
  @override
  _ConsignmentAllotmentViewState createState() =>
      _ConsignmentAllotmentViewState();
}

class _ConsignmentAllotmentViewState extends State<ConsignmentAllotmentView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentAllotmentViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getRoutes(),
        builder: (context, viewModel, child) => SafeArea(
            left: false,
            right: false,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Allot Consignments"),
              ),
              body: viewModel.isBusy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: getSidePadding(context: context),
                      child: body(context, viewModel),
                    ),
            )),
        viewModelBuilder: () => ConsignmentAllotmentViewModel());
  }

  Widget body(BuildContext context, ConsignmentAllotmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RoutesDropDown(
          optionList: viewModel.routesList,
          hint: "Select Routes",
          onOptionSelect: (GetRoutesResponse selectedValue) =>
              viewModel.selectedRoute = selectedValue,
          selectedValue:
              viewModel.selectedRoute == null ? null : viewModel.selectedRoute,
        ),
        viewModel.selectedRoute == null
            ? Container()
            : makeTimeLine(context: context, viewModel: viewModel)
      ],
    );
  }

  Widget makeTimeLine(
      {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
    return Expanded(
      child: Timeline.builder(
          itemBuilder: (context, index) => TimelineModel(
                SizedBox(
                  height: 100,
                  child: HubView(
                      hub: viewModel
                          .routesList[viewModel.routesList
                              .indexOf(viewModel.selectedRoute)]
                          .hub[index]),
                ),
                position:
                    // TimelineItemPosition.right,
                    TimelineItemPosition.left,
                isFirst: index == 0,
                isLast: index ==
                    viewModel
                        .routesList[viewModel.routesList
                            .indexOf(viewModel.selectedRoute)]
                        .hub
                        .length,
                iconBackground: ThemeConfiguration.primaryBackground,
                icon: Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                ),
              ),
          itemCount: viewModel
              .routesList[viewModel.routesList.indexOf(viewModel.selectedRoute)]
              .hub
              .length,
          physics:
              // ClampingScrollPhysics(),
              BouncingScrollPhysics(),
          position: TimelinePosition.Left),
    );
  }
}

class RoutesDropDown extends StatefulWidget {
  final List<GetRoutesResponse> optionList;
  final GetRoutesResponse selectedValue;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;
  RoutesDropDown(
      {@required this.optionList,
      this.selectedValue,
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _RoutesDropDownState createState() => _RoutesDropDownState();
}

class _RoutesDropDownState extends State<RoutesDropDown> {
  List<DropdownMenuItem<GetRoutesResponse>> dropdown = [];

  List<DropdownMenuItem<GetRoutesResponse>> getDropDownItems() {
    List<DropdownMenuItem<GetRoutesResponse>> dropdown =
        List<DropdownMenuItem<GetRoutesResponse>>();

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            widget.optionList[i].title,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        value: widget.optionList[i],
      ));
    }
    return dropdown;
  }

  @override
  Widget build(BuildContext context) {
    return widget.optionList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.hint ?? ""),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: DropdownButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: ThemeConfiguration.primaryBackground,
                      ),
                    ),
                    underline: Container(),
                    isExpanded: true,
                    style: textFieldStyle(
                        fontSize: 15.0, textColor: Colors.black54),
                    // hint: Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 20),
                    //   child: Text(
                    //     widget.hint,
                    //     style: TextStyle(color: Colors.black26),
                    //   ),
                    // ),
                    value: widget.selectedValue,
                    items: getDropDownItems(),
                    onChanged: (value) {
                      widget.onOptionSelect(value);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  TextStyle textFieldStyle({double fontSize, Color textColor}) {
    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal);
  }
}
