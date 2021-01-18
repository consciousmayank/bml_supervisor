import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dots_indicator.dart';
import 'package:bml_supervisor/widget/routes/route_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RoutesView extends StatefulWidget {
  final GetClientsResponse selectedClient;
  final Function onRoutesPageInView;

  RoutesView(
      {@required this.selectedClient, @required this.onRoutesPageInView});

  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoutesViewModel>.reactive(
      onModelReady: (viewModel) =>
          viewModel.getRoutesForClient(widget.selectedClient),
      builder: (context, viewModel, child) {
        return viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : viewModel.routesList.length > 0
                ? Stack(
                    children: [
                      PageView.builder(
                        onPageChanged: (int changedPageIndex) {
                          widget.onRoutesPageInView(
                              viewModel.routesList[changedPageIndex]);
                        },
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: AppColors.primaryColorShade5,
                            elevation: 4,
                            shape: getCardShape(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Image.asset(
                                    semiCircles,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(viewModel.routesList[index].title),
                                      Text(
                                          "${viewModel.routesList[index].srcLocation} - ${viewModel.routesList[index].dstLocation}"),
                                      Text(
                                          "Route # ${viewModel.routesList[index].id}"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: viewModel.routesList.length,
                      ),
                      Positioned(
                        bottom: 5,
                        left: 2,
                        right: 2,
                        child: DotsIndicator(
                          onPageSelected: (int index) {
                            print(
                                "aaaaaaa" + viewModel.routesList[index].title);
                          },
                          controller: _controller,
                          itemCount: viewModel.routesList.length,
                          color: AppColors.primaryColorShade1,
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Container(
                      child: Text("No Data"),
                    ),
                  );
      },
      viewModelBuilder: () => RoutesViewModel(),
    );
  }
}
