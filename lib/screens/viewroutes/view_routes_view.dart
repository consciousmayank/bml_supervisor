import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
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
                  title: Text("Routes"),
                ),
                body: getBody(context: context, viewModel: viewModel),
              ),
            ),
        viewModelBuilder: () => ViewRoutesViewModel());
  }

  Widget getBody({BuildContext context, ViewRoutesViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientsDropDown(
            optionList: viewModel.clientsList,
            hint: "Select Client",
            onOptionSelect: (GetClientsResponse selectedValue) =>
                viewModel.selectedClient = selectedValue,
            selectedClient: viewModel.selectedClient == null
                ? null
                : viewModel.selectedClient,
          ),
          hSizedBox(10),
          viewModel.selectedClient == null ? Container() : headerText("Routes"),
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
      ),
    );
  }
}
