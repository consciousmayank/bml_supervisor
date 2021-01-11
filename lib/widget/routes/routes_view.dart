import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dots_indicator.dart';
import 'package:bml_supervisor/widget/routes/route_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RoutesView extends StatefulWidget {
  final GetClientsResponse selectedClient;
  final Function onRoutesClick;
  RoutesView({@required this.selectedClient, @required this.onRoutesClick});

  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  PageController _controller = PageController(
    initialPage: 0,
  );

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
      builder: (context, viewModel, child) => viewModel.routesList.length > 0
          ? Stack(
              children: [
                PageView.builder(
                  onPageChanged: (int changedPageIndex) {
                    widget
                        .onRoutesClick(viewModel.routesList[changedPageIndex]);
                  },
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4,
                      shape: getCardShape(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(viewModel.routesList[index].title),
                            Text(
                                "${viewModel.routesList[index].srcLocation} - ${viewModel.routesList[index].dstLocation}"),
                            Text("Route # ${viewModel.routesList[index].id}"),
                          ],
                        ),
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
                      print("aaaaaaa" + viewModel.routesList[index].title);
                    },
                    controller: _controller,
                    itemCount: viewModel.routesList.length,
                    color: ThemeConfiguration.primaryBackground,
                  ),
                )
              ],
            )
          : Center(
              child: Container(
                child: Text("No Data"),
              ),
            ),
      viewModelBuilder: () => RoutesViewModel(),
    );
  }
}
