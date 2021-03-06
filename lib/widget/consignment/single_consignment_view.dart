import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/consignment/single_consignment_viewmodel.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../dots_indicator.dart';

class SingleConsignmentView extends StatefulWidget {
  final FetchRoutesResponse selectedRoute;
  final Key key;
  SingleConsignmentView({@required this.selectedRoute, @required this.key})
      : super(key: key);

  @override
  _SingleConsignmentViewState createState() => _SingleConsignmentViewState();
}

class _SingleConsignmentViewState extends State<SingleConsignmentView> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleConsignmentViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getHubs(widget.selectedRoute),
        builder: (context, viewModel, child) => viewModel.hubsList.length > 0
            ? Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: AppColors.primaryColorShade5,
                        elevation: 4,
                        shape: getCardShape(),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image.asset(
                              semiCircles,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(viewModel.hubsList[index].title),
                                  Text(
                                      "${viewModel.hubsList[index].contactPerson} - ${viewModel.hubsList[index].mobile}"),
                                  Text(
                                      "City - ${viewModel.hubsList[index].city}"),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: viewModel.hubsList.length,
                  ),
                  Positioned(
                    bottom: 5,
                    left: 2,
                    right: 2,
                    child: DotsIndicator(
                      controller: _controller,
                      itemCount: viewModel.hubsList.length,
                      color: AppColors.primaryColorShade1,
                    ),
                  )
                ],
              )
            : Center(child: NoDataWidget()),
        viewModelBuilder: () => SingleConsignmentViewModel());
  }
}
