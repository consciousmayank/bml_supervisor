import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:bml_supervisor/screens/viewconsignment/view_consignment_viewmodel.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:bml_supervisor/widget/consignment/single_consignment_view.dart';
import 'package:bml_supervisor/widget/routes/routes_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ViewConsignmentsView extends StatefulWidget {
  @override
  _ViewConsignmentsViewState createState() => _ViewConsignmentsViewState();
}

class _ViewConsignmentsViewState extends State<ViewConsignmentsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewConsignmentViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getClientIds(),
        builder: (context, viewModel, child) => SafeArea(
              left: false,
              right: false,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Consignments"),
                ),
                body: getBody(context: context, viewModel: viewModel),
              ),
            ),
        viewModelBuilder: () => ViewConsignmentViewModel());
  }

  Widget getBody({BuildContext context, ViewConsignmentViewModel viewModel}) {
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
          headerText("Routes"),
          viewModel.selectedClient == null
              ? Container()
              : SizedBox(
                  child: RoutesView(
                    selectedClient: viewModel.selectedClient,
                    onRoutesClick: (clickedRoute) {
                      FetchRoutesResponse route = clickedRoute;
                      print("${route.id}");
                      viewModel.selectedRoute = route;
                    },
                  ),
                  height: 200,
                  width: double.infinity,
                ),
          headerText("Hubs"),
          viewModel.selectedRoute == null
              ? Container()
              : Expanded(
                  child: SingleConsignmentView(
                    selectedRoute: viewModel.selectedRoute,
                    key: UniqueKey(),
                  ),
                )
        ],
      ),
    );
  }
}
