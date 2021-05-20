import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/routes/routes_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'view_routes_viewmodel.dart';

class ViewRoutesView extends StatefulWidget {
  @override
  _ViewRoutesViewState createState() => _ViewRoutesViewState();
}

class _ViewRoutesViewState extends State<ViewRoutesView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewRoutesViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getClientIds(),
        builder: (context, viewModel, child) => SafeArea(
              left: false,
              right: false,
              child: Scaffold(
                appBar: AppBar(
                  title: setAppBarTitle(title: 'Route List'),
                ),
                body: getBody(context: context, viewModel: viewModel),
              ),
            ),
        viewModelBuilder: () => ViewRoutesViewModel());
  }

  Widget getBody({BuildContext context, ViewRoutesViewModel viewModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.selectedClient == null
            ? Container()
            : Expanded(
                child: RoutesView(
                  isInDashBoard: false,
                  selectedClient: viewModel.selectedClient,
                  onRoutesPageInView: (clickedRoute) {
                    FetchRoutesResponse route = clickedRoute;
                    viewModel.takeToHubsView(clickedRoute: route);
                  },
                ),
              ),
      ],
    );
  }
}
